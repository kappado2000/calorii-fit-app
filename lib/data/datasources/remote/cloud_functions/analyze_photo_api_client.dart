import 'dart:convert';
import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_config.dart';
import '../../../models/analyzed_food_item.dart';

/// Anthropic downsamples images above this on its own side anyway (see
/// Claude vision docs), so sending anything larger only wastes upload
/// bandwidth and base64 overhead (~33%) for no accuracy gain.
const _maxUploadDimension = 1568;
const _jpegQuality = 82;

class AnalyzePhotoException implements Exception {
  AnalyzePhotoException(this.message, {this.status});
  final String message;

  /// The callable-function wire protocol's error status (e.g.
  /// `RESOURCE_EXHAUSTED`, `UNAUTHENTICATED`) — lets callers branch on
  /// *why* the call failed without parsing [message], which is server-side
  /// text in a fixed language, not localized per client.
  final String? status;

  bool get isQuotaExceeded => status == 'RESOURCE_EXHAUSTED';
  bool get isUnauthenticated => status == 'UNAUTHENTICATED';

  @override
  String toString() => 'AnalyzePhotoException: $message';
}

/// Talks to the `analyzePhoto` Cloud Function using the plain HTTPS
/// callable-function wire protocol ({"data": ...} in, {"result": ...} or
/// {"error": ...} out) — see functions/src/analyzePhoto.ts.
class AnalyzePhotoApiClient {
  AnalyzePhotoApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// [idToken] is the caller's Firebase ID token — analyzePhoto now
  /// requires an authenticated caller (it enforces a per-user daily quota
  /// against real abuse/cost, which needs a real uid to key off), even
  /// though this client still talks to the callable-function wire protocol
  /// directly rather than through the full Firebase SDK. A bare
  /// `Authorization: Bearer <token>` header is all `onCall` needs to
  /// populate `request.auth` server-side.
  Future<AnalyzePhotoResponse> analyze(File photoFile, {required String idToken}) async {
    final bytes = await _compressedBytes(photoFile);
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $idToken'};

    // Not yet required server-side (see the comment in main.dart next to
    // FirebaseAppCheck.instance.activate) — attached when available so the
    // function can start logging real-world coverage before enforcement is
    // ever turned on. A missing/failed token must never block the request.
    try {
      final appCheckToken = await FirebaseAppCheck.instance.getToken();
      if (appCheckToken != null) headers['X-Firebase-AppCheck'] = appCheckToken;
    } catch (_) {
      // Ignored — analysis proceeds without the header.
    }

    final response = await _httpClient.post(
      Uri.parse(AppConfig.analyzePhotoUrl),
      headers: headers,
      body: jsonEncode({
        // Compression always outputs JPEG, regardless of the source format.
        'data': {'imageBase64': base64Encode(bytes), 'mediaType': 'image/jpeg'},
      }),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      final error = decoded['error'] as Map<String, dynamic>?;
      throw AnalyzePhotoException(
        error?['message'] as String? ?? 'HTTP ${response.statusCode}',
        status: error?['status'] as String?,
      );
    }

    final result = decoded['result'] as Map<String, dynamic>?;
    if (result == null) {
      throw AnalyzePhotoException('Missing result in response.');
    }
    return AnalyzePhotoResponse.fromJson(result);
  }

  /// Resizes/recompresses the captured photo before upload — the native
  /// capture pipeline writes a full-resolution photo, far larger than
  /// Claude's vision input actually needs (see [_maxUploadDimension]),
  /// which wastes bandwidth and base64 overhead (~33% larger than raw
  /// bytes) for zero accuracy gain. Falls back to the original bytes if
  /// compression fails for any reason, rather than blocking analysis on a
  /// non-essential optimization.
  Future<List<int>> _compressedBytes(File photoFile) async {
    try {
      final compressed = await FlutterImageCompress.compressWithFile(
        photoFile.absolute.path,
        minWidth: _maxUploadDimension,
        minHeight: _maxUploadDimension,
        quality: _jpegQuality,
        format: CompressFormat.jpeg,
      );
      if (compressed != null && compressed.isNotEmpty) return compressed;
    } catch (_) {
      // Fall through to the uncompressed original below.
    }
    return photoFile.readAsBytes();
  }

  void dispose() => _httpClient.close();
}
