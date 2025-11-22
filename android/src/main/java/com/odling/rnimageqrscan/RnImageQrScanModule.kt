package com.odling.rnimageqrscan

import android.graphics.BitmapFactory
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.barcode.BarcodeScannerOptions
import com.google.mlkit.vision.barcode.common.Barcode
import com.google.mlkit.vision.common.InputImage
import java.io.File

@ReactModule(name = RnImageQrScanModule.NAME)
class RnImageQrScanModule(reactContext: ReactApplicationContext) :
  NativeRnImageQrScanSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun scanFromPath(path: String, promise: Promise) {
    // 1
    val options = BarcodeScannerOptions.Builder()
      .setBarcodeFormats(Barcode.FORMAT_QR_CODE)
      .build()

    // 2
    val rPath = path.replace("file:", "")
    val imgFile = File(rPath)
    if (!imgFile.exists()) {
      promise.reject("", "cannot get image from path: $path")
      return
    }

    // 3
    val bitmap = BitmapFactory.decodeFile(imgFile.absolutePath)
    if (bitmap == null) {
      promise.reject("", "Cannot decode image file. The file may be corrupted or in an unsupported format: $path")
      return
    }
    val image = InputImage.fromBitmap(bitmap, 0)

    // 4
    val scanner = BarcodeScanning.getClient(options)
    scanner.process(image)
      .addOnSuccessListener { barcodes ->
        val codes = barcodes.map { it.displayValue }
        val arr = Arguments.fromList(codes)
        promise.resolve(arr)
      }
      .addOnFailureListener {
        promise.reject("", it.localizedMessage, it)
      }
  }

  companion object {
    const val NAME = "RnImageQrScan"
  }
}
