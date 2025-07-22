package com.wisme.wisme_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.media.session.MediaButtonReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL_BACKGROUND_AUDIO = "com.wisme.background_audio"
    private val CHANNEL_AUDIO_NOTIFICATION = "com.wisme.audio_notification"
    private val NOTIFICATION_ID = 1
    private val NOTIFICATION_CHANNEL_ID = "audio_playback"
    
    private lateinit var mediaSession: MediaSessionCompat
    private lateinit var notificationManager: NotificationManagerCompat
    private var audioNotificationChannel: MethodChannel? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Setup notification manager
        notificationManager = NotificationManagerCompat.from(this)
        createNotificationChannel()
        
        // Setup media session
        setupMediaSession()
        
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
        
        // Setup audio notification channel
        audioNotificationChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_AUDIO_NOTIFICATION)
        audioNotificationChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "showNotification" -> {
                    showNotification(call.arguments as Map<String, Any>, result)
                }
                "updatePlaybackState" -> {
                    updatePlaybackState(call.arguments as Map<String, Any>, result)
                }
                "updatePosition" -> {
                    updatePosition(call.arguments as Map<String, Any>, result)
                }
                "hideNotification" -> {
                    hideNotification(result)
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
    
    private fun setupMediaSession() {
        mediaSession = MediaSessionCompat(this, "WismeAudioPlayer")
        mediaSession.setCallback(object : MediaSessionCompat.Callback() {
            override fun onPlay() {
                invokeFlutterMethod("onPlay", null)
            }
            
            override fun onPause() {
                invokeFlutterMethod("onPause", null)
            }
            
            override fun onStop() {
                invokeFlutterMethod("onStop", null)
            }
            
            override fun onSkipToNext() {
                invokeFlutterMethod("onNext", null)
            }
            
            override fun onSkipToPrevious() {
                invokeFlutterMethod("onPrevious", null)
            }
            
            override fun onSeekTo(pos: Long) {
                val arguments = mapOf("position" to pos.toInt())
                invokeFlutterMethod("onSeek", arguments)
            }
        })
        
        mediaSession.isActive = true
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
    
    private fun showNotification(arguments: Map<String, Any>, result: MethodChannel.Result) {
        try {
            val title = arguments["title"] as String
            val artist = arguments["artist"] as String
            val album = arguments["album"] as String
            val isPlaying = arguments["isPlaying"] as Boolean
            
            val playPauseAction = if (isPlaying) {
                NotificationCompat.Action.Builder(
                    android.R.drawable.ic_media_pause,
                    "Pause",
                    MediaButtonReceiver.buildMediaButtonPendingIntent(
                        this,
                        PlaybackStateCompat.ACTION_PAUSE
                    )
                ).build()
            } else {
                NotificationCompat.Action.Builder(
                    android.R.drawable.ic_media_play,
                    "Play",
                    MediaButtonReceiver.buildMediaButtonPendingIntent(
                        this,
                        PlaybackStateCompat.ACTION_PLAY
                    )
                ).build()
            }
            
            val notification = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
                .setContentTitle(title)
                .setContentText(artist)
                .setSubText(album)
                .setSmallIcon(android.R.drawable.ic_media_play)
                .setStyle(androidx.media.app.NotificationCompat.MediaStyle()
                    .setMediaSession(mediaSession.sessionToken)
                    .setShowActionsInCompactView(0, 1, 2))
                .addAction(
                    NotificationCompat.Action.Builder(
                        android.R.drawable.ic_media_previous,
                        "Previous",
                        MediaButtonReceiver.buildMediaButtonPendingIntent(
                            this,
                            PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS
                        )
                    ).build()
                )
                .addAction(playPauseAction)
                .addAction(
                    NotificationCompat.Action.Builder(
                        android.R.drawable.ic_media_next,
                        "Next",
                        MediaButtonReceiver.buildMediaButtonPendingIntent(
                            this,
                            PlaybackStateCompat.ACTION_SKIP_TO_NEXT
                        )
                    ).build()
                )
                .setOngoing(isPlaying)
                .build()
            
            notificationManager.notify(NOTIFICATION_ID, notification)
            
            // Update media session state
            val state = if (isPlaying) PlaybackStateCompat.STATE_PLAYING else PlaybackStateCompat.STATE_PAUSED
            mediaSession.setPlaybackState(
                PlaybackStateCompat.Builder()
                    .setState(state, PlaybackStateCompat.PLAYBACK_POSITION_UNKNOWN, 1.0f)
                    .setActions(
                        PlaybackStateCompat.ACTION_PLAY or
                        PlaybackStateCompat.ACTION_PAUSE or
                        PlaybackStateCompat.ACTION_SKIP_TO_NEXT or
                        PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS or
                        PlaybackStateCompat.ACTION_SEEK_TO
                    )
                    .build()
            )
            
            result.success(true)
        } catch (e: Exception) {
            result.error("NOTIFICATION_ERROR", e.message, null)
        }
    }
    
    private fun updatePlaybackState(arguments: Map<String, Any>, result: MethodChannel.Result) {
        try {
            val isPlaying = arguments["isPlaying"] as Boolean
            
            val state = if (isPlaying) PlaybackStateCompat.STATE_PLAYING else PlaybackStateCompat.STATE_PAUSED
            mediaSession.setPlaybackState(
                PlaybackStateCompat.Builder()
                    .setState(state, PlaybackStateCompat.PLAYBACK_POSITION_UNKNOWN, 1.0f)
                    .setActions(
                        PlaybackStateCompat.ACTION_PLAY or
                        PlaybackStateCompat.ACTION_PAUSE or
                        PlaybackStateCompat.ACTION_SKIP_TO_NEXT or
                        PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS or
                        PlaybackStateCompat.ACTION_SEEK_TO
                    )
                    .build()
            )
            
            result.success(true)
        } catch (e: Exception) {
            result.error("PLAYBACK_STATE_ERROR", e.message, null)
        }
    }
    
    private fun updatePosition(arguments: Map<String, Any>, result: MethodChannel.Result) {
        try {
            val position = arguments["position"] as Int
            val duration = arguments["duration"] as Int
            
            mediaSession.setPlaybackState(
                PlaybackStateCompat.Builder()
                    .setState(
                        PlaybackStateCompat.STATE_PLAYING,
                        position.toLong(),
                        1.0f
                    )
                    .setActions(
                        PlaybackStateCompat.ACTION_PLAY or
                        PlaybackStateCompat.ACTION_PAUSE or
                        PlaybackStateCompat.ACTION_SKIP_TO_NEXT or
                        PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS or
                        PlaybackStateCompat.ACTION_SEEK_TO
                    )
                    .build()
            )
            
            result.success(true)
        } catch (e: Exception) {
            result.error("POSITION_ERROR", e.message, null)
        }
    }
    
    private fun hideNotification(result: MethodChannel.Result) {
        try {
            notificationManager.cancel(NOTIFICATION_ID)
            mediaSession.isActive = false
            result.success(true)
        } catch (e: Exception) {
            result.error("HIDE_NOTIFICATION_ERROR", e.message, null)
        }
    }
    
    private fun invokeFlutterMethod(method: String, arguments: Map<String, Any>?) {
        runOnUiThread {
            audioNotificationChannel?.invokeMethod(method, arguments)
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        mediaSession.release()
    }
}
