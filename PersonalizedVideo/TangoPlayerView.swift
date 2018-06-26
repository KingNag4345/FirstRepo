//
//  TangoPlayerView.swift
//  TTPlayerDemo
//
//  Created by Nagaraju Surisetty on 27/11/17.
//  Copyright © 2017 Nagaraju Surisetty. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer

public protocol TangoPlayerViewDelegate: class {
    
    /// Fullscreen
    ///
    /// - Parameters:
    ///   - playerView: player view
    ///   - fullscreen: Whether full screen
    func tangoPlayerView(_ playerView: TangoPlayerView, willFullscreen isFullscreen: Bool,videoBoundsRect: CGRect,playercurrentTime: Int)
    
    /// Close play view
    ///
    /// - Parameter playerView: player view
    func tangoPlayerView(didTappedClose playerView: TangoPlayerView)
    
    /// Displaye control
    ///
    /// - Parameter playerView: playerView
    func tangoPlayerView(didDisplayControl playerView: TangoPlayerView)
    
    /// interactive control
    ///
    /// - Parameter playerView: playerView
    /// - Parameter videoBoundsRect: CGRect
    func tangoPlayerView(didTouched playerView: TangoPlayerView,videoBoundsRect: CGRect,xPercentage:Float,yPercentage:Float,frameImage:UIImage, playercurrentTime: Int)
    
    func tangoPlayerViewOrientationChnaged(_ playerView: TangoPlayerView, willFullscreen isFullscreen: Bool)
}

// MARK: - delegate methods optional
public extension TangoPlayerViewDelegate {
    
    func tangoPlayerView(_ playerView: TangoPlayerView, willFullscreen fullscreen: Bool,videoBoundsRect: CGRect,playercurrentTime: Int){}
    
    func tangoPlayerView(didTappedClose playerView: TangoPlayerView) {}
    
    func tangoPlayerView(didDisplayControl playerView: TangoPlayerView) {}
    
    func tangoPlayerView(didTouched playerView: TangoPlayerView,videoBoundsRect: CGRect,xPercentage:Float,yPercentage:Float,frameImage:UIImage,playercurrentTime: Int){}
    func tangoPlayerViewOrientationChnaged(_ playerView: TangoPlayerView, willFullscreen isFullscreen: Bool){}
}

public enum TangoPlayerViewPanGestureDirection: Int {
    case vertical
    case horizontal
}

open class TangoPlayerView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    weak open var tangoPlayer : TangoPlayer?
    open var controlViewDuration : TimeInterval = 5.0  /// default 5.0
    open fileprivate(set) var playerLayer : AVPlayerLayer?
    open fileprivate(set) var isFullScreen : Bool = false
    open fileprivate(set) var isTimeSliding : Bool = false
    open fileprivate(set) var isDisplayControl : Bool = true {
        didSet {
            if isDisplayControl != oldValue {
                delegate?.tangoPlayerView(didDisplayControl: self)
            }
        }
    }
    open weak var delegate : TangoPlayerViewDelegate?
    // top view
    open var topView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return view
    }()
    open var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    open var closeButton : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    // bottom view
    open var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        //view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2446757277)
        return view
    }()
    let bottomProgressView : UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        progress.isHidden = true
        return progress
    }()
    open var timeSlider         = TangoPlayerSlider ()
    open var loadingIndicator   = TangoPlayerLoadingIndicator()
    open var fullscreenButton   : UIButton = UIButton(type: UIButtonType.custom)
    open var airplayButton      : UIButton = UIButton(type: UIButtonType.custom)
    open var airplayView        = MPVolumeView()
    var airplayRouteButton      : UIButton?
    var wrapperView             : UIButton = UIButton(type: UIButtonType.custom)
    open var subtitlesButton    : UIButton = UIButton(type: UIButtonType.custom)
    open var volumeButton       : UIButton = UIButton(type: UIButtonType.custom)
    open var timeLabel          : UILabel = UILabel()
    open var endtimeLabel       : UILabel = UILabel()
    open var contentOverlay     = UIView()
    open var playButtion        : UIButton = UIButton(type: UIButtonType.custom)
    open var volumeSlider       : UISlider!
    open var replayButton       : UIButton = UIButton(type: UIButtonType.custom)
    //open var tangoBounds        = CGRect()
    open fileprivate(set) var panGestureDirection : TangoPlayerViewPanGestureDirection = .horizontal
    fileprivate var isVolume    : Bool = false
    open  var playerPlayIcon        =  UIImage(){
        didSet{
            updateCustomImages()
        }
    }
    open var isAds = true {
        didSet{
            updateView()
        }
    }
    fileprivate var sliderSeekTimeValue : TimeInterval = .nan
    fileprivate var timer       : Timer = {
        let time = Timer()
        return time
    }()
    
    fileprivate weak var parentView : UIView?
    fileprivate var viewFrame      = CGRect()
    
    // GestureRecognizer
    open var singleTapGesture    = UITapGestureRecognizer()
    open var doubleTapGesture    = UITapGestureRecognizer()
    open var panGesture          = UIPanGestureRecognizer()
    //MARK:- life cycle
    public override init(frame: CGRect) {
        print("Tango Player View 1")
        self.playerLayer = AVPlayerLayer(player: nil)
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        contentOverlay.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        contentOverlay.isUserInteractionEnabled = true;
        self.addSubview(contentOverlay)
        contentOverlay.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.width.equalTo(strongSelf)
            make.height.equalTo(strongSelf)
        }
        addDeviceOrientationNotifications()
        addGestureRecognizer()
        configurationVolumeSlider()
        configurationUI()
        print("Tango Player View 2")
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateDisplayerView(frame: bounds)
    }
    
    open func settangoPlayer(tangoPlayer: TangoPlayer) {
        self.tangoPlayer = tangoPlayer
    }
    open func updateView() {
        /*if self.isAds {
         self.bottomView.removeFromSuperview()
         }
         else {
         if bottomView.isDescendant(of: self){
         }
         else{
         configurationBottomView()
         }
         }*/
    }
    open func updateCustomImages(){
        print("updateCustomImages")
    }
    open func reloadPlayerLayer() {
        playerLayer = AVPlayerLayer(player: self.tangoPlayer?.player)
        layer.insertSublayer(self.playerLayer!, at: 0)
        updateDisplayerView(frame: self.bounds)
        //timeSlider.isUserInteractionEnabled = tangoPlayer?.mediaFormat != .m3u8
        reloadGravity()
    }
    /// play state did change
    ///
    /// - Parameter state: state
    open func playStateDidChange(_ state: TangoPlayerState) {
        playButtion.isSelected = state == .playing
        replayButton.isHidden = !(state == .playFinished)
        replayButton.isHidden = !(state == .playFinished)
        if state == .playing || state == .playFinished {
            setupTimer()
        }
        if state == .playFinished {
            loadingIndicator.isHidden = true
        }
    }
    
    /// buffer state change
    ///
    /// - Parameter state: buffer state
    open func bufferStateDidChange(_ state: TangoPlayerBufferstate) {
        if state == .buffering {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
        
        var current = formatSecondsToString((tangoPlayer?.currentDuration)!)
        if (tangoPlayer?.totalDuration.isNaN)! {  // HLS
            current = "00:00"
        }
        if state == .readyToPlay && !isTimeSliding {
            timeLabel.text = "\(current)"
            endtimeLabel.text = "\(formatSecondsToString((tangoPlayer?.totalDuration)!))"
        }
    }
    
    /// buffer duration
    ///
    /// - Parameters:
    ///   - bufferedDuration: buffer duration
    ///   - totalDuration: total duratiom
    open func bufferedDidChange(_ bufferedDuration: TimeInterval, totalDuration: TimeInterval) {
        timeSlider.setProgress(Float(bufferedDuration / totalDuration), animated: true)
    }
    
    /// player diration
    ///
    /// - Parameters:
    ///   - currentDuration: current duration
    ///   - totalDuration: total duration
    open func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        var current = formatSecondsToString(currentDuration)
        if totalDuration.isNaN {  // HLS
            current = "00:00"
        }
        if !isTimeSliding {
            timeLabel.text = "\(current)"
            endtimeLabel.text = "\(formatSecondsToString(totalDuration))"
            timeSlider.value = Float(currentDuration / totalDuration)
        }
        self.bottomProgressView.setProgress(Float(currentDuration/totalDuration), animated: true)
    }
    
    open func configurationUI() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //configurationTopView()
        configurationBottomView()
        configurationReplayButton()
        setupViewAutoLayout()
        
        self.addSubview(bottomProgressView)
        bottomProgressView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(3)
        }
    }
    
    open func reloadPlayerView() {
        playerLayer = AVPlayerLayer(player: nil)
        timeSlider.value = Float(0)
        timeSlider.setProgress(0, animated: false)
        replayButton.isHidden = true
        isTimeSliding = false
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        timeLabel.text = "--:--"
        endtimeLabel.text = "--:--"
        reloadPlayerLayer()
    }
    
    /// control view display
    ///
    /// - Parameter display: is display
    open func displayControlView(_ isDisplay:Bool) {
        if isDisplay {
            if (isAds == true){
                hiddenControlAnimation()
            }
            else{
                displayControlAnimation()
            }
        } else {
            hiddenControlAnimation()
        }
        self.bottomProgressView.isHidden = isDisplay
    }
}
// MARK: - public
extension TangoPlayerView {
    
    open func updateDisplayerView(frame: CGRect) {
        playerLayer?.frame = frame
    }
    
    open func reloadGravity() {
        if tangoPlayer != nil {
            switch tangoPlayer!.gravityMode {
            case .resize:
                playerLayer?.videoGravity = .resize
            case .resizeAspect:
                playerLayer?.videoGravity = .resizeAspect
            case .resizeAspectFill:
                playerLayer?.videoGravity = .resizeAspectFill
            }
        }
    }
    
    open func enterFullscreen() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        print("statusBarOrientation %@",statusBarOrientation.rawValue)
        if statusBarOrientation == .portrait{
            parentView = (self.superview)!
            viewFrame = self.frame
        }
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .landscapeRight
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if (deviceIdiom == .pad){
        if superview != nil {
            parentView = (superview)!
            viewFrame = frame
        }
        let rectInWindow = convert(bounds, to: UIApplication.shared.keyWindow)
        removeFromSuperview()
        frame = rectInWindow
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.remakeConstraints({ [weak self] (make) in
            guard let strongSelf = self else { return }
            make.width.equalTo(strongSelf.superview!.bounds.width)
            make.height.equalTo(strongSelf.superview!.bounds.height)
        })
        }
    }
    
    open func exitFullscreen() {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if (deviceIdiom == .pad){
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIApplication.shared.statusBarOrientation = .landscapeRight
            
            if parentView == nil { return }
            removeFromSuperview()
            parentView!.addSubview(self)
            print("View Frame value %@",viewFrame)
            let frame = parentView!.convert(viewFrame, to: UIApplication.shared.keyWindow)
            self.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(viewFrame.midX)
                make.centerY.equalTo(viewFrame.midY)
                make.width.equalTo(frame.width)
                make.height.equalTo(frame.height)
            })
            viewFrame = CGRect()
            parentView = nil
        }
        else{
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .portrait
        }
    }
    
    /// play failed
    ///
    /// - Parameter error: error
    open func playFailed(_ error: TangoPlayerError) {
        // error
    }
    
    public func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN{
            return "00:00"
        }
        let interval = Int(seconds)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let min = interval / 60
        return String(format: "%02d:%02d", min, sec)
    }
}

// MARK: - private
extension TangoPlayerView {
    
    internal func play() {
        playButtion.isSelected = true
    }
    
    internal func pause() {
        playButtion.isSelected = false
    }
    
    internal func displayControlAnimation() {
        bottomView.isHidden = false
        topView.isHidden = false
        isDisplayControl = true
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 1
            self.topView.alpha = 1
        }) { (completion) in
            self.setupTimer()
        }
    }
    internal func hiddenControlAnimation() {
        timer.invalidate()
        isDisplayControl = false
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 0
            self.topView.alpha = 0
        }) { (completion) in
            self.bottomView.isHidden = true
            self.topView.isHidden = true
        }
    }
    internal func setupTimer() {
        timer.invalidate()
        timer = Timer.tangoPlayer_scheduledTimerWithTimeInterval(self.controlViewDuration, block: {  [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.displayControlView(false)
            }, repeats: false)
    }
    internal func addDeviceOrientationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationWillChange(_:)), name: .UIApplicationWillChangeStatusBarOrientation, object: nil)
    }
    
    internal func configurationVolumeSlider() {
        let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider {
            volumeSlider = view
        }
    }
}
// MARK: - GestureRecognizer
extension TangoPlayerView {
    
    internal func addGestureRecognizer() {
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSingleTapGesture(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.delegate = self
        addGestureRecognizer(singleTapGesture)
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        addGestureRecognizer(doubleTapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSingleTapGesture(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.delegate = self
        contentOverlay.addGestureRecognizer(singleTapGesture)
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        contentOverlay.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension TangoPlayerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        /*if (touch.view as? TangoPlayerView != nil || touch.view as? TangoPlayerView != nil) {
            return true
        }*/
        if (isAds == true){
            return false
        }
        return true
    }
}
// MARK: - Event
extension TangoPlayerView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as? UITouch
        var xFPercentage : Float = 0
        var yFPercentage : Float = 0
        if (touch != nil){
            let point: CGPoint = touch!.location(in: self)
            if(playerLayer?.videoRect.contains(point))!{
                //if (player?.displayView.contentOverlay.contains(point as! UIFocusEnvironment))! {
                let xValue = Int(ceilf(Float(point.x)))
                var yValue = Int(ceilf(Float(point.y)))
                if(yValue < Int((playerLayer?.videoRect.origin.y)!)){
                    yValue = 0;
                }
                if yValue >= Int((playerLayer?.videoRect.origin.y)!){
                    yValue = yValue - Int((playerLayer?.videoRect.origin.y)!)
                }
                xFPercentage = Float(String(format: "%0.1f", Float (100 * xValue) / Float ((playerLayer?.videoRect.size.width)!)))!
                yFPercentage = Float(String(format: "%0.1f", Float (100 * yValue) / Float((playerLayer?.videoRect.size.height)!)))!
                
                var image = UIImage()
                if let item = tangoPlayer?.player!.currentItem {
                    let imageGenerator = AVAssetImageGenerator(asset: item.asset)
                    if let cgImage = try? imageGenerator.copyCGImage(at: item.currentTime(), actualTime: nil) {
                        image = UIImage(cgImage: cgImage)
                    }
                }
                let dur : Float64 = (tangoPlayer?.currentDuration)!;
                let durInMiliSec : Float64 = 1000*dur;
                let timeString : Int = Int(String(format: "%02.f", durInMiliSec))!
                print("timeString %@",timeString);
                delegate?.tangoPlayerView(didTouched: self, videoBoundsRect: (playerLayer?.videoRect)!,xPercentage:xFPercentage,yPercentage:yFPercentage,frameImage:image, playercurrentTime: timeString)
            }
        }
        //isDisplayControl = !isDisplayControl
        //displayControlView(isDisplayControl)
        /*else if (touch?.tapCount == 2) {
            guard tangoPlayer == nil else {
                switch tangoPlayer!.state {
                case .playFinished:
                    break
                case .playing:
                    tangoPlayer?.pause()
                case .resume:
                    tangoPlayer?.play()
                case .paused:
                    tangoPlayer?.play()
                case .none:
                    break
                case .error:
                    break
                }
                return
            }
        }*/
    }
    
    @objc internal func timeSliderValueChanged(_ sender: TangoPlayerSlider) {
        isTimeSliding = true
        if let duration = tangoPlayer?.totalDuration {
            let currentTime = Double(sender.value) * duration
            timeLabel.text = "\(formatSecondsToString(currentTime))"
            endtimeLabel.text = "\(formatSecondsToString(duration))"
        }
    }
    
    @objc internal func timeSliderTouchDown(_ sender: TangoPlayerSlider) {
        isTimeSliding = true
        timer.invalidate()
    }
    
    @objc internal func timeSliderTouchUpInside(_ sender: TangoPlayerSlider) {
        isTimeSliding = true
        
        if let duration = tangoPlayer?.totalDuration {
            let currentTime = Double(sender.value) * duration
            tangoPlayer?.seekTime(currentTime, completion: { [weak self] (finished) in
                guard let strongSelf = self else { return }
                if finished {
                    strongSelf.isTimeSliding = false
                    strongSelf.setupTimer()
                }
            })
            timeLabel.text = "\(formatSecondsToString(currentTime))"
            endtimeLabel.text = "\(formatSecondsToString(duration))"
        }
    }
    
    @objc internal func onPlayerButton(_ sender: UIButton) {
        if !sender.isSelected {
            tangoPlayer?.play()
        } else {
            tangoPlayer?.pause()
        }
    }
    
    @objc internal func onFullscreen(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isFullScreen = sender.isSelected
        delegate?.tangoPlayerViewOrientationChnaged(self, willFullscreen: isFullScreen)
        if isFullScreen {
            enterFullscreen()
            bottomView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2446757277)
        } else {
            bottomView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            exitFullscreen()
        }
        let dur : Float64 = (tangoPlayer?.currentDuration)!;
        let durInMiliSec : Float64 = 1000*dur;
        let timeString : Int = Int(String(format: "%02.f", durInMiliSec))!
        delegate?.tangoPlayerView(self, willFullscreen: isFullScreen,videoBoundsRect: (playerLayer?.videoRect)!,playercurrentTime: timeString)
        print("playerLayer video rect %@",playerLayer?.videoRect)
        timeSlider.snp.removeConstraints()
        timeSlider.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            //make.centerY.equalTo(strongSelf.playButtion)
            UIView.animate(withDuration: 0.5, animations: {
                if (self?.isFullScreen)! {
                    make.centerY.equalTo(strongSelf.playButtion)
                    make.right.equalTo(strongSelf.endtimeLabel.snp.left).offset(-10)
                    make.left.equalTo(strongSelf.timeLabel.snp.right).offset(10)
                    make.height.equalTo(25)
                }
                else{
                    make.width.equalTo(strongSelf.bottomView)
                    make.bottom.equalTo(strongSelf.bottomView).offset(10.8)//10.8
                    make.height.equalTo(25)
                }
            }) { (completion) in
            }
        }
    }
    @objc internal func airPlayTapped(_ sender: UIButton) {
        /*var volumeView = MPVolumeView()
         volumeView.frame = airplayButton.frame
         volumeView.showsVolumeSlider = false
         volumeView.sizeToFit()
         self.addSubview(volumeView)*/
    }
    @objc internal func subtitlesButtonTapped(_ sender: UIButton) {
        
          if(tangoPlayer?.mediaFormat == .m3u8){
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        print("Window Frame %@", (keyWindow?.frame)!)
        let subtittleView = TangoPlayerSubTitle(frame: (keyWindow?.frame)!)
        subtittleView.audioList = (tangoPlayer?.audioTracksList)!
        subtittleView.subtitleList = (tangoPlayer?.tilteTracksList)!
        //subtittleView.frame = (keyWindow?.frame)!
        subtittleView.alpha = 0.0
        subtittleView.callBack = {() in
            self.tangoPlayer?.player?.isClosedCaptionDisplayEnabled = false
        }
        subtittleView.customCallBack = {(slectedValue:Any,index : Int) in
            print("slectedValue %@",slectedValue)
            self.tangoPlayer?.player?.isClosedCaptionDisplayEnabled = true
            if(index == 0){
                let asset = self.tangoPlayer?.player?.currentItem?.asset
                let audioTracks: AVMediaSelectionGroup? = asset?.mediaSelectionGroup(forMediaCharacteristic: .audible)
                self.tangoPlayer?.player?.currentItem?.select(slectedValue as? AVMediaSelectionOption, in: audioTracks!)
            }
            else if (index == 1){
                let asset = self.tangoPlayer?.player?.currentItem?.asset
                let titleTracks: AVMediaSelectionGroup? = asset?.mediaSelectionGroup(forMediaCharacteristic: .audible)
                self.tangoPlayer?.player?.currentItem?.select(slectedValue as? AVMediaSelectionOption, in: titleTracks!)
            }
        }
        keyWindow?.addSubview(subtittleView)
        UIView.animate(withDuration: 0.8, animations: {
            subtittleView.alpha = 1.0
        })
        }
          else{
            let alertController:UIAlertController     = UIAlertController(title: "Error", message:"Subtitle tracks are not avilable!", preferredStyle:.alert)
            alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            let mainController: UIViewController? = keyWindow?.rootViewController
            mainController?.present(alertController, animated: true)
        }
        /*subtittleView.snp.makeConstraints { [weak self] (make) in
         guard let strongSelf = self else { return }
         make.center.equalTo(strongSelf)
         make.width.equalTo(strongSelf)
         make.height.equalTo(strongSelf)
         }*/
        
        
        /*let subtittleView = TangoPlayerSubTitleVC()
         subtittleView.audioList = (tangoPlayer?.audioTracksList)!
         subtittleView.subtitleList = (tangoPlayer?.tilteTracksList)!
         subtittleView.customCallBack = {(slectedValue:Any,index : Int) in
         print("slectedValue %@",slectedValue)
         if(index == 0){
         let asset = self.tangoPlayer?.player?.currentItem?.asset
         let audioTracks: AVMediaSelectionGroup? = asset?.mediaSelectionGroup(forMediaCharacteristic: .audible)
         self.tangoPlayer?.player?.currentItem?.select(slectedValue as? AVMediaSelectionOption, in: audioTracks!)
         }
         else if (index == 1){
         let asset = self.tangoPlayer?.player?.currentItem?.asset
         let titleTracks: AVMediaSelectionGroup? = asset?.mediaSelectionGroup(forMediaCharacteristic: .audible)
         self.tangoPlayer?.player?.currentItem?.select(slectedValue as? AVMediaSelectionOption, in: titleTracks!)
         }
         }
         let keyWindow: UIWindow? = UIApplication.shared.keyWindow
         let mainController: UIViewController? = keyWindow?.rootViewController
         subtittleView.modalPresentationStyle = .overCurrentContext
         mainController?.present(subtittleView, animated: true, completion: nil)
         //keyWindow?.addSubview(subtittleView.view)
         //keyWindow?.bringSubview(toFront: subtittleView.view)
         //subtittleView.frame = CGRect(x:0, y:0, width:self.frame.size.width, height:100)*/
    }
    @objc internal func volumeButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            //let volumeMute = UIImage(named:"ic-mute")
            //volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeMute!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
            volumeButton.isSelected = false
            tangoPlayer?.player?.isMuted = false
        }
        else{
            //let volumeNormal = UIImage(named:"ic-mute4")
            //volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeNormal!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
            volumeButton.isSelected = true
            tangoPlayer?.player?.isMuted = true
        }
    }
    /// Single Tap Event
    ///
    /// - Parameter gesture: Single Tap Gesture
    @objc open func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        isDisplayControl = !isDisplayControl
        displayControlView(isDisplayControl)
    }
    @objc open func onSingleTapGestureCV(_ gesture: UITapGestureRecognizer) {
        print("Gesture Tapped")
    }
    
    /// Double Tap Event
    ///
    /// - Parameter gesture: Double Tap Gesture
    @objc open func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        guard tangoPlayer == nil else {
            switch tangoPlayer!.state {
            case .playFinished:
                break
            case .playing:
                tangoPlayer?.pause()
            case .resume:
                tangoPlayer?.play()
            case .paused:
                tangoPlayer?.play()
            case .none:
                break
            case .error:
                break
            }
            return
        }
    }
    
    /// Pan Event
    ///
    /// - Parameter gesture: Pan Gesture
    @objc open func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let location = gesture.location(in: self)
        let velocity = gesture.velocity(in: self)
        switch gesture.state {
        case .began:
            let x = fabs(translation.x)
            let y = fabs(translation.y)
            if x < y {
                panGestureDirection = .vertical
                if location.x > bounds.width / 2 {
                    isVolume = true
                } else {
                    isVolume = false
                }
            } else if x > y{
                guard tangoPlayer?.mediaFormat == .m3u8 else {
                    panGestureDirection = .horizontal
                    return
                }
            }
        case .changed:
            switch panGestureDirection {
            case .horizontal:
                if tangoPlayer?.currentDuration == 0 { break }
                sliderSeekTimeValue = panGestureHorizontal(velocity.x)
            case .vertical:
                panGestureVertical(velocity.y)
            }
        case .ended:
            switch panGestureDirection{
            case .horizontal:
                if sliderSeekTimeValue.isNaN { return }
                self.tangoPlayer?.seekTime(sliderSeekTimeValue, completion: { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    if finished {
                        
                        strongSelf.isTimeSliding = false
                        strongSelf.setupTimer()
                    }
                })
            case .vertical:
                isVolume = false
            }
            
        default:
            break
        }
    }
    
    internal func panGestureHorizontal(_ velocityX: CGFloat) -> TimeInterval {
        displayControlView(true)
        isTimeSliding = true
        timer.invalidate()
        let value = timeSlider.value
        if let _ = tangoPlayer?.currentDuration ,let totalDuration = tangoPlayer?.totalDuration {
            let sliderValue = (TimeInterval(value) *  totalDuration) + TimeInterval(velocityX) / 100.0 * (TimeInterval(totalDuration) / 400)
            timeSlider.setValue(Float(sliderValue/totalDuration), animated: true)
            return sliderValue
        } else {
            return TimeInterval.nan
        }
        
    }
    
    internal func panGestureVertical(_ velocityY: CGFloat) {
        isVolume ? (volumeSlider.value -= Float(velocityY / 10000)) : (UIScreen.main.brightness -= velocityY / 10000)
    }
    
    @objc internal func onCloseView(_ sender: UIButton) {
        delegate?.tangoPlayerView(didTappedClose: self)
    }
    
    @objc internal func onReplay(_ sender: UIButton) {
        tangoPlayer?.replaceVideo((tangoPlayer?.contentURL)!)
        tangoPlayer?.play()
    }
    
    @objc internal func deviceOrientationWillChange(_ sender: Notification) {
        let orientation = UIDevice.current.orientation
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .portrait{
            if superview != nil {
                parentView = (superview)!
                viewFrame = frame
            }
        }
        switch orientation {
        case .unknown:
            break
        case .faceDown:
            break
        case .faceUp:
            break
        case .landscapeLeft:
            onDeviceOrientation(true, orientation: .landscapeLeft)
        case .landscapeRight:
            onDeviceOrientation(true, orientation: .landscapeRight)
        case .portrait:
            onDeviceOrientation(false, orientation: .portrait)
        case .portraitUpsideDown:
            onDeviceOrientation(false, orientation: .portraitUpsideDown)
        }
    }
    internal func onDeviceOrientation(_ fullScreen: Bool, orientation: UIInterfaceOrientation) {
        print("Device Orientation Called")
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if orientation == statusBarOrientation {
            print("statusBarOrientation")
            if orientation == .landscapeLeft || orientation == .landscapeLeft {
                let rectInWindow = convert(bounds, to: UIApplication.shared.keyWindow)
                removeFromSuperview()
                frame = rectInWindow
                UIApplication.shared.keyWindow?.addSubview(self)
                self.snp.remakeConstraints({ [weak self] (make) in
                    guard let strongSelf = self else { return }
                    make.width.equalTo(strongSelf.superview!.bounds.width)
                    make.height.equalTo(strongSelf.superview!.bounds.height)
                })
            }
        } else {
            print("Genral Orientation")
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                let rectInWindow = convert(bounds, to: UIApplication.shared.keyWindow)
                removeFromSuperview()
                frame = rectInWindow
                UIApplication.shared.keyWindow?.addSubview(self)
                self.snp.remakeConstraints({ [weak self] (make) in
                    guard let strongSelf = self else { return }
                    make.width.equalTo(strongSelf.superview!.bounds.height)
                    make.height.equalTo(strongSelf.superview!.bounds.width)
                })
            } else if orientation == .portrait{
                if parentView == nil { return }
                removeFromSuperview()
                parentView!.addSubview(self)
                let frame = parentView!.convert(viewFrame, to: UIApplication.shared.keyWindow)
                self.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(viewFrame.midX)
                    make.centerY.equalTo(viewFrame.midY)
                    make.width.equalTo(frame.width)
                    make.height.equalTo(frame.height)
                })
                viewFrame = CGRect()
                parentView = nil
            }
        }
        isFullScreen = fullScreen
        fullscreenButton.isSelected = fullScreen
        //delegate?.tangoPlayerView(self, willFullscreen: isFullScreen,videoBoundsRect: (playerLayer?.videoRect)!)
    }
}
//MARK: - UI autoLayout
extension TangoPlayerView {
    
    open func didChangetheVolumeControl(value : Float){
        print("Vhnaged Volume Value %f",value)
        let bundle = Bundle(for: type(of: self))
        if ( value <= 0.25 && value > 0.10){
            let volumeNormal = UIImage(named:"ic-mute1", in: bundle, compatibleWith: nil)
            volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeNormal!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
            volumeButton.isSelected = false
        }
        else if ( value > 0.25 && value <= 0.50) {
            let volumeNormal = UIImage(named:"ic-mute2", in: bundle, compatibleWith: nil)
            volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeNormal!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
            volumeButton.isSelected = false
        }
        else if ( value > 0.50 && value <= 0.75) {
            let volumeNormal = UIImage(named:"ic-mute3", in: bundle, compatibleWith: nil)
            volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeNormal!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
            volumeButton.isSelected = false
        }
        else if( value > 0.75){
            let volumeNormal = UIImage(named:"ic-mute4", in: bundle, compatibleWith: nil)
            volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeNormal!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
            volumeButton.isSelected = false
        }
        else {
            let volumeMute = UIImage(named:"ic-mute", in: bundle, compatibleWith: nil)
            volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeMute!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
            volumeButton.isSelected = true
        }
    }
    internal func configurationReplayButton() {
        let bundle = Bundle(for: type(of: self))
        addSubview(self.replayButton)
        let replayImage =  UIImage(named:"ic_replay", in: bundle, compatibleWith: nil)
        replayButton.setImage(TangoPlayerUtils.imageSize(image: replayImage!, scaledToSize: CGSize(width: 44, height: 44)), for: .normal)
        replayButton.addTarget(self, action: #selector(onReplay(_:)), for: .touchUpInside)
        replayButton.isHidden = true
    }
    
    internal func configurationTopView() {
        addSubview(topView)
        let bundle = Bundle(for: type(of: self))
        titleLabel.text = "this is a title."
        topView.addSubview(titleLabel)
        let closeImage = UIImage(named:"ic_replay", in: bundle, compatibleWith: nil)
        closeButton.setImage(TangoPlayerUtils.imageSize(image: closeImage!, scaledToSize: CGSize(width: 15, height: 20)), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseView(_:)), for: .touchUpInside)
        topView.addSubview(closeButton)
    }
    
    internal func configurationBottomView() {
        addSubview(bottomView)
        let bundle = Bundle(for: type(of: self))
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged(_:)),
                             for: .valueChanged)
        timeSlider.addTarget(self, action: #selector(timeSliderTouchUpInside(_:)), for: .touchUpInside)
        timeSlider.addTarget(self, action: #selector(timeSliderTouchDown(_:)), for: .touchDown)
        loadingIndicator.lineWidth = 1.0
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        addSubview(loadingIndicator)
        bottomView.addSubview(timeSlider)
        
        let playImage = UIImage(named:"ic_play", in: bundle, compatibleWith: nil)
        let pauseImage =  UIImage(named:"ic_pause", in: bundle, compatibleWith: nil)
        playButtion.setImage(TangoPlayerUtils.imageSize(image: playImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        playButtion.setImage(TangoPlayerUtils.imageSize(image: pauseImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
        playButtion.addTarget(self, action: #selector(onPlayerButton(_:)), for: .touchUpInside)
        playButtion.showsTouchWhenHighlighted = true
        bottomView.addSubview(playButtion)
        
        timeLabel.textAlignment = .center
        timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timeLabel.font = UIFont.systemFont(ofSize: 12.0)
        timeLabel.text = "--:--"
        bottomView.addSubview(timeLabel)
        
        endtimeLabel.textAlignment = .center
        endtimeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        endtimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        endtimeLabel.text = "--:--"
        bottomView.addSubview(endtimeLabel)
        
        let enlargeImage = UIImage(named:"ic_fullscreen", in: bundle, compatibleWith: nil)
        let narrowImage =  UIImage(named:"ic_fullscreen_exit", in: bundle, compatibleWith: nil)
        fullscreenButton.setImage(TangoPlayerUtils.imageSize(image: enlargeImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        fullscreenButton.setImage(TangoPlayerUtils.imageSize(image: narrowImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
        fullscreenButton.addTarget(self, action: #selector(onFullscreen(_:)), for: .touchUpInside)
        fullscreenButton.showsTouchWhenHighlighted = true
        bottomView.addSubview(fullscreenButton)
        
        
        /*let airplayImage = UIImage(named:"ic_airplay")
         airplayButton.setImage(TangoPlayerUtils.imageSize(image: airplayImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
         airplayButton.setImage(TangoPlayerUtils.imageSize(image: airplayImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
         airplayButton.addTarget(self, action: #selector(airPlayTapped(_:)), for: .touchUpInside)
         bottomView.addSubview(airplayButton)*/
        
        /*airplayView.showsVolumeSlider = false
         airplayView.showsRouteButton = true
         airplayView.sizeToFit()
         bottomView.addSubview(airplayView)*/
        
        let airplayImage = UIImage(named:"ic_airplay",in: bundle, compatibleWith: nil)
        wrapperView = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        wrapperView.setImage(TangoPlayerUtils.imageSize(image: airplayImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        //wrapperView.setImage( UIImage(named:"ic_airplay",in: bundle, compatibleWith: nil), for: UIControlState.normal)
        wrapperView.backgroundColor = .clear
        wrapperView.showsTouchWhenHighlighted = true
        wrapperView.addTarget(self, action: #selector(self.replaceRouteButton), for: UIControlEvents.touchUpInside)
        
        let volumeView = MPVolumeView(frame: wrapperView.bounds)
        volumeView.showsVolumeSlider = false
        volumeView.showsRouteButton = false
        volumeView.isUserInteractionEnabled = false
        self.airplayRouteButton = volumeView.subviews.filter { $0 is UIButton }.first as? UIButton
        wrapperView.addSubview(volumeView)
        bottomView.addSubview(wrapperView)
        
        let subTitleImage = UIImage(named:"ic-subtitles", in: bundle, compatibleWith: nil)
        subtitlesButton.setImage(TangoPlayerUtils.imageSize(image: subTitleImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        subtitlesButton.setImage(TangoPlayerUtils.imageSize(image: subTitleImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
        subtitlesButton.addTarget(self, action: #selector(subtitlesButtonTapped(_:)), for: .touchUpInside)
        subtitlesButton.showsTouchWhenHighlighted = true
        bottomView.addSubview(subtitlesButton)
        
        let volumeMute = UIImage(named:"ic-mute", in: bundle, compatibleWith: nil)
        let volumeNormal = UIImage(named:"ic-mute4", in: bundle, compatibleWith: nil)
        volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeNormal!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        volumeButton.setImage(TangoPlayerUtils.imageSize(image: volumeMute!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
        volumeButton.addTarget(self, action: #selector(volumeButtonTapped(_:)), for: .touchUpInside)
        volumeButton.showsTouchWhenHighlighted = true
        bottomView.addSubview(volumeButton)
    }
    @objc private func replaceRouteButton() {
        airplayRouteButton?.sendActions(for: .touchUpInside)
    }
    internal func setupViewAutoLayout() {
        replayButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        /*// top view layout
         topView.snp.makeConstraints { [weak self] (make) in
         guard let strongSelf = self else { return }
         make.left.equalTo(strongSelf)
         make.right.equalTo(strongSelf)
         make.top.equalTo(strongSelf)
         make.height.equalTo(64)
         }
         closeButton.snp.makeConstraints { [weak self] (make) in
         guard let strongSelf = self else { return }
         make.left.equalTo(strongSelf.topView).offset(10)
         make.top.equalTo(strongSelf.topView).offset(28)
         make.height.equalTo(30)
         make.width.equalTo(30)
         }
         titleLabel.snp.makeConstraints { [weak self] (make) in
         guard let strongSelf = self else { return }
         make.left.equalTo(strongSelf.closeButton.snp.right).offset(20)
         make.centerY.equalTo(strongSelf.closeButton.snp.centerY)
         }*/
        
        // bottom view layout
        bottomView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf)
            make.right.equalTo(strongSelf)
            make.bottom.equalTo(strongSelf)
            make.height.equalTo(52)
        }
        
        playButtion.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.bottomView).offset(20)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.top.equalTo(5)
            //make.centerY.equalTo(strongSelf.bottomView)
        }
        fullscreenButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.playButtion)
            make.right.equalTo(strongSelf.bottomView).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        /*airplayButton.snp.makeConstraints { [weak self] (make) in
         guard let strongSelf = self else { return }
         make.centerY.equalTo(strongSelf.playButtion)
         make.right.equalTo(strongSelf.fullscreenButton.snp.left).offset(-10)
         make.height.equalTo(30)
         make.width.equalTo(30)
         }
         airplayView.snp.makeConstraints { [weak self] (make) in
         guard let strongSelf = self else { return }
         make.centerY.equalTo(strongSelf.playButtion)
         make.right.equalTo(strongSelf.fullscreenButton.snp.left).offset(-10)
         make.height.equalTo(30)
         make.width.equalTo(30)
         }*/
        wrapperView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.playButtion)
            make.right.equalTo(strongSelf.fullscreenButton.snp.left).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        subtitlesButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.playButtion)
            make.right.equalTo(strongSelf.wrapperView.snp.left).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        volumeButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.playButtion)
            make.right.equalTo(strongSelf.subtitlesButton.snp.left).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.playButtion.snp.right).offset(10)
            make.centerY.equalTo(strongSelf.playButtion)
            make.height.equalTo(30)
        }
        
        endtimeLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.right.equalTo(strongSelf.volumeButton.snp.left).offset(-10)
            make.centerY.equalTo(strongSelf.playButtion)
            make.height.equalTo(30)
        }
        
        //timeSlider.snp.removeConstraints()
        timeSlider.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            /*//make.centerY.equalTo(strongSelf.playButtion)
             make.centerY.equalTo(strongSelf.playButtion)
             make.right.equalTo(strongSelf.endtimeLabel.snp.left).offset(-10)
             make.left.equalTo(strongSelf.timeLabel.snp.right).offset(10)
             make.height.equalTo(25)*/
            
            if isFullScreen {
                make.centerY.equalTo(strongSelf.playButtion)
                make.right.equalTo(strongSelf.endtimeLabel.snp.left).offset(-10)
                make.left.equalTo(strongSelf.timeLabel.snp.right).offset(10)
                make.height.equalTo(25)
            }
            else{
                make.width.equalTo(strongSelf.bottomView)
                make.bottom.equalTo(strongSelf.bottomView).offset(10.8)//10.8
                make.height.equalTo(25)
            }
        }
        loadingIndicator.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
}
public extension UIImage {
    public var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
}


