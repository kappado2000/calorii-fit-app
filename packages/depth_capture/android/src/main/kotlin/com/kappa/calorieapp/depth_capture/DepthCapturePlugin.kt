package com.kappa.calorieapp.depth_capture

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import com.google.ar.core.ArCoreApk
import com.google.ar.core.Config
import com.google.ar.core.Session
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import java.io.File
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

private const val CAMERA_PERMISSION_REQUEST_CODE = 4110

/** DepthCapturePlugin */
class DepthCapturePlugin :
    FlutterPlugin,
    ActivityAware,
    MethodCallHandler,
    RequestPermissionsResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    private var activity: Activity? = null
    private var pendingPermissionResult: Result? = null

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "depth_capture")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getCaptureCapabilities" -> {
                result.success(mapOf("bestAvailableSource" to bestAvailableDepthSource()))
            }
            "capturePhotoWithDepth" -> capturePhotoWithDepth(result)
            else -> result.notImplemented()
        }
    }

    private fun capturePhotoWithDepth(result: Result) {
        val currentActivity = activity
        if (currentActivity == null) {
            result.error("no_activity", "capturePhotoWithDepth requires a foreground activity", null)
            return
        }
        if (ContextCompat.checkSelfPermission(applicationContext, Manifest.permission.CAMERA) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            pendingPermissionResult = result
            androidx.core.app.ActivityCompat.requestPermissions(
                currentActivity,
                arrayOf(Manifest.permission.CAMERA),
                CAMERA_PERMISSION_REQUEST_CODE,
            )
            return
        }
        runCapture(currentActivity, result)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean {
        if (requestCode != CAMERA_PERMISSION_REQUEST_CODE) return false
        val result = pendingPermissionResult ?: return true
        pendingPermissionResult = null
        val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
        val currentActivity = activity
        if (!granted || currentActivity == null) {
            result.error("permission_denied", "Camera permission was denied", null)
        } else {
            runCapture(currentActivity, result)
        }
        return true
    }

    private fun runCapture(currentActivity: Activity, result: Result) {
        val lifecycleOwner = currentActivity as? LifecycleOwner
        if (lifecycleOwner == null) {
            result.error("unsupported_activity", "Host activity is not a LifecycleOwner", null)
            return
        }

        scope.launch {
            try {
                val outputFile =
                    File(applicationContext.cacheDir, "capture_${System.currentTimeMillis()}.jpg")
                val photo = CameraXPhotoCapture(applicationContext).capture(lifecycleOwner, outputFile)

                val depthSample =
                    if (bestAvailableDepthSource() == "arcoreDepth") {
                        ArCoreDepthSampler(applicationContext).sampleDepth()
                    } else {
                        null
                    }

                val response =
                    if (depthSample != null) {
                        mapOf(
                            "photoPath" to photo.filePath,
                            "depthSource" to "arcoreDepth",
                            "depthMap" to
                                mapOf(
                                    "widthPx" to depthSample.widthPx,
                                    "heightPx" to depthSample.heightPx,
                                    "depthValuesMeters" to depthSample.depthValuesMeters.toList(),
                                    "filePath" to photo.filePath,
                                ),
                            "intrinsics" to
                                mapOf(
                                    "focalLengthXPx" to depthSample.focalLengthXPx.toDouble(),
                                    "focalLengthYPx" to depthSample.focalLengthYPx.toDouble(),
                                    "principalPointXPx" to depthSample.principalPointXPx.toDouble(),
                                    "principalPointYPx" to depthSample.principalPointYPx.toDouble(),
                                ),
                        )
                    } else {
                        mapOf(
                            "photoPath" to photo.filePath,
                            "depthSource" to "referenceObjectOnly",
                            "referenceObjectScaleHint" to 30.0,
                        )
                    }
                result.success(response)
            } catch (e: Exception) {
                result.error("capture_failed", e.message, null)
            }
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
