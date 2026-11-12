package com.hearteli.userapp

import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
