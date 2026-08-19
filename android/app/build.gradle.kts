plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.kappa.calorieapp.calorie_app"
    // permission_handler_android (pulled in for Health Connect/Bluetooth
    // runtime permissions) requires compileSdk 37 — flutter.compileSdkVersion
    // is capped at 36 for this Flutter version, so it's overridden explicitly.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications' AAR metadata requires this to be
        // enabled, regardless of minSdk.
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.kappa.calorieapp.calorie_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // The `health` plugin (Health Connect sync) requires minSdk 26
        // (Android 8.0) — raised from Flutter's default of 24.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // camera_android_camerax's camera-core 1.5.3 references
    // androidx.concurrent.futures.CallbackToFutureAdapter in a type
    // annotation on a compiled class, but doesn't pull the artifact onto
    // the compile classpath itself here — without this, compileDebugJavaWithJavac
    // fails with "class file for androidx.concurrent.futures.CallbackToFutureAdapter
    // not found", even though nothing in this app references it directly.
    implementation("androidx.concurrent:concurrent-futures:1.2.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
