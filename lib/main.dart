import 'dart:async';

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
