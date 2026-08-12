package com.kappa.calorieapp.depth_capture

import android.content.Context
import android.graphics.SurfaceTexture
import com.google.ar.core.Config
import com.google.ar.core.Frame
import com.google.ar.core.Session
import com.google.ar.core.exceptions.NotYetAvailableException
import kotlinx.coroutines.delay

internal class DepthSample(
    val widthPx: Int,
    val heightPx: Int,
    val depthValuesMeters: FloatArray,
    val focalLengthXPx: Float,
    val focalLengthYPx: Float,
    val principalPointXPx: Float,
    val principalPointYPx: Float,
)

/**
 * Best-effort: opens a short-lived headless ARCore session purely to sample
 * one depth frame + its camera intrinsics. This runs alongside (not instead
 * of) the CameraX photo capture in [CameraXPhotoCapture], which remains the
 * source of the actual JPEG — decoupling "get a good photo" from "get a
 * depth map" keeps each half simple and lets the depth half fail without
 * losing the photo.
 *
 * NOT validated on a real ARCore-depth-capable device yet — this dev
 * machine's emulator has no Google Play Services for AR installed, so this
 * path has only been exercised via its exception-safe failure branch
 * (falling back to referenceObjectOnly, which IS confirmed working). Real
 * validation against real hardware is the Phase 1 exit criterion in the
 * project plan.
 */
internal class ArCoreDepthSampler(private val context: Context) {

    suspend fun sampleDepth(): DepthSample? {
        val glContext = HeadlessGlContext()
        var session: Session? = null
        var surfaceTexture: SurfaceTexture? = null
        try {
            glContext.setUp()
            surfaceTexture = SurfaceTexture(glContext.textureId)

            session = Session(context)
            val config = Config(session)
            config.depthMode = Config.DepthMode.AUTOMATIC
            config.focusMode = Config.FocusMode.AUTO
            session.configure(config)
            session.setCameraTextureName(glContext.textureId)
            session.resume()

            // Let auto-exposure/focus and the depth estimator settle before
            // trusting a frame — a handful of frames is the commonly
            // recommended minimum for usable ARCore depth quality.
            var frame: Frame? = null
            repeat(10) {
                frame = session.update()
                delay(80)
            }
            val finalFrame = frame ?: return null

            val depthImage =
                try {
                    finalFrame.acquireDepthImage16Bits()
                } catch (e: NotYetAvailableException) {
                    return null
                }

            val intrinsics = finalFrame.camera.imageIntrinsics
            val focalLength = intrinsics.focalLength
            val principalPoint = intrinsics.principalPoint

            val width = depthImage.width
            val height = depthImage.height
            val plane = depthImage.planes[0]
            val buffer = plane.buffer
            val rowStride = plane.rowStride
            val pixelStride = plane.pixelStride

            val depthValuesMeters = FloatArray(width * height)
            for (y in 0 until height) {
                for (x in 0 until width) {
                    val offset = y * rowStride + x * pixelStride
                    val lowByte = buffer.get(offset).toInt() and 0xFF
                    val highByte = buffer.get(offset + 1).toInt() and 0xFF
                    val rawSample = lowByte or (highByte shl 8)
                    // ARCore's DEPTH16 format: bits [12:0] = depth in mm,
                    // bits [15:13] reserved/confidence — mask them off.
                    val millimeters = rawSample and 0x1FFF
                    depthValuesMeters[y * width + x] = millimeters / 1000f
                }
            }
            depthImage.close()

            return DepthSample(
                widthPx = width,
                heightPx = height,
                depthValuesMeters = depthValuesMeters,
                focalLengthXPx = focalLength[0],
                focalLengthYPx = focalLength[1],
                principalPointXPx = principalPoint[0],
                principalPointYPx = principalPoint[1],
            )
        } catch (e: Exception) {
            return null
        } finally {
            try {
                session?.pause()
            } catch (_: Exception) {
            }
            try {
                session?.close()
            } catch (_: Exception) {
            }
            surfaceTexture?.release()
            glContext.tearDown()
        }
    }
}
