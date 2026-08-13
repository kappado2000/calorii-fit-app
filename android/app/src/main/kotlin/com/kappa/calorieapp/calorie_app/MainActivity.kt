package com.kappa.calorieapp.calorie_app

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (not FlutterActivity) is required by the `health`
// plugin on Android 14+, which uses registerForActivityResult when
// requesting Health Connect permissions.
class MainActivity : FlutterFragmentActivity()
