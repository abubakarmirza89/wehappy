package com.hearteli.userapp

import android.app.Activity
import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.provider.DocumentsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val exportRequest = 9120
    private var pendingExport: Pair<ByteArray, MethodChannel.Result>? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != exportRequest) return
        val (bytes, result) = pendingExport ?: return
        pendingExport = null
        val destination = data?.data
        if (resultCode != Activity.RESULT_OK || destination == null) {
            result.success(false)
            return
        }
        Thread {
            try {
                contentResolver.openOutputStream(destination, "wt")?.use {
                    it.write(bytes)
                } ?: error("No writable destination")
                runOnUiThread { result.success(true) }
            } catch (_: Exception) {
                try {
                    DocumentsContract.deleteDocument(contentResolver, destination)
                } catch (_: Exception) {
                    // Some document providers do not permit deletion.
                }
                runOnUiThread { result.error("save_failed", "Could not save archive.", null) }
            }
        }.start()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hearteli/data_export")
            .setMethodCallHandler { call, result ->
                if (call.method != "save") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val bytes = call.argument<ByteArray>("bytes")
                val name = call.argument<String>("filename")
                if (pendingExport != null || bytes == null || bytes.size > 34 * 1024 * 1024 ||
                    name == null || !name.matches(Regex("hearteli-data-export-[0-9-]+\\.zip"))) {
                    result.error("invalid_export", "Cannot start archive save.", null)
                    return@setMethodCallHandler
                }
                pendingExport = Pair(bytes, result)
                try {
                    startActivityForResult(Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "application/zip"
                        putExtra(Intent.EXTRA_TITLE, name)
                    }, exportRequest)
                } catch (_: Exception) {
                    pendingExport = null
                    result.error("picker_unavailable", "Cannot open the save dialog.", null)
                }
            }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "hearteli/notification_settings"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enabled" -> {
                    val enabled = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        getSystemService(NotificationManager::class.java)?.areNotificationsEnabled()
                    } else {
                        null // The existing Firebase permission check handles older devices.
                    }
                    result.success(enabled)
                }
                "open" -> {
                    val appDetails = Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.fromParts("package", packageName, null)
                    )
                    val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                            .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                    } else {
                        appDetails
                    }
                    try {
                        startActivity(intent)
                        result.success(null)
                    } catch (_: android.content.ActivityNotFoundException) {
                        try {
                            startActivity(appDetails)
                            result.success(null)
                        } catch (_: android.content.ActivityNotFoundException) {
                            result.error("settings_unavailable", "Cannot open notification settings.", null)
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
