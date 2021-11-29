package com.bcit.transiteasy

import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val startString = intent.data?.toString()
        val action: String? = intent?.action
        val data: Uri? = intent?.data
    }
}
