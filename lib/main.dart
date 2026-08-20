import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Loads month/day name data for every supported locale — DateFormat
  // throws on first use of a non-'en_US' locale otherwise (see
  // food_log_screen.dart's date header, which uses the device/app locale's
  // real month names instead of a hand-translated list).
  await initializeDateFormatting();
  runApp(const ProviderScope(child: CalorieApp()));
}
