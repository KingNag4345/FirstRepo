//
//  TangoPlayer.swift
//  TTPlayerDemo
//
//  Created by Nagaraju Surisetty on 27/11/17.
//  Copyright © 2017 Nagaraju Surisetty. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

/// play state
///
/// - none: none
/// - playing: playing
/// - paused: pause
/// - playFinished: finished
/// - error: play failed
public enum TangoPlayerState: Int {
    case none            // default
    case playing
    case paused
    case resume
    case playFinished
    case error
}

/// buffer state
///
/// - none: none
/// - readyToPlay: ready To Play
/// - buffering: buffered
/// - stop : buffer error stop
/// - bufferFinished: finished
public enum TangoPlayerBufferstate: Int {
    case none           // default
    case readyToPlay
    case buffering
    case stop
    case bufferFinished
}

/// play video content mode
///
/// - resize: Stretch to fill layer bounds.
/// - resizeAspect: Preserve aspect ratio; fit within layer bounds.
/// - resizeAspectFill: Preserve aspect ratio; fill layer bounds.
public enum TangoVideoGravityMode: Int {
    case resize
    case resizeAspect      // default
    case resizeAspectFill
}

/// play background mode
///
/// - suspend: suspend
/// - autoPlayAndPaused: auto play and Paused
/// - proceed: continue
public enum TangoPlayerBackgroundMode: Int {
    case suspend
    case autoPlayAndPaused
    case proceed
}

private struct Observation {
    static let VolumeKey = "outputVolume"
    static var Context = 0
    
}

public protocol TangoPlayerDelegate: class {
    // play state
    func tangoPlayer(_ player: TangoPlayer, stateDidChange state: TangoPlayerState)
    // playe Duration
    func tangoPlayer(_ player: TangoPlayer, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval)
    // buffer state
    func tangoPlayer(_ player: TangoPlayer, bufferStateDidChange state: TangoPlayerBufferstate)
    // buffered Duration
    func tangoPlayer(_ player: TangoPlayer, bufferedDidChange bufferedDuration: TimeInterval, totalDuration: TimeInterval)
    // play error
    func tangoPlayer(_ player: TangoPlayer, playerFailed error: TangoPlayerError)
    // player Periodic Observer
    func tangoPlayerPeriodicObserver(_ player: TangoPlayer, playercurrentTime:Int,DifferenceTime:Int, videoBounds: CGRect,isForwarded:Bool)
    // player reached to end
    func tangoPlayerdidReachedToend(_ player: TangoPlayer)
}

// MARK: - delegate methods optional
public extension TangoPlayerDelegate {
    func tangoPlayer(_ player: TangoPlayer, stateDidChange state: TangoPlayerState) {}
    func tangoPlayer(_ player: TangoPlayer, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval) {}
    func tangoPlayer(_ player: TangoPlayer, bufferStateDidChange state: TangoPlayerBufferstate) {}
    func tangoPlayer(_ player: TangoPlayer, bufferedDidChange bufferedDuration: TimeInterval, totalDuration: TimeInterval) {}
    func tangoPlayer(_ player: TangoPlayer, playerFailed error: TangoPlayerError) {}
    func tangoPlayerPeriodicObserver(_ player: TangoPlayer, playercurrentTime:Int,DifferenceTime:Int, videoBounds: CGRect,isForwarded:Bool){}
    func tangoPlayerdidReachedToend(_ player: TangoPlayer){}
}
open class TangoPlayer: NSObject {
    
    open var state: TangoPlayerState = .none {
        didSet {
            if state != oldValue {
                self.displayView.playStateDidChange(state)
                self.delegate?.tangoPlayer(self, stateDidChange: state)
            }
        }
    }
    
    open var bufferState : TangoPlayerBufferstate = .none {
        didSet {
            if bufferState != oldValue {
                self.displayView.bufferStateDidChange(bufferState)
                self.delegate?.tangoPlayer(self, bufferStateDidChange: bufferState)
            }
        }
    }
    
    open var displayView       : TangoPlayerView
    open var gravityMode       : TangoVideoGravityMode = .resizeAspect
    open var backgroundMode    : TangoPlayerBackgroundMode = .autoPlayAndPaused
    open var bufferInterval    : TimeInterval = 2.0
    open weak var delegate     : TangoPlayerDelegate?
    open var oldMiliSec        : Int = 0
    open var volumeValue       : Float = 0
    open var audioTracksList   = NSMutableArray()
    open var tilteTracksList   = NSMutableArray()
    open fileprivate(set) var mediaFormat : TangoPlayerMediaFormat
    open fileprivate(set) var totalDuration : TimeInterval = 0.0
    open fileprivate(set) var currentDuration : TimeInterval = 0.0
    open fileprivate(set) var buffering : Bool = false
    open fileprivate(set) var audioSession = AVAudioSession.sharedInstance()
    open fileprivate(set) var player : AVPlayer? {
        willSet{
            removePlayerObservers()
        }
        didSet {
            addPlayerObservers()
        }
    }
    private var timeObserver: Any?
    
    open fileprivate(set) var playerItem : AVPlayerItem? {
        willSet {
            removePlayerItemObservers()
            removePlayerNotifations()
        }
        didSet {
            addPlayerItemObservers()
            addPlayerNotifications()
        }
    }
    
    open fileprivate(set) var playerAsset : AVURLAsset?
    open fileprivate(set) var contentURL : URL?
    
    open fileprivate(set) var error : TangoPlayerError
    
    fileprivate var seeking : Bool = false
    //fileprivate var resourceLoaderManager = VGPlayerResourceLoaderManager()
    
    //MARK:- life cycle
    public init(URL: URL?, playerView: TangoPlayerView?) {
        print("Tango Player 1")
        mediaFormat = TangoPlayerUtils.decoderVideoFormat(URL)
        contentURL = URL
        error = TangoPlayerError()
        print("Tango Player error %@",error)
        print("Tango Player 2")
        if let view = playerView {
            displayView = view
        } else {
            displayView = TangoPlayerView()
        }
        super.init()
        if contentURL != nil {
            configurationPlayer(contentURL!)
        }
    }
    public convenience init(URL: URL) {
        self.init(URL: URL, playerView: nil)
    }
    
    public convenience init(playerView: TangoPlayerView) {
        self.init(URL: nil, playerView: playerView)
    }
    
    public override convenience init() {
        self.init(URL: nil, playerView: nil)
    }
    deinit {
        removePlayerNotifations()
        cleanPlayer()
        displayView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        audioSession.removeObserver(self, forKeyPath: Observation.VolumeKey)
    }
    
    internal func configurationPlayer(_ URL: URL) {
        print("configurationPlayer")
        self.displayView.settangoPlayer(tangoPlayer: self)
        self.playerAsset = AVURLAsset(url: URL, options: .none)
        let keys = ["tracks", "playable"];
        playerItem = AVPlayerItem(asset: playerAsset!, automaticallyLoadedAssetKeys: keys)
        /*if URL.absoluteString.hasPrefix("file:///")
         {
         let keys = ["tracks", "playable"];
         playerItem = AVPlayerItem(asset: playerAsset!, automaticallyLoadedAssetKeys: keys)
         } else {
         // remote add cache
         //playerItem = resourceLoaderManager.playerItem(URL)
         }*/
        player = AVPlayer(playerItem: playerItem)
        player?.allowsExternalPlayback = true
        player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        player?.isClosedCaptionDisplayEnabled = true
        displayView.reloadPlayerView()
        do {
            try audioSession.setActive(true)
            startObservingVolumeChanges()
        } catch {
            print("Failed to activate audio session")
        }
        //self.getAvailableAudioTracks()
        //self.getAvailableSubtitleTracks()
        print("Audio Tracks %@",audioTracksList)
        print("Title Tracks %@",tilteTracksList)
    }
    func getAvailableAudioTracks(){
        var allAudioTracks = [AnyHashable]()
        let asset = player?.currentItem?.asset as? AVURLAsset
        //** 1st Way
        let audioTracks: AVMediaSelectionGroup? = asset?.mediaSelectionGroup(forMediaCharacteristic: .audible)
        for option: AVMediaSelectionOption in (audioTracks?.options)! {
            print("Audio Track Display Name: \(option.displayName)")
            print("is playable: \(option.isPlayable)")
            allAudioTracks.append(option)
        }
        print("audioTracks %@",audioTracks)
        let defaultOption: AVMediaSelectionOption? = audioTracks?.defaultOption
        print("defaultOption %@",defaultOption)
        if(defaultOption != nil){
            print("default Audio Track : \(defaultOption!.displayName)")
            UserDefaults.standard.set(defaultOption!.displayName, forKey: "DefaultAudioTrack")
            UserDefaults.standard.synchronize()
        }
        else{
            UserDefaults.standard.set("UnKnown", forKey: "DefaultAudioTrack")
            UserDefaults.standard.synchronize()
        }
        //** 2nd way
        let audiTracks = asset?.tracks(withMediaType: .audio)
        if allAudioTracks.count == 0 {
            allAudioTracks = audiTracks as! [Any] as! [AnyHashable]
        }
        audioTracksList.removeAllObjects()
        audioTracksList.addObjects(from: allAudioTracks)
    }
    func getAvailableSubtitleTracks(){
        var allAudioTracks = [AnyHashable]()
        let asset = player?.currentItem?.asset as? AVURLAsset
        //** 1st Way
        let audioTracks: AVMediaSelectionGroup? = asset?.mediaSelectionGroup(forMediaCharacteristic: .legible)
        for option: AVMediaSelectionOption in (audioTracks?.options)! {
            print("Title Track Display Name: \(option.displayName)")
            allAudioTracks.append(option)
        }
        let defaultOption: AVMediaSelectionOption? = audioTracks?.defaultOption
        if(defaultOption != nil){
            UserDefaults.standard.set(defaultOption!.displayName, forKey: "DefaultTitleTrack")
            UserDefaults.standard.synchronize()
            print("default Title Track : \(defaultOption!.displayName)")
        }
        else{
            UserDefaults.standard.set("UnKnown", forKey: "DefaultTitleTrack")
            UserDefaults.standard.synchronize()
        }
        //** 2nd way
        let audiTracks = asset?.tracks(withMediaType: .audio)
        if allAudioTracks.count == 0 {
            allAudioTracks = audiTracks as! [Any] as! [AnyHashable]
        }
        tilteTracksList.removeAllObjects()
        tilteTracksList.addObjects(from: allAudioTracks)
    }
    func startObservingVolumeChanges() {
        audioSession.addObserver(self, forKeyPath: Observation.VolumeKey, options:  NSKeyValueObservingOptions([.new, .initial]), context: &Observation.Context)
    }
    // time KVO
    internal func addPlayerObservers() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] time in
            guard let strongSelf = self else { return }
            if let currentTime = strongSelf.player?.currentTime().seconds, let totalDuration = strongSelf.player?.currentItem?.duration.seconds {
                strongSelf.currentDuration = currentTime
                strongSelf.delegate?.tangoPlayer(strongSelf, playerDurationDidChange: currentTime, totalDuration: totalDuration)
                strongSelf.displayView.playerDurationDidChange(currentTime, totalDuration: totalDuration)
            }
        })
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 100), queue: DispatchQueue.main, using: { [weak self] time in
            guard let strongSelf = self else { return }
            let dur : Float64 = CMTimeGetSeconds(time);
            let durInMiliSec : Float64 = 1000*dur;
            let timeString : Int = Int(String(format: "%02.f", durInMiliSec))!
            if self?.oldMiliSec == 0 {
                self?.oldMiliSec = timeString
            }
            let timeDiff : Int = timeString-self!.oldMiliSec
            if(timeDiff >= 120){
                self?.delegate?.tangoPlayerPeriodicObserver(strongSelf, playercurrentTime: timeString,DifferenceTime:timeDiff, videoBounds: (strongSelf.displayView.playerLayer?.videoRect)!, isForwarded:true)
            }
            else{
                self?.delegate?.tangoPlayerPeriodicObserver(strongSelf, playercurrentTime: timeString,DifferenceTime:timeDiff, videoBounds: (strongSelf.displayView.playerLayer?.videoRect)!, isForwarded:false)
                self?.oldMiliSec = timeString
            }
        })
    }
    
    internal func removePlayerObservers() {
        player?.removeTimeObserver(timeObserver!)
    }
}
//MARK: - public
extension TangoPlayer {
    
    open func replaceVideo(_ URL: URL) {
        reloadPlayer()
        mediaFormat = TangoPlayerUtils.decoderVideoFormat(URL)
        contentURL = URL
        configurationPlayer(URL)
    }
    
    open func reloadPlayer() {
        seeking = false
        totalDuration = 0.0
        currentDuration = 0.0
        error = TangoPlayerError()
        state = .none
        buffering = false
        bufferState = .none
        cleanPlayer()
    }
    
    open func cleanPlayer() {
        player?.pause()
        player?.cancelPendingPrerolls()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerAsset?.cancelLoading()
        playerAsset = nil
        playerItem?.cancelPendingSeeks()
        playerItem = nil
    }
    
    open func play() {
        if contentURL == nil { return }
        player?.play()
        state = .playing
        displayView.play()
    }
    
    open func pause() {
        guard state == .paused else {
            player?.pause()
            state = .paused
            displayView.pause()
            return
        }
    }
    
    open func seekTime(_ time: TimeInterval) {
        seekTime(time, completion: nil)
    }
    
    open func seekTime(_ time: TimeInterval, completion: ((Bool) -> Swift.Void)?) {
        if time.isNaN || playerItem?.status != .readyToPlay {
            if completion != nil {
                completion!(false)
            }
            return
        }
        
        DispatchQueue.main.async { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.seeking = true
            strongSelf.startPlayerBuffering()
            strongSelf.playerItem?.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)), completionHandler: { (finished) in
                DispatchQueue.main.async {
                    strongSelf.seeking = false
                    strongSelf.stopPlayerBuffering()
                    strongSelf.play()
                    if completion != nil {
                        completion!(finished)
                    }
                }
            })
        }
    }
}

//MARK: - private
extension TangoPlayer {
    
    internal func startPlayerBuffering() {
        pause()
        bufferState = .buffering
        buffering = true
    }
    
    internal func stopPlayerBuffering() {
        bufferState = .stop
        buffering = false
    }
    
    internal func collectPlayerErrorLogEvent() {
        error.playerItemErrorLogEvent = playerItem?.errorLog()?.events
        error.error = playerItem?.error
        error.extendedLogData = playerItem?.errorLog()?.extendedLogData()
        error.extendedLogDataStringEncoding = playerItem?.errorLog()?.extendedLogDataStringEncoding
    }
}
//MARK: - Notifation Selector & KVO
private var playerItemContext = 0

extension TangoPlayer {
    
    internal func addPlayerItemObservers() {
        let options = NSKeyValueObservingOptions([.new, .initial])
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty), options: options, context: &playerItemContext)
    }
    
    internal func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: .playerItemDidPlayToEndTime, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationWillEnterForeground, name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationDidEnterBackground, name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    internal func removePlayerItemObservers() {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty))
    }
    
    internal func removePlayerNotifations() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    
    @objc internal func playerItemDidPlayToEnd(_ notification: Notification) {
        if state != .playFinished {
            state = .playFinished
        }
        delegate?.tangoPlayerdidReachedToend(self)
    }
    
    @objc internal func applicationWillEnterForeground(_ notification: Notification) {
        
        if let playerLayer = displayView.playerLayer  {
            playerLayer.player = player
        }
        
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            play()
        case .proceed:
            break
        }
    }
    
    @objc internal func applicationDidEnterBackground(_ notification: Notification) {
        
        if let playerLayer = displayView.playerLayer  {
            playerLayer.player = nil
        }
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            pause()
        case .proceed:
            play()
            break
        }
    }
}
extension TangoPlayer {
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &Observation.Context {
            if keyPath == Observation.VolumeKey, let volume = (change?[.newKey] as? NSNumber)?.floatValue {
                // `volume` contains the new system output volume...
                volumeValue = Float(String(format: "%.2f", volume))!
                displayView.didChangetheVolumeControl(value:volumeValue)
            }
        }
        else if (context == &playerItemContext) {
            if keyPath == #keyPath(AVPlayerItem.status) {
                let status: AVPlayerItemStatus
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                
                switch status {
                case AVPlayerItemStatus.unknown:
                    startPlayerBuffering()
                case AVPlayerItemStatus.readyToPlay:
                    bufferState = .readyToPlay
                case AVPlayerItemStatus.failed:
                    state = .error
                    collectPlayerErrorLogEvent()
                    stopPlayerBuffering()
                    delegate?.tangoPlayer(self, playerFailed: error)
                    displayView.playFailed(error)
                }
                
            } else if keyPath == #keyPath(AVPlayerItem.playbackBufferEmpty){
                
                if let playbackBufferEmpty = change?[.newKey] as? Bool {
                    if playbackBufferEmpty {
                        startPlayerBuffering()
                    }
                }
            } else if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
                // 计算缓冲
                
                let loadedTimeRanges = player?.currentItem?.loadedTimeRanges
                if let bufferTimeRange = loadedTimeRanges?.first?.timeRangeValue {
                    let star = bufferTimeRange.start.seconds         // The start time of the time range.
                    let duration = bufferTimeRange.duration.seconds  // The duration of the time range.
                    let bufferTime = star + duration
                    
                    if let itemDuration = playerItem?.duration.seconds {
                        delegate?.tangoPlayer(self, bufferedDidChange: bufferTime, totalDuration: itemDuration)
                        displayView.bufferedDidChange(bufferTime, totalDuration: itemDuration)
                        totalDuration = itemDuration
                        if itemDuration == bufferTime {
                            bufferState = .bufferFinished
                        }
                        
                    }
                    if let currentTime = playerItem?.currentTime().seconds{
                        if (bufferTime - currentTime) >= bufferInterval && state != .paused {
                            play()
                        }
                        
                        if (bufferTime - currentTime) < bufferInterval {
                            bufferState = .buffering
                            buffering = true
                        } else {
                            buffering = false
                            bufferState = .readyToPlay
                        }
                    }
                    
                } else {
                    play()
                }
            }
            
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - Selecter
extension Selector {
    static let playerItemDidPlayToEndTime = #selector(TangoPlayer.playerItemDidPlayToEnd(_:))
    static let applicationWillEnterForeground = #selector(TangoPlayer.applicationWillEnterForeground(_:))
    static let applicationDidEnterBackground = #selector(TangoPlayer.applicationDidEnterBackground(_:))
}

