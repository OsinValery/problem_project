package com.example.problem_project

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import java.util.Locale

class MainActivity: FlutterActivity() {
    private val CHANNEL = "platformJobs"

    private fun checkIsEmu(): Boolean {
      if (BuildConfig.DEBUG) return false // when developer use this build on emulator
      val phoneModel = Build.MODEL 
      val buildProduct = Build.PRODUCT
      val buildHardware = Build.HARDWARE

      var result = (Build.FINGERPRINT.startsWith("generic")
        || phoneModel.contains("google_sdk")
        || phoneModel.lowercase(Locale.getDefault()).contains("droid4x")
        || phoneModel.contains("Emulator")
        || phoneModel.contains("Android SDK built for x86")
        || Build.MANUFACTURER.contains("Genymotion")
        || buildHardware == "goldfish"
        || Build.BRAND.contains("google")
        || buildHardware == "vbox86"
        || buildProduct == "sdk"
        || buildProduct == "google_sdk"
        || buildProduct == "sdk_x86"
        || buildProduct == "vbox86p"
        || Build.BOARD.lowercase(Locale.getDefault()).contains("nox")
        || Build.BOOTLOADER.lowercase(Locale.getDefault()).contains("nox")
        || buildHardware.lowercase(Locale.getDefault()).contains("nox")
        || buildProduct.lowercase(Locale.getDefault()).contains("nox"))

      if (result) return true
      result = result or (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) 
      if (result) return true
      result = result or ("google_sdk" == buildProduct) 
      return result
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
          call, result ->
          if (call.method == "devInfo") {
            var brand = Build.BRAND
            var emulator = checkIsEmu()
            var strEmulator = ""
            if (emulator) {
                strEmulator = "true"
            } else {
                strEmulator = "false"
            }
            val resultMap = mapOf<String, String>("brand" to brand, "emulator" to strEmulator)
            result.success(resultMap)
          } else {
            result.notImplemented()
          }
        }
      }
}
