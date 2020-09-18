package com.hoc.datn

import io.flutter.embedding.android.FlutterActivity

import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    try {
      val info = packageManager.getPackageInfo("com.hoc.datn", PackageManager.GET_SIGNATURES)
      info.signatures.forEach { signature ->
        val md: MessageDigest =
            MessageDigest.getInstance("SHA").apply { update(signature.toByteArray()) }
        val something = String(Base64.encode(md.digest(), 0))
        Log.d("[FIND_ROOM]", something)
        Log.i("Flutter", something)
      }
    } catch (e: Exception) {
      Log.d("[ERROR]", e.toString(), e)
      Log.i("Flutter", e.toString(), e)
    }
  }
}
