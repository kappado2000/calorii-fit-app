import 'dart:convert';
import 'dart:io';

import 'package:depth_capture/depth_capture.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:calorie_app/data/datasources/remote/cloud_functions/analyze_photo_api_client.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/camera_capture/camera_capture_controller.dart';
import 'package:calorie_app/features/camera_capture/camera_capture_state.dart';
import 'package:calorie_app/platform/depth_capture_channel.dart';

/// Always returns the same reference-object-fallback capture (no depth map,
/// so VolumeToCalorieCalculator takes its rough-estimate path) pointing at a
/// real, tiny file on disk — analyzePhoto's client reads real bytes off
/// [photoPath], so it must exist even though its content is never inspected
/// by the fake HTTP layer below.
class _FakeDepthCaptureChannel extends DepthCaptureChannel {
  _FakeDepthCaptureChannel(this.photoPath) : super(DepthCapture());

  final String photoPath;

  @override
  Future<DepthCaptureResult> capturePhotoWithDepth() async {
    return DepthCaptureResult(photoPath: photoPath, depthSource: DepthSource.referenceObjectOnly);
  }
}

/// Simulates a native capture failure unrelated to the network (e.g. camera
/// hardware busy) — used to confirm unrelated errors still fall through to
/// the generic [CaptureFailureReason.unknown] path rather than being
/// misclassified as a network/quota failure.
class _ThrowingDepthCaptureChannel extends DepthCaptureChannel {
  _ThrowingDepthCaptureChannel() : super(DepthCapture());

  @override
  Future<DepthCaptureResult> capturePhotoWithDepth() async {
    throw StateError('camera hardware busy');
  }
}

void main() {
  late Directory tempDir;
  late String photoPath;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('camera_capture_controller_test');
    photoPath = '${tempDir.path}/plate.jpg';
    File(photoPath).writeAsBytesSync([0xFF, 0xD8, 0xFF]);
  });

  tearDown(() => tempDir.deleteSync(recursive: true));

  ProviderContainer buildContainer({
    required DepthCaptureChannel depthCaptureChannel,
    http.Client? httpClient,
    bool signedIn = true,
  }) {
    final mockAuth = signedIn
        ? MockFirebaseAuth(mockUser: MockUser(uid: 'test-uid', email: 'test@example.com'), signedIn: true)
        : MockFirebaseAuth(signedIn: false);

    final container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockAuth),
        depthCaptureChannelProvider.overrideWithValue(depthCaptureChannel),
        if (httpClient != null) analyzePhotoApiClientProvider.overrideWithValue(AnalyzePhotoApiClient(httpClient: httpClient)),
      ],
    );
    // cameraCaptureControllerProvider is .autoDispose — a bare read()
    // doesn't count as a listener, so without this the provider (and the
    // controller instance under test) gets torn down mid-flight, the
    // instant Riverpod notices nothing is watching it, which races with
    // captureAndAnalyze()'s awaited network call below.
    container.listen(cameraCaptureControllerProvider, (_, _) {});
    return container;
  }

  test('successful capture ends in AwaitingConfirmation with the identified item', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'result': {
            'mixedPlateDetected': false,
            'overallConfidence': 0.9,
            'items': [
              {
                'label': 'Grilled chicken breast',
                'confidence': 0.92,
                'boundingBox': {'xMin': 0.1, 'yMin': 0.1, 'xMax': 0.5, 'yMax': 0.5},
                'estimatedDensityCategory': 'denseMeat',
                'textureCues': 'grilled, dry surface',
              },
            ],
          },
        }),
        200,
      );
    });
    final container = buildContainer(
      depthCaptureChannel: _FakeDepthCaptureChannel(photoPath),
      httpClient: client,
    );
    addTearDown(container.dispose);

    await container.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze();

    final state = container.read(cameraCaptureControllerProvider);
    if (state is CaptureFailed) {
      fail('CaptureFailed: reason=${state.reason} message=${state.message}');
    }
    expect(state, isA<AwaitingConfirmation>());
    final items = (state as AwaitingConfirmation).items;
    expect(items, hasLength(1));
    expect(items.single.analyzed.label, 'Grilled chicken breast');
  });

  test('no signed-in user fails with CaptureFailureReason.unauthenticated, without calling the network', () async {
    var httpCalled = false;
    final client = MockClient((request) async {
      httpCalled = true;
      return http.Response('{}', 200);
    });
    final container = buildContainer(
      depthCaptureChannel: _FakeDepthCaptureChannel(photoPath),
      httpClient: client,
      signedIn: false,
    );
    addTearDown(container.dispose);

    await container.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze();

    final state = container.read(cameraCaptureControllerProvider);
    expect(state, isA<CaptureFailed>());
    expect((state as CaptureFailed).reason, CaptureFailureReason.unauthenticated);
    expect(httpCalled, isFalse);
  });

  test('server RESOURCE_EXHAUSTED status fails with CaptureFailureReason.quotaExceeded', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'error': {'message': 'Ai atins limita de 20 analize foto pe zi.', 'status': 'RESOURCE_EXHAUSTED'},
        }),
        429,
      );
    });
    final container = buildContainer(
      depthCaptureChannel: _FakeDepthCaptureChannel(photoPath),
      httpClient: client,
    );
    addTearDown(container.dispose);

    await container.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze();

    final state = container.read(cameraCaptureControllerProvider);
    expect(state, isA<CaptureFailed>());
    expect((state as CaptureFailed).reason, CaptureFailureReason.quotaExceeded);
  });

  test('a socket exception during upload fails with CaptureFailureReason.network', () async {
    final client = MockClient((request) async {
      throw const SocketException('Connection failed');
    });
    final container = buildContainer(
      depthCaptureChannel: _FakeDepthCaptureChannel(photoPath),
      httpClient: client,
    );
    addTearDown(container.dispose);

    await container.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze();

    final state = container.read(cameraCaptureControllerProvider);
    expect(state, isA<CaptureFailed>());
    expect((state as CaptureFailed).reason, CaptureFailureReason.network);
  });

  test('an unrelated capture failure falls through to CaptureFailureReason.unknown', () async {
    final container = buildContainer(depthCaptureChannel: _ThrowingDepthCaptureChannel());
    addTearDown(container.dispose);

    await container.read(cameraCaptureControllerProvider.notifier).captureAndAnalyze();

    final state = container.read(cameraCaptureControllerProvider);
    expect(state, isA<CaptureFailed>());
    expect((state as CaptureFailed).reason, CaptureFailureReason.unknown);
  });

  test('reset() returns to CaptureIdle', () async {
    final container = buildContainer(depthCaptureChannel: _ThrowingDepthCaptureChannel());
    addTearDown(container.dispose);
    final notifier = container.read(cameraCaptureControllerProvider.notifier);

    await notifier.captureAndAnalyze();
    expect(container.read(cameraCaptureControllerProvider), isA<CaptureFailed>());

    notifier.reset();
    expect(container.read(cameraCaptureControllerProvider), isA<CaptureIdle>());
  });
}
