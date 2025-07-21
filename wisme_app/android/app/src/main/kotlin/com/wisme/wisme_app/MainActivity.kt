package com.wisme.wisme_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL_BACKGROUND_AUDIO = "com.wisme.background_audio"
    private val NOTIFICATION_ID = 1
    private val NOTIFICATION_CHANNEL_ID = "audio_playback"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Create notification channel
        createNotificationChannel()
        
        // Setup background audio channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_BACKGROUND_AUDIO).setMethodCallHandler { call, result ->
            when (call.method) {
                "configureAudioSession" -> {
                    configureAudioSession(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Audio Playback",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Controls for audio playback"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun configureAudioSession(result: MethodChannel.Result) {
        try {
            // Android audio session configuration is handled by the AudioManager
            // and audioplayers plugin automatically
            result.success(true)
        } catch (e: Exception) {
            result.error("AUDIO_SESSION_ERROR", e.message, null)
        }
    }
}
