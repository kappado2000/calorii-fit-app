package com.kappa.calorieapp.depth_capture

import android.content.Context
import com.google.ar.core.ArCoreApk
import com.google.ar.core.Config
import com.google.ar.core.Session
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DepthCapturePlugin */
class DepthCapturePlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "depth_capture")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getCaptureCapabilities" -> {
                result.success(mapOf("bestAvailableSource" to bestAvailableDepthSource()))
            }
            "capturePhotoWithDepth" -> {
                // Phase 1: implement ArCore Depth API / reference-object capture.
                // Phase 0 only wires the capability check end-to-end.
                result.error(
                    "not_implemented",
                    "capturePhotoWithDepth is implemented in Phase 1",
                    null
                )
            }
            else -> result.notImplemented()
        }
    }

    /** Fallback order: ArCore Depth API -> reference-object (plate diameter) 2D fallback. */
    private fun bestAvailableDepthSource(): String {
        val availability = ArCoreApk.getInstance().checkAvailability(applicationContext)
        if (!availability.isSupported) {
            return "referenceObjectOnly"
        }
        return try {
            val session = Session(applicationContext)
            val supportsDepth = session.isDepthModeSupported(Config.DepthMode.AUTOMATIC)
            session.close()
            if (supportsDepth) "arcoreDepth" else "referenceObjectOnly"
        } catch (e: Exception) {
            "referenceObjectOnly"
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
