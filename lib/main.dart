import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Attaches an App Check token to outgoing Firebase requests where the
      // platform SDK supports it. This alone does not protect anything yet
      // — analyzePhoto does not require/verify the token server-side (see
      // functions/src/analyzePhoto.ts), on purpose: enforcing it before the
      // app is registered with real attestation providers in the Firebase
      // console (Play Integrity for Android; App Attest, which needs a paid
      // Apple Developer account, for iOS) would reject every request,
      // including from this app's own Sideloadly test builds. Debug
      // providers are used here so a local/sideloaded build can still
      // generate *a* token without that console setup; switch to
      // AndroidPlayIntegrityProvider() / AppleAppAttestWithDeviceCheckFallbackProvider()
      // once the console side is registered, then flip enforceAppCheck on
      // in the Cloud Function.
      await FirebaseAppCheck.instance.activate(
        providerAndroid: AndroidDebugProvider(),
        providerApple: AppleDebugProvider(),
      );

      // Loads month/day name data for every supported locale — DateFormat
      // throws on first use of a non-'en_US' locale otherwise (see
      // food_log_screen.dart's date header, which uses the device/app locale's
      // real month names instead of a hand-translated list).
      await initializeDateFormatting();

      // Route every crash/error to Crashlytics instead of only the debug
      // console — before this, there was zero visibility into whether the
      // app was crashing for real users after a release. Skipped in debug
      // builds so local development noise doesn't pollute production data.
      if (!kDebugMode) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      runApp(const ProviderScope(child: CalorieApp()));
    },
    (error, stack) {
      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}
