import Flutter
import UIKit
import AVFoundation
import MediaPlayer

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // Setup background audio channel
        let backgroundAudioChannel = FlutterMethodChannel(name: "com.wisme.background_audio", binaryMessenger: controller.binaryMessenger)
        backgroundAudioChannel.setMethodCallHandler(handleBackgroundAudioMethod)
        
        // Setup audio notification channel
        let audioNotificationChannel = FlutterMethodChannel(name: "com.wisme.audio_notification", binaryMessenger: controller.binaryMessenger)
        audioNotificationChannel.setMethodCallHandler(handleAudioNotificationMethod)
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func handleBackgroundAudioMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "configureAudioSession":
            configureAudioSession(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleAudioNotificationMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "showNotification":
            showNotification(call: call, result: result)
        case "updatePlaybackState":
            updatePlaybackState(call: call, result: result)
        case "updatePosition":
            updatePosition(call: call, result: result)
        case "hideNotification":
            hideNotification(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func configureAudioSession(result: @escaping FlutterResult) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            
            // Enable background audio
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            result(true)
        } catch {
            result(FlutterError(code: "AUDIO_SESSION_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func showNotification(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let title = args["title"] as? String,
              let artist = args["artist"] as? String,
              let album = args["album"] as? String,
              let isPlaying = args["isPlaying"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }
        
        let nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: artist,
            MPMediaItemPropertyAlbumTitle: album,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0,
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        // Setup remote control targets
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { _ in
            self.invokeFlutterMethod("onPlay", arguments: nil)
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { _ in
            self.invokeFlutterMethod("onPause", arguments: nil)
            return .success
        }
        
        commandCenter.stopCommand.isEnabled = true
        commandCenter.stopCommand.addTarget { _ in
            self.invokeFlutterMethod("onStop", arguments: nil)
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { _ in
            self.invokeFlutterMethod("onNext", arguments: nil)
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { _ in
            self.invokeFlutterMethod("onPrevious", arguments: nil)
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { event in
            if let positionEvent = event as? MPChangePlaybackPositionCommandEvent {
                let position = Int(positionEvent.positionTime * 1000) // Convert to milliseconds
                self.invokeFlutterMethod("onSeek", arguments: ["position": position])
            }
            return .success
        }
        
        result(true)
    }
    
    private func updatePlaybackState(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let isPlaying = args["isPlaying"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }
        
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        result(true)
    }
    
    private func updatePosition(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let position = args["position"] as? Int,
              let duration = args["duration"] as? Int else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }
        
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(position) / 1000.0
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Double(duration) / 1000.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        result(true)
    }
    
    private func hideNotification(result: @escaping FlutterResult) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.stopCommand.removeTarget(nil)
        commandCenter.nextTrackCommand.removeTarget(nil)
        commandCenter.previousTrackCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)
        
        result(true)
    }
    
    private func invokeFlutterMethod(_ method: String, arguments: [String: Any]?) {
        DispatchQueue.main.async {
            let controller = self.window?.rootViewController as! FlutterViewController
            let channel = FlutterMethodChannel(name: "com.wisme.audio_notification", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod(method, arguments: arguments)
        }
    }
}
