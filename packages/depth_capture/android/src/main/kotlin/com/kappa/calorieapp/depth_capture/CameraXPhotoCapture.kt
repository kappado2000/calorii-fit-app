package com.kappa.calorieapp.depth_capture

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import androidx.camera.camera2.interop.Camera2CameraInfo
import androidx.camera.core.CameraInfo
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageCapture
import androidx.camera.core.ImageCaptureException
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import java.io.File
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlinx.coroutines.suspendCancellableCoroutine

internal class PhotoCaptureResult(
    val filePath: String,
    val widthPx: Int,
    val heightPx: Int,
    val focalLengthXPx: Float,
    val focalLengthYPx: Float,
)

/** Straightforward CameraX still-photo capture — the reliable, always-available half of the pipeline. */
internal class CameraXPhotoCapture(private val context: Context) {

    suspend fun capture(lifecycleOwner: LifecycleOwner, outputFile: File): PhotoCaptureResult {
        val cameraProvider = getCameraProvider()
        val imageCapture =
            ImageCapture.Builder().setCaptureMode(ImageCapture.CAPTURE_MODE_MAXIMIZE_QUALITY).build()

        cameraProvider.unbindAll()
        val camera =
            cameraProvider.bindToLifecycle(lifecycleOwner, CameraSelector.DEFAULT_BACK_CAMERA, imageCapture)
        val intrinsics = extractIntrinsics(camera.cameraInfo)

        val outputOptions = ImageCapture.OutputFileOptions.Builder(outputFile).build()
        suspendCancellableCoroutine<Unit> { cont ->
            imageCapture.takePicture(
                outputOptions,
                ContextCompat.getMainExecutor(context),
                object : ImageCapture.OnImageSavedCallback {
                    override fun onImageSaved(output: ImageCapture.OutputFileResults) {
                        cont.resume(Unit)
                    }

                    override fun onError(exception: ImageCaptureException) {
                        cont.resumeWithException(exception)
                    }
                },
            )
        }

        cameraProvider.unbindAll()

        return PhotoCaptureResult(
            filePath = outputFile.absolutePath,
            widthPx = intrinsics.widthPx,
            heightPx = intrinsics.heightPx,
            focalLengthXPx = intrinsics.focalLengthXPx,
            focalLengthYPx = intrinsics.focalLengthXPx,
        )
    }

    private suspend fun getCameraProvider(): ProcessCameraProvider =
        suspendCancellableCoroutine { cont ->
            val future = ProcessCameraProvider.getInstance(context)
            future.addListener({ cont.resume(future.get()) }, ContextCompat.getMainExecutor(context))
        }

    private class Intrinsics(val widthPx: Int, val heightPx: Int, val focalLengthXPx: Float)

    /**
     * Derives an approximate focal length in pixels from Camera2
     * characteristics (focal length in mm x imageWidthPx / sensorWidthMm —
     * standard pinhole-camera conversion). Falls back to a generic
     * smartphone-camera assumption if the device doesn't expose this
     * metadata, rather than failing the whole capture.
     */
    private fun extractIntrinsics(cameraInfo: CameraInfo): Intrinsics {
        return try {
            val camera2Info = Camera2CameraInfo.from(cameraInfo)
            val focalLengthsMm =
                camera2Info.getCameraCharacteristic(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)
            val sensorSizeMm =
                camera2Info.getCameraCharacteristic(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)
            val pixelArraySize =
                camera2Info.getCameraCharacteristic(CameraCharacteristics.SENSOR_INFO_PIXEL_ARRAY_SIZE)

            val focalLengthMm = focalLengthsMm?.firstOrNull() ?: 4.2f
            val sensorWidthMm = sensorSizeMm?.width ?: 5.6f
            val widthPx = pixelArraySize?.width ?: 4000
            val heightPx = pixelArraySize?.height ?: 3000

            Intrinsics(widthPx, heightPx, focalLengthMm / sensorWidthMm * widthPx)
        } catch (e: Exception) {
            Intrinsics(4000, 3000, 3000f)
        }
    }
}
