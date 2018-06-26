//
//  TTPlayerView.swift
//  TeletangoPlayer
//
//  Created by Nagaraju Surisetty on 10/5/17.
//  Copyright © 2017 Nagaraju Surisetty. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI
import MobileCoreServices

public protocol TTPlayerDelegate: class {
     func orientationChnaged(_ isLandscape: Bool)
     func didTouchedOnthePlayer(xPercentage:Float,yPercentage:Float)
     func didTappedontheobject()
}

open class TTPlayerView: UIView,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,TangoPlayerDelegate,TangoPlayerViewDelegate,YouTubePlayerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    /** Used to respond to player events */
    public weak var delegate: TTPlayerDelegate?
    /**
      /// playerView UIView
      @discussion playerView UIView is the background view of Avplayer and overlays
     */
     var playerView                   = UIView()
    
    /* selectedlink NSString
     selectedlink is used to pass the select action links from overlay/Ads to Events
     */
      var selectedlink                 = NSString()
    
    /* telNumber NSString
     telNumber is used to pass the select action links from overlay/Ads to Events
     */
      var telNumber                    = NSString()
    
    /* overlaySubView UIView
     overlaySubView was used to show overlay ads below the player in potrait mode
     */
      var overlaySubView               = UIView()
    
    /* fullScreenOverlay UIView
     fullScreenOverlay was used to show overlay ads on the top of the player in Landscape/Fullscreen mode
     */
      var fullScreenOverlay            = UIView()
    
    /* recentQuizAd NSMutableArray
     recentQuizAd was used to for storing quiz ads details
     */
      var  recentQuizAd                = NSMutableArray()
    
    /* overlayImage overlayImage
     overlayImage was used to for showing image overlay's
     Reason to take it as globally is to resize in full screen
     */
      var  overlayImage                = UIImageView()
    
    /* placeholderLogo UIImage
     placeholderLogo is the image to show on top of the Video, User can pass an image else it will take default value
     */
      public      var  placeholderLogo             = UIImage()
    
    /* queuePlayer AVQueuePlayer
     AVQueuePlayer is used to play multiple video's in queue
     */
    var queuePlayer                  : AVQueuePlayer!
    
    /* playerViewController AVPlayerViewController
     playerViewController is default Avplayer view controller class
     */
    var playerViewController         = AVPlayerViewController()
    
    /* dataLoader TTDataLoader
     dataLoader Model Object with multiple methods
     */
    //fileprivate var dataLoader                      : TTPDataLoader!
    
    /* singleProgramObj SingleProgram
     singleProgramObj Model Object
     */
    //fileprivate var singleProgramObj                : TTPSingleProgram!
    
    /* singleProgramDetailObj SingleProgramDetail
     singleProgramDetailObj Model Object
     */
    //var singleProgramDetailObj          : TTPSingleProgramDetail!
    
    /*adTimer Timer
     adTimeris used to check the Ads
     */
      fileprivate var adTimer                         = Timer()
    
    /*skipBtnTimer Timer
     skipBtnTimer used to check the visiblity of skip button on an ad
     */
      fileprivate var skipBtnTimer                    = Timer()
    
    /*videoOverLayTimer Timer
     videoOverLayTimer used to check the overlay's in full screen and normal screen
     */
      fileprivate var videoOverLayTimer               = Timer()
    
    /*recentAdArray NSMutableArray
     recentAdArray used to store most recent array of ad temporarily
     */
    fileprivate var recentAdArray                   = NSMutableArray()

    /*videoEventsparams NSMutableDictionary
     videoEventsparams used to store required parms for event logs at certain time intervel temporarily
     */
      fileprivate var videoEventsparams               = NSMutableDictionary()
    
    /*skipBtn UIButton
     skipBtn used to skip the ads at cetain interval
     */
      fileprivate var skipBtn                         = UIButton()
    
    /*aux/dux CMTime
     aux/dux used to store current and total duration of a video temporarily
     */
      fileprivate var aux                             = CMTime()
      fileprivate var dur                             = CMTime()
    
    /*mainPlayerTime CMTime
     mainPlayerTime used to store current time of the player when ever an ad comes in the mid
     */
    fileprivate var mainPlayerTime: TimeInterval = 0
    
    /*isVideoinFullscreen Bool
     isVideoinFullscreen used to check the player full/normal screen status
     */
    var isVideoinFullscreen: Bool = false
    
    /*isFromAd Bool
     isFromAd used to check the current player item type
     */
     fileprivate var isFromAd: Bool = false
    
    /*isVideostarted Bool
     isVideostarted used to check the current player Status
     */
    fileprivate var isVideostarted: Bool = false
    
    fileprivate var youtubePlayerView                :  YouTubePlayerView!
    //fileprivate var headerView                     =  ParallaxHeaderView()
    fileprivate var playerTime: Int = 0
     // var detailsListingTV                          : UITableView!
    fileprivate var avWidth:CGFloat = 0
    fileprivate var avHeight:CGFloat = 0
    public var tangoPlayer : TangoPlayer?
    fileprivate var croppedImage                    = UIImageView()
    var timeString                      : Int = 0
    var videoRectFrame                  : CGRect = .zero
    public var playIcon                        =  UIImage()
    public var pauseIcon                       =  UIImage()
    var        commentView                     = UIView()
    var        twitterFeedImage                = UIImageView()
    var        commomFeedView                  = UIView()
    var        commentTV                       = UITextView()
    var        closeBtn                        = UIButton()
    var       selectedMediaType                = NSString()
    var       selectedVideoPath                = NSURL()
    var       contentInfo                      : TTContentDetail! //= TTContentDetail.sharedInstance
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   /*override init(frame: CGRect) {
        super.init(frame: frame)
        initWithParallax()
        initWithPlayerView()
    }*/
    //MARK:***************Init Method**********************
    /**
     Call when User intialize theis sdk with frame from there app
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        print("INIT Method Intialized")
        //initWithParallax()
        //initWithPlayerView()
    }
    public convenience init(frame: CGRect, playImage: UIImage?=nil, pauseImage: UIImage?=nil){
        self.init(frame: frame) // calls the initializer above
        if(playImage != nil){
           if(playImage?.hasContent)!{
            playIcon = playImage!
            }
        }
        if(pauseImage != nil){
        if(pauseImage?.hasContent)!{
         pauseIcon = pauseImage!
        }
        }
         initWithPlayerView()
    }
    public convenience init(frame: CGRect, playImage: UIImage?=nil, pauseImage: UIImage?=nil,localFileUrl: NSString?=nil){
        self.init(frame: frame) // calls the initializer above
        if(playImage != nil){
            if(playImage?.hasContent)!{
                playIcon = playImage!
            }
        }
        if(pauseImage != nil){
            if(pauseImage?.hasContent)!{
                pauseIcon = pauseImage!
            }
        }
        initWithPlayerViewWithLocalFileUrl(videoUrl: localFileUrl!)
    }
    required public init?(coder aDecoder: NSCoder) {
        //youtubePlayerView = nil
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:***************Intilaize Player Method**********************
    /**
     Call when User want to add the player
     */
    fileprivate func initWithPlayerViewWithLocalFileUrl(videoUrl:NSString){
        let videoURL = URL(string: videoUrl as String)
        playerView.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: self.frame.size.height)
        playerView.backgroundColor = UIColor.clear
        self.addSubview(playerView)
        if videoURL != nil {
            tangoPlayer = TangoPlayer(URL: videoURL!)
        }
        tangoPlayer?.delegate = self
        playerView.addSubview((tangoPlayer?.displayView)!)
        tangoPlayer?.backgroundMode = .proceed
        tangoPlayer?.displayView.delegate = self
        tangoPlayer?.displayView.isAds = false
        tangoPlayer?.displayView.frame = CGRect(x:0, y:0, width:playerView.frame.size.width, height: playerView.frame.size.height-20)//-118
        //player?.displayView.backgroundColor = UIColor.clear
        tangoPlayer?.displayView.playerPlayIcon = playIcon;
        tangoPlayer?.displayView.playerPauseIcon = pauseIcon
        //tangoPlayer?.displayView.updateCustomImages()
        tangoPlayer?.play()
    }
    fileprivate func initWithPlayerView() {
        print("First")
        contentInfo = TTContentDetail.sharedInstance
        //self.dataLoader = TTPDataLoader.sharedTeleTangoData() as! TTPDataLoader
        //singleProgramObj = self.dataLoader.singleProgram
        //singleProgramDetailObj = singleProgramObj.singlePrgDetail
        print("Second")
        playerView.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: self.frame.size.height)
        playerView.backgroundColor = UIColor.clear
        self.addSubview(playerView)
       print("Third")
        if (contentInfo.content_type != nil && contentInfo.content_type != "<null>" && contentInfo.content_type != "(null)" && contentInfo.content_type == "video"){
                if (contentInfo.content_url.range(of: "youtube") != nil){
                    youtubePlayerView = YouTubePlayerView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height: playerView.frame.size.height))
                    youtubePlayerView.delegate = self
                    youtubePlayerView.backgroundColor = UIColor.black
                    playerView.addSubview(youtubePlayerView)
                    let urlArray = contentInfo.content_url.components(separatedBy: "=")
                    let videoId: String = urlArray[1]
                    youtubePlayerView.loadVideoID(videoId)
            }
            else{
            print("insert_videos %@",contentInfo.insert_videos)
            if contentInfo.insert_videos.count>0{
                let item = contentInfo.insert_videos[0] as! NSDictionary
                if  Int(item["start_offset_secs"] as! Int) != 0 {
                     print("Fourth")
                    let videoURL = URL(string: contentInfo.content_url)
                    if videoURL != nil {
                        tangoPlayer = TangoPlayer(URL: videoURL!)
                    }
                    tangoPlayer?.delegate = self
                    playerView.addSubview((tangoPlayer?.displayView)!)
                    tangoPlayer?.backgroundMode = .proceed
                    tangoPlayer?.displayView.delegate = self
                    tangoPlayer?.displayView.isAds = false
                    tangoPlayer?.displayView.frame = CGRect(x:0, y:0, width:playerView.frame.size.width, height: playerView.frame.size.height-20)//-118
                    //player?.displayView.backgroundColor = UIColor.clear
                    tangoPlayer?.displayView.playerPlayIcon = playIcon;
                    tangoPlayer?.displayView.playerPauseIcon = pauseIcon
                    //tangoPlayer?.displayView.updateCustomImages()
                    tangoPlayer?.play()
                    print("Fifth")
                    
                }
                else{
                     print("Sixth")
                    let adsArray = contentInfo.insert_videos
                    isFromAd = true
                    recentAdArray.removeAllObjects()
                    recentAdArray.add(adsArray[0])
                    let item = adsArray[0] as! NSDictionary
                    
                    let videoURL = URL(string: item["recorded_video"] as! String)
                    if videoURL != nil {
                        tangoPlayer = TangoPlayer(URL: videoURL!)
                    }
                    tangoPlayer?.delegate = self
                    playerView.addSubview((tangoPlayer?.displayView)!)
                    tangoPlayer?.backgroundMode = .proceed
                    tangoPlayer?.displayView.delegate = self
                    tangoPlayer?.displayView.isAds = true
                    tangoPlayer?.displayView.frame = CGRect(x:0, y:0, width:playerView.frame.size.width, height: playerView.frame.size.height-20)//-118
                    //player?.displayView.backgroundColor = UIColor.clear
                    tangoPlayer?.displayView.playerPlayIcon = playIcon;
                    tangoPlayer?.displayView.playerPauseIcon = pauseIcon
                    //tangoPlayer?.displayView.updateCustomImages()
                    tangoPlayer?.play()
                    
                    skipBtnTimer.invalidate()
                    skipBtnTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showSkipButton), userInfo: nil, repeats: true)
                    videoOverLayTimer.invalidate()
                    overlaySubView.removeFromSuperview()
                    fullScreenOverlay.removeFromSuperview()
                    videoOverLayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(videoOverLayAdTimer), userInfo: nil, repeats: true)
                }
            }
            else{
                print("Seventh")
                let videoURL = URL(string: contentInfo.content_url)
                if videoURL != nil {
                    tangoPlayer = TangoPlayer(URL: videoURL!)
                }
                tangoPlayer?.delegate = self
                playerView.addSubview((tangoPlayer?.displayView)!)
                tangoPlayer?.backgroundMode = .proceed
                tangoPlayer?.displayView.delegate = self
                tangoPlayer?.displayView.isAds = false
                tangoPlayer?.displayView.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: playerView.frame.size.height-20)//-118
                //player?.displayView.backgroundColor = UIColor.clear
                tangoPlayer?.displayView.playerPlayIcon = playIcon;
                tangoPlayer?.displayView.playerPauseIcon = pauseIcon
                //tangoPlayer?.displayView.updateCustomImages()
                tangoPlayer?.play()
            }
            if contentInfo.insert_videos.count>0{
                adTimer.invalidate()
                adTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForAdWithTimer), userInfo: nil, repeats: true)
            }
            videoOverLayTimer.invalidate()
            videoOverLayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(videoOverLayAdTimer), userInfo: nil, repeats: true)
            print("Eighth")
            }
        }
        else if (contentInfo.content_type != "<null>" && contentInfo.content_type != "(null)" && contentInfo.content_type == "thumbnail"){
            let thumbnilImage = UIImageView()
            thumbnilImage.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: playerView.frame.size.height)
            let bundle = Bundle(for: type(of: self))
            thumbnilImage.image = UIImage(named: "TTPlayerResources.bundle/blurImage", in: bundle, compatibleWith: nil)
            thumbnilImage.imageFromServerURL(urlString: contentInfo.content_thumbnil)
            thumbnilImage.clipsToBounds=true
            thumbnilImage.backgroundColor = UIColor.black
            thumbnilImage.isUserInteractionEnabled = true
            thumbnilImage.contentMode = UIViewContentMode.scaleAspectFill
            playerView.addSubview(thumbnilImage)
        }
        else if (contentInfo.content_type != "<null>" && contentInfo.content_type != "(null)" && contentInfo.content_type == "document"){
            let thumbnilImage = UIImageView()
            thumbnilImage.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: playerView.frame.size.height)
            let bundle = Bundle(for: type(of: self))
            thumbnilImage.image = UIImage(named: "TTPlayerResources.bundle/blurImage", in: bundle, compatibleWith: nil)
            thumbnilImage.imageFromServerURL(urlString: contentInfo.content_thumbnil)
            thumbnilImage.clipsToBounds=true
            thumbnilImage.backgroundColor = UIColor.black
            thumbnilImage.isUserInteractionEnabled = true
            thumbnilImage.contentMode = UIViewContentMode.scaleAspectFill
            playerView.addSubview(thumbnilImage)
        }
    }
    public func play(){
        if(contentInfo != nil){
         if (contentInfo.content_type != "<null>" && contentInfo.content_type != "(null)" && contentInfo.content_type == "video"){
             if (contentInfo.content_url.range(of: "youtube") == nil){
                //queuePlayer.play()
                tangoPlayer?.play()
        }
        }
        }
        else{
          tangoPlayer?.play()
        }
    }
    public func stop(){
        if(contentInfo != nil){
        if (contentInfo.content_type != "<null>" && contentInfo.content_type != "(null)" && contentInfo.content_type == "video"){
           if (contentInfo.content_url.range(of: "youtube") == nil){
                NotificationCenter.default.removeObserver(self)
                skipBtnTimer.invalidate()
                videoOverLayTimer.invalidate()
                adTimer.invalidate()
                tangoPlayer?.pause()
        }
        }
        }
        else{
            NotificationCenter.default.removeObserver(self)
            skipBtnTimer.invalidate()
            videoOverLayTimer.invalidate()
            adTimer.invalidate()
            tangoPlayer?.pause()
        }
    }
    public func pause(){
        if(contentInfo != nil){
         if (contentInfo.content_type != "<null>" && contentInfo.content_type != "(null)" && contentInfo.content_type == "video"){
            if (contentInfo.content_url.range(of: "youtube") == nil){
            //queuePlayer.pause()
            tangoPlayer?.pause()
        }
        }
        }
        else{
          tangoPlayer?.pause()
        }
    }
     /**
     ************TangoPlayer Delegates
     */
    public func tangoPlayer(_ player: TangoPlayer, playerFailed error: TangoPlayerError) {
        print(error)
    }
    public func tangoPlayer(_ player: TangoPlayer, stateDidChange state: TangoPlayerState) {
        print("player State ",state)
        if (state == TangoPlayerState.paused){
            print("Current Time at paused State %@",player.currentDuration)
            print("Total Time at paused State %@",player.totalDuration)
            if(contentInfo != nil){
            videoEventsparams = [
                "program_id" : contentInfo.content_id,
                "video_url" : contentInfo.content_url,
                "program_name" : contentInfo.content_name
            ]
                var dTotalSeconds : Int = 0
                if (player.totalDuration.isNaN == false ){
                    dTotalSeconds = Int(player.totalDuration)
                }
            let dCurrentSeconds : Int = Int(player.currentDuration)
            videoEventsparams["video_source"] = APPNAME
            videoEventsparams["total_video_time"] = dTotalSeconds
            videoEventsparams["drop_time"] = dCurrentSeconds
            print("videoEventsparams \(videoEventsparams)")
            TTPWebserviceHelper().logEventofType(CONTENT_PLAY_PAUSE, withParameters: videoEventsparams as! [AnyHashable : Any])
            }
            var subViews: [UIView] = (player.displayView.contentOverlay.subviews)
            for i in 0..<subViews.count {
                let views = subViews[i]
                if(views.isKind(of: UIWebView.self)){
                    print("Webview Exits")
                    let webView:UIWebView =  views as! UIWebView
                    webView.stringByEvaluatingJavaScript(from:"myTimerPause()")//myTimerStop()//myTimerStart()
                    break;
                }
            }
        }
         if (state == TangoPlayerState.resume){
        var subViews: [UIView] = (player.displayView.contentOverlay.subviews)
        for i in 0..<subViews.count {
            let views = subViews[i]
            if(views.isKind(of: UIWebView.self)){
                print("Webview Exits")
                let webView:UIWebView =  views as! UIWebView
                webView.stringByEvaluatingJavaScript(from:"myTimerStart()")//myTimerStop()//myTimerStart()
                break;
            }
        }
        }
        if (state == TangoPlayerState.playing){
            if isFromAd == false {
                if(contentInfo != nil){
                videoEventsparams = [
                    "program_id" : contentInfo.content_id,
                    "video_url" : contentInfo.content_url,
                    "program_name" : contentInfo.content_name
                ]
                    var dTotalSeconds : Int = 0
                    if (player.totalDuration.isNaN == false ){
                        dTotalSeconds = Int(player.totalDuration)
                    }
                let dCurrentSeconds : Int = Int(player.currentDuration)
                videoEventsparams["video_source"] = APPNAME
                videoEventsparams["total_video_time"] = dTotalSeconds
                videoEventsparams["drop_time"] = dCurrentSeconds
                print("videoEventsparams \(videoEventsparams)")
                if(dCurrentSeconds == 0){
                TTPWebserviceHelper().logEventofType(CONTENT_PLAY_START, withParameters: videoEventsparams as! [AnyHashable : Any])
                }
                else if(dCurrentSeconds > 0){
                TTPWebserviceHelper().logEventofType(CONTENT_PLAY_RESUME, withParameters: videoEventsparams as! [AnyHashable : Any])
                }
                }
                var subViews: [UIView] = (player.displayView.contentOverlay.subviews)
                for i in 0..<subViews.count {
                    let views = subViews[i]
                    if(views.isKind(of: UIWebView.self)){
                        print("Webview Exits")
                        let webView:UIWebView =  views as! UIWebView
                        webView.stringByEvaluatingJavaScript(from:"myTimerStart()")//myTimerStop()//myTimerStart()
                        break;
                    }
                }
            }
            else if (isFromAd == true && recentAdArray.count>0){
                
            }
        }
        if (state == TangoPlayerState.playFinished){
            print("Current Time at finished State %@",player.currentDuration)
            print("Total Time at finished State %@",player.totalDuration)
        }
    }
    public func tangoPlayer(_ player: TangoPlayer, bufferStateDidChange state: TangoPlayerBufferstate) {
        print("buffer State", state)
        /*if state == TangoPlayerBufferstate.readyToPlay {
            croppedImage.removeFromSuperview()
        }*/
    }
    public func tangoPlayerPeriodicObserver(_ player: TangoPlayer, playercurrentTime:Int,DifferenceTime:Int,videoBounds: CGRect,isForwarded:Bool){
        let dataSource = UserDefaults.standard.array(forKey: "personlizationArray")
        timeString = playercurrentTime
        videoRectFrame = videoBounds
        //let  adsArray = sqLiteManager().find(nil, from: "IVPData", where: String(format:"(%d BETWEEN attr_start_time AND attr_end_time)",playercurrentTime))! as NSArray
        if (dataSource != nil && dataSource!.count>0){
        let predicate = NSPredicate(format: "%d >= attr_start_time AND %d <= attr_end_time", playercurrentTime,playercurrentTime)
        let adsArray = dataSource?.filter { predicate.evaluate(with: $0) } as! NSArray
        if (adsArray != nil){
            if(adsArray.count == 0){
                let subViews: [UIView] = (player.displayView.contentOverlay.subviews)
                for subview in subViews{
                    UIView.animate(withDuration: 1, animations: {
                        subview.alpha = 0
                    }) { _ in
                        subview.removeFromSuperview()
                    }
                }
            }
            for j in 0..<adsArray.count {
                let item = adsArray[j] as! NSDictionary
                let subViews: [UIView] = (player.displayView.contentOverlay.subviews)
                if(subViews.count>0){
                    let tag =  Int((item["overlay_id"] as! NSString).intValue)
                    if (player.displayView.contentOverlay.viewWithTag(tag) != nil) {
                        //print("Inside first One")
                        //let  startValue :Int = Int((item["attr_start_time"] as! NSString).intValue)
                        //let  endValue :Int = Int((item["attr_end_time"] as! NSString).intValue)
                        let  startValue :Int = Int(item["attr_start_time"] as! Int)
                        let  overlay_x_min : CGFloat = CGFloat((item["anim_x_min"] as! NSString).floatValue)
                        let  overlay_y_min : CGFloat = CGFloat((item["anim_y_min"] as! NSString).floatValue)
                        let  overlay_x_max : CGFloat = CGFloat((item["anim_x_max"] as! NSString).floatValue)
                        let  overlay_y_max : CGFloat = CGFloat((item["anim_y_max"] as! NSString).floatValue)
                        let  overlay_z_max : CGFloat = CGFloat((item["anim_z_pos"] as! NSString).floatValue)
                        
                        let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                        let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                        let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                        
                        let xMinValue :CGFloat = (overlay_x_min * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
                        let xMaxValue :CGFloat = (overlay_x_max * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
                        
                        let yMinValue :CGFloat = (overlay_y_min * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
                        let yMaxValue :CGFloat = (overlay_y_max * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
                        
                        let p1 = CGPoint(x: videoBounds.origin.x + xMinValue, y: videoBounds.origin.y + yMinValue)
                        let p2 = CGPoint(x: videoBounds.origin.x + xMaxValue, y: videoBounds.origin.y  + yMaxValue)
                        
                        let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                        
                        let xradians = xdegrees * .pi / 180
                        let yradians = ydegrees * .pi / 180
                        let zradians = zdegrees * .pi / 180
                        let  contentMode :NSString = item["content_text_gravity"] as! NSString
                        let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                        let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                        var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                        if(UIDevice.current.userInterfaceIdiom == .pad){
                            fontSize = 1.5*fontSize
                        }
                        if(player.displayView.isFullScreen == true){
                            fontSize = fontSize*1.2
                        }
                        let  backgroundalpha :CGFloat = CGFloat((item["content_background_alpha"] as! NSString).floatValue)
                        let  textalpha :CGFloat = CGFloat((item["content_text_color_alpha"] as! NSString).floatValue)
                        
                        let viewWithTag = player.displayView.contentOverlay.viewWithTag(tag)
                        if(viewWithTag?.isKind(of: UILabel.self))!{
                            let subLabel:UILabel =  player.displayView.contentOverlay.viewWithTag(tag) as! UILabel
                            let text = item["content"] as! String
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                subLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            /*UIView.animate(withDuration: 0.5, animations: {
                             subLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             })*/
                            subLabel.layer.zPosition = overlay_z_max
                            subLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            subLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            if(contentMode == "right"){
                            subLabel.textAlignment=NSTextAlignment.right
                            }
                            else if(contentMode == "left"){
                                subLabel.textAlignment=NSTextAlignment.left
                            }
                            else{
                            subLabel.textAlignment=NSTextAlignment.center
                            }
                            subLabel.numberOfLines = 0
                            subLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                            subLabel.text = text
                            subLabel.tag = startValue
                            if (xScale == 1.0 && yScale == 1.0 ){
                                //let oldFrame : CGRect = subLabel.frame
                                //subLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                //subLabel.frame = oldFrame
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    subLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            subLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                subLabel.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    subLabel.transform = subLabel.transform.scaledBy(x: xScale, y:yScale)
                                }, completion: nil )
                            }
                            /*if let recognizers = subLabel.gestureRecognizers {
                                for recognizer in recognizers {
                                    subLabel.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                                }
                            }
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            subLabel.isUserInteractionEnabled = true
                            subLabel.addGestureRecognizer(tapGestureOnActionLabel)*/
                        }
                        if(viewWithTag?.isKind(of: UIImageView.self))!{
                            let overlayImageBg:UIImageView =  player.displayView.contentOverlay.viewWithTag(tag) as! UIImageView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                overlayImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            /*UIView.animate(withDuration: 0.5, animations: {
                             overlayImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             })*/
                            overlayImageBg.clipsToBounds=true
                            overlayImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            overlayImageBg.layer.zPosition = overlay_z_max
                            overlayImageBg.imageFromServerURL(urlString: item["content"] as! String)
                            overlayImageBg.contentMode=UIViewContentMode.scaleAspectFit ///scaleAspectFill
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                overlayImageBg.transform = CGAffineTransform.identity
                                overlayImageBg.transform = overlayImageBg.transform.scaledBy(x: xScale, y:yScale)
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    overlayImageBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            overlayImageBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            /*if let recognizers = overlayImageBg.gestureRecognizers {
                                for recognizer in recognizers {
                                    overlayImageBg.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                                }
                            }
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            overlayImageBg.isUserInteractionEnabled = true
                            overlayImageBg.addGestureRecognizer(tapGestureOnActionLabel)*/
                        }
                        if(viewWithTag?.isKind(of: UIView.self))!{
                            let quizBg:UIView =  player.displayView.contentOverlay.viewWithTag(tag) as! UIView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                quizBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            quizBg.layer.zPosition = overlay_z_max
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                quizBg.transform = CGAffineTransform.identity
                                quizBg.transform = quizBg.transform.scaledBy(x: xScale, y:yScale)
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    quizBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            quizBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            /*if let recognizers = quizBg.gestureRecognizers {
                                for recognizer in recognizers {
                                    quizBg.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                                }
                            }
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            quizBg.isUserInteractionEnabled = true
                            quizBg.addGestureRecognizer(tapGestureOnActionLabel)*/
                        }
                        if(viewWithTag?.isKind(of: UIWebView.self))!{
                            
                            let webView:UIWebView =  player.displayView.contentOverlay.viewWithTag(tag) as! UIWebView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                webView.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            webView.isOpaque = false
                            webView.layer.zPosition = overlay_z_max
                            webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            //let url = URL(string: item["content"] as! String)
                            //let request = URLRequest(url: url!)
                            webView.scalesPageToFit = true
                            webView.isMultipleTouchEnabled = false
                            //webView.contentMode = UIViewContentMode.scaleAspectFit
                            webView.isUserInteractionEnabled = true;
                            //webView.loadHTMLString("", baseURL: url)
                            //webView.loadRequest(request)
                            
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                webView.transform = CGAffineTransform.identity
                                webView.transform = webView.transform.scaledBy(x: xScale, y:yScale)
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    webView.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            /*if let recognizers = webView.gestureRecognizers {
                                for recognizer in recognizers {
                                    webView.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                                }
                            }*/
                            
                            /*let webView:WKWebView =  player.displayView.contentOverlay.viewWithTag(tag) as! WKWebView
                             UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                             webView.frame = CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             }, completion: nil )
                             webView.translatesAutoresizingMaskIntoConstraints = false
                             webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                             let url = URL(string: item["content"] as! String)
                             let request = URLRequest(url: url!)
                             webView.isMultipleTouchEnabled = false
                             webView.load(request)*/
                            
                            webView.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            /*let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            webView.isUserInteractionEnabled = true
                            webView.addGestureRecognizer(tapGestureOnActionLabel)*/
                        }
                    }
                    else{
                        print("Inside Second One")
                        print("Inside Not Equal toooooooo at %@ with array count %@ of tg %@",playercurrentTime,adsArray.count,tag)
                        //let viewWithTag = player.displayView.contentOverlay.viewWithTag(tag)
                        //viewWithTag?.removeFromSuperview()
                        //let  startValue :Int = Int((item["attr_start_time"] as! NSString).intValue)
                        //let  endValue :Int = Int((item["attr_end_time"] as! NSString).intValue)
                        let  startValue :Int = Int(item["attr_start_time"] as! Int)
                        let  endValue :Int = Int(item["attr_end_time"] as! Int)
                        let  overlay_x_min : CGFloat = CGFloat((item["anim_x_min"] as! NSString).floatValue)
                        let  overlay_y_min : CGFloat = CGFloat((item["anim_y_min"] as! NSString).floatValue)
                        let  overlay_x_max : CGFloat = CGFloat((item["anim_x_max"] as! NSString).floatValue)
                        let  overlay_y_max : CGFloat = CGFloat((item["anim_y_max"] as! NSString).floatValue)
                        let  overlay_z_max : CGFloat = CGFloat((item["anim_z_pos"] as! NSString).floatValue)
                        
                        let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                        let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                        let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                        
                        let xMinValue :CGFloat = (overlay_x_min * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
                        let xMaxValue :CGFloat = (overlay_x_max * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
                        
                        let yMinValue :CGFloat = (overlay_y_min * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
                        let yMaxValue :CGFloat = (overlay_y_max * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
                        
                        let p1 = CGPoint(x: videoBounds.origin.x + xMinValue, y: videoBounds.origin.y + yMinValue)
                        let p2 = CGPoint(x: videoBounds.origin.x + xMaxValue, y: videoBounds.origin.y  + yMaxValue)
                        
                        let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                        
                        let xradians = xdegrees * .pi / 180
                        let yradians = ydegrees * .pi / 180
                        let zradians = zdegrees * .pi / 180
                        let  contentMode :NSString = item["content_text_gravity"] as! NSString
                        let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                        let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                        var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                        if(UIDevice.current.userInterfaceIdiom == .pad){
                            fontSize = 1.5*fontSize
                        }
                        if(player.displayView.isFullScreen == true){
                            fontSize = fontSize*1.2
                        }
                        let  backgroundalpha :CGFloat = CGFloat((item["content_background_alpha"] as! NSString).floatValue)
                        let  textalpha :CGFloat = CGFloat((item["content_text_color_alpha"] as! NSString).floatValue)
                        
                        if( item["content_type"] as! String == "TEXT"){
                            let text = item["content"] as! String
                            DispatchQueue.main.async{
                                
                                let textLabel = UILabel()
                                textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                textLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                textLabel.font = UIFont(name: "Helvetica", size: fontSize)
                                if(contentMode == "right"){
                                    textLabel.textAlignment=NSTextAlignment.right
                                }
                                else if(contentMode == "left"){
                                    textLabel.textAlignment=NSTextAlignment.left
                                }
                                else{
                                    textLabel.textAlignment=NSTextAlignment.center
                                }
                                textLabel.numberOfLines = 0
                                textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                                textLabel.text = text
                                textLabel.layer.zPosition = overlay_z_max
                                if (xScale == 1.0 && yScale == 1.0 ){
                                    let oldFrame : CGRect = textLabel.frame
                                    textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                    textLabel.frame = oldFrame
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                self.tangoPlayer?.displayView.contentOverlay.addSubview(textLabel)
                                
                                textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    textLabel.transform = CGAffineTransform.identity
                                    //UIView.animate(withDuration: 0.25, animations: {
                                    textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
                                    //})
                                }
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                textLabel.isUserInteractionEnabled = true
                                textLabel.addGestureRecognizer(tapGestureOnActionLabel)
                            }
                        }
                        if (item["content_type"] as! String == "IMAGE"){
                            DispatchQueue.main.async{
                                let userImageBg = UIImageView()
                                userImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                userImageBg.clipsToBounds=true
                                userImageBg.tag = startValue
                                userImageBg.imageFromServerURL(urlString: item["content"] as! String)
                                //userImageBg.image = self.placeholderLogo
                                userImageBg.layer.zPosition = overlay_z_max
                                userImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                userImageBg.contentMode=UIViewContentMode.scaleAspectFit //scaleAspectFill
                                player.displayView.contentOverlay.addSubview(userImageBg)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    userImageBg.transform = CGAffineTransform.identity
                                    UIView.animate(withDuration: 0.25, animations: {
                                        userImageBg.transform = userImageBg.transform.scaledBy(x: xScale, y:yScale)
                                    })
                                }
                                if (xScale == 1 && yScale == 1 ){
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    userImageBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                userImageBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                userImageBg.isUserInteractionEnabled = true
                                userImageBg.addGestureRecognizer(tapGestureOnActionLabel)
                            }
                        }
                        if (item["content_type"] as! String == "WEB"){
                            DispatchQueue.main.async{
                                let webView    = UIWebView()
                                webView.frame = CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                webView.isOpaque = false
                                webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                webView.layer.zPosition = overlay_z_max
                                player.displayView.contentOverlay.addSubview(webView)
                                let url = URL(string: item["content"] as! String)
                                let request = URLRequest(url: url!)
                                webView.scalesPageToFit = true
                                webView.isMultipleTouchEnabled = false
                                //webView.contentMode = UIViewContentMode.scaleAspectFit
                                webView.isUserInteractionEnabled = true;
                                webView.loadRequest(request)
                                
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    webView.transform = CGAffineTransform.identity
                                    UIView.animate(withDuration: 0.25, animations: {
                                        webView.transform = webView.transform.scaledBy(x: xScale, y:yScale)
                                    })
                                }
                                if (xScale == 1 && yScale == 1 ){
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    webView.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                /*let webViewConfiguration = WKWebViewConfiguration()
                                 let webView = WKWebView(frame: CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height), configuration: webViewConfiguration)
                                 webView.translatesAutoresizingMaskIntoConstraints = false
                                 webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                                 let url = URL(string: item["content"] as! String)
                                 let request = URLRequest(url: url!)
                                 webView.load(request)
                                 player.displayView.contentOverlay.addSubview(webView)*/
                                
                                webView.tag =  Int((item["overlay_id"] as! NSString).intValue)
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                webView.isUserInteractionEnabled = true
                                webView.addGestureRecognizer(tapGestureOnActionLabel)
                                webView.scrollView.addGestureRecognizer(tapGestureOnActionLabel)
                                webView.gestureRecognizerShouldBegin(tapGestureOnActionLabel)
                            }
                        }
                        if (item["content_type"] as! String == "QUIZ"){
                            DispatchQueue.main.async{
                                let quizBg = UIView()
                                quizBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                quizBg.clipsToBounds=true
                                quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                quizBg.layer.zPosition = overlay_z_max
                                player.displayView.contentOverlay.addSubview(quizBg)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    quizBg.transform = CGAffineTransform.identity
                                    UIView.animate(withDuration: 0.25, animations: {
                                        quizBg.transform = quizBg.transform.scaledBy(x: xScale, y:yScale)
                                    })
                                }
                                if (xScale == 1 && yScale == 1 ){
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    quizBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                quizBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                quizBg.isUserInteractionEnabled = true
                                quizBg.addGestureRecognizer(tapGestureOnActionLabel)
                                
                                let questionString = item["content"] as! String
                                let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
                                
                                let questionLabel = UILabel()
                                questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
                                questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
                                questionLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                                if(parsedQuestion != nil){
                                    questionLabel.text = parsedQuestion
                                }
                                questionLabel.textAlignment = NSTextAlignment.center
                                questionLabel.numberOfLines = 0
                                questionLabel.adjustsFontSizeToFitWidth = true
                                quizBg.addSubview(questionLabel)
                                
                                let parsedFirstAnswer = questionString.slice(from: "$_A1_$", to: "$_A1_$")
                                let answer1Btn = UIButton()
                                answer1Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y:  (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedFirstAnswer != nil){
                                    answer1Btn.setTitle( parsedFirstAnswer, for: UIControlState.normal)
                                }
                                answer1Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer1Btn.backgroundColor=UIColor.clear
                                answer1Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer1Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer1Btn.accessibilityLabel = "1"
                                answer1Btn.layer.cornerRadius = 6.0
                                answer1Btn.layer.borderWidth = 1.0
                                answer1Btn.layer.borderColor = UIColor.black.cgColor
                                answer1Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer1Btn)
                                
                                var xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                                let parsedSecondAnswer = questionString.slice(from: "$_A2_$", to: "$_A2_$")
                                let answer2Btn = UIButton()
                                answer2Btn.frame = CGRect(x:xaxies, y: (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedSecondAnswer != nil){
                                    answer2Btn.setTitle( parsedSecondAnswer, for: UIControlState.normal)
                                }
                                answer2Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer2Btn.backgroundColor=UIColor.clear
                                answer2Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer2Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer2Btn.layer.cornerRadius = 6.0
                                answer2Btn.accessibilityLabel = "2"
                                answer2Btn.layer.borderWidth = 1.0
                                answer2Btn.layer.borderColor = UIColor.black.cgColor
                                answer2Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer2Btn)
                                
                                let parsedThirdAnswer = questionString.slice(from: "$_A3_$", to: "$_A3_$")
                                let answer3Btn = UIButton()
                                answer3Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedThirdAnswer != nil){
                                    answer3Btn.setTitle( parsedThirdAnswer, for: UIControlState.normal)
                                }
                                answer3Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer3Btn.backgroundColor=UIColor.clear
                                answer3Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer3Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer3Btn.accessibilityLabel = "3"
                                answer3Btn.layer.cornerRadius = 6.0
                                answer3Btn.layer.borderWidth = 1.0
                                answer3Btn.layer.borderColor = UIColor.black.cgColor
                                answer3Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer3Btn)
                                
                                xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                                let parsedFourthAnswer = questionString.slice(from: "$_A4_$", to: "$_A4_$")
                                let answer4Btn = UIButton()
                                answer4Btn.frame = CGRect(x:xaxies, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedFourthAnswer != nil){
                                    answer4Btn.setTitle( parsedFourthAnswer, for: UIControlState.normal)
                                }
                                answer4Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer4Btn.backgroundColor=UIColor.clear
                                answer4Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer4Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer4Btn.layer.cornerRadius = 6.0
                                answer4Btn.accessibilityLabel = "4"
                                answer4Btn.layer.borderWidth = 1.0
                                answer4Btn.layer.borderColor = UIColor.black.cgColor
                                answer4Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer4Btn)
                            }
                        }
                        /* else{
                         let viewWithTag = views.viewWithTag(tag)
                         UIView.animate(withDuration: 1.0, animations: {
                         viewWithTag?.alpha = 0
                         }) { _ in
                         viewWithTag?.removeFromSuperview()
                         }
                         }*/
                    }
                }
                else{
                    let  startValue :Int = Int(item["attr_start_time"] as! Int)
                    let  endValue :Int = Int(item["attr_end_time"] as! Int)
                    let  overlay_x_min : CGFloat = CGFloat((item["anim_x_min"] as! NSString).floatValue)
                    let  overlay_y_min : CGFloat = CGFloat((item["anim_y_min"] as! NSString).floatValue)
                    let  overlay_x_max : CGFloat = CGFloat((item["anim_x_max"] as! NSString).floatValue)
                    let  overlay_y_max : CGFloat = CGFloat((item["anim_y_max"] as! NSString).floatValue)
                    let  overlay_z_max : CGFloat = CGFloat((item["anim_z_pos"] as! NSString).floatValue)
                    let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                    let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                    let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                    let xMinValue :CGFloat = (overlay_x_min * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
                    let xMaxValue :CGFloat = (overlay_x_max * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
                    
                    let yMinValue :CGFloat = (overlay_y_min * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
                    let yMaxValue :CGFloat = (overlay_y_max * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
                    let p1 = CGPoint(x: videoBounds.origin.x + xMinValue, y: videoBounds.origin.y + yMinValue)
                    let p2 = CGPoint(x: videoBounds.origin.x + xMaxValue, y: videoBounds.origin.y  + yMaxValue)
                    
                    let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                    
                    let xradians = xdegrees * .pi / 180
                    let yradians = ydegrees * .pi / 180
                    let zradians = zdegrees * .pi / 180
                     let  contentMode :NSString = item["content_text_gravity"] as! NSString
                    let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                    let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                    var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                    if(UIDevice.current.userInterfaceIdiom == .pad){
                        fontSize = 1.5*fontSize
                    }
                    if(player.displayView.isFullScreen == true){
                        fontSize = fontSize*1.2
                    }
                    let  backgroundalpha :CGFloat = CGFloat((item["content_background_alpha"] as! NSString).floatValue)
                    let  textalpha :CGFloat = CGFloat((item["content_text_color_alpha"] as! NSString).floatValue)
                    var buttonType = NSString()
                    if( item["content_type"] as! String == "TEXT"){
                        let text = item["content"] as! String
                        DispatchQueue.main.async{
                            
                            let textLabel = UILabel()
                            textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            textLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            textLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            if(contentMode == "right"){
                                textLabel.textAlignment=NSTextAlignment.right
                            }
                            else if(contentMode == "left"){
                                textLabel.textAlignment=NSTextAlignment.left
                            }
                            else{
                                textLabel.textAlignment=NSTextAlignment.center
                            }
                            textLabel.numberOfLines = 0
                            textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                            textLabel.text = text
                            textLabel.layer.zPosition = overlay_z_max
                            if (xScale == 1.0 && yScale == 1.0 ){
                                let oldFrame : CGRect = textLabel.frame
                                textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                textLabel.frame = oldFrame
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            self.tangoPlayer?.displayView.contentOverlay.addSubview(textLabel)
                            
                            textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                textLabel.transform = CGAffineTransform.identity
                                //UIView.animate(withDuration: 0.25, animations: {
                                textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
                                //})
                            }
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            textLabel.isUserInteractionEnabled = true
                            textLabel.addGestureRecognizer(tapGestureOnActionLabel)
                             print("Third")
                        }
                    }
                    if (item["content_type"] as! String == "IMAGE"){
                        DispatchQueue.main.async{
                            let userImageBg = UIImageView()
                            userImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            userImageBg.clipsToBounds=true
                            userImageBg.tag = startValue
                            userImageBg.imageFromServerURL(urlString: item["content"] as! String)
                            userImageBg.layer.zPosition = overlay_z_max
                            userImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            userImageBg.contentMode=UIViewContentMode.scaleAspectFit //scaleAspectFill
                            player.displayView.contentOverlay.addSubview(userImageBg)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                userImageBg.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.25, animations: {
                                    userImageBg.transform = userImageBg.transform.scaledBy(x: xScale, y:yScale)
                                })
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                userImageBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            userImageBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            userImageBg.isUserInteractionEnabled = true
                            userImageBg.addGestureRecognizer(tapGestureOnActionLabel)
                        }
                    }
                    if (item["content_type"] as! String == "WEB"){
                        DispatchQueue.main.async{
                            let webView    = UIWebView()
                            webView.frame = CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            webView.isOpaque = false
                            webView.delegate = self
                            webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            webView.layer.zPosition = overlay_z_max
                            player.displayView.contentOverlay.addSubview(webView)
                            let url = URL(string: item["content"] as! String)
                            let request = URLRequest(url: url!)
                            webView.scalesPageToFit = true
                            webView.contentMode = UIViewContentMode.scaleAspectFit
                            webView.isMultipleTouchEnabled = false
                            webView.isUserInteractionEnabled = true;
                            webView.loadRequest(request)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                webView.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.25, animations: {
                                    webView.transform = webView.transform.scaledBy(x: xScale, y:yScale)
                                })
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                webView.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            /*let webViewConfiguration = WKWebViewConfiguration()
                             let webView = WKWebView(frame: CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height), configuration: webViewConfiguration)
                             webView.translatesAutoresizingMaskIntoConstraints = false
                             webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                             let url = URL(string: item["content"] as! String)
                             let request = URLRequest(url: url!)
                             webView.load(request)
                             player.displayView.contentOverlay.addSubview(webView)*/
                            
                            webView.tag = Int((item["overlay_id"] as! NSString).intValue)
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            webView.isUserInteractionEnabled = true
                            webView.addGestureRecognizer(tapGestureOnActionLabel)
                            webView.scrollView.addGestureRecognizer(tapGestureOnActionLabel)
                            webView.gestureRecognizerShouldBegin(tapGestureOnActionLabel)
                        }
                    }
                    if (item["content_type"] as! String == "QUIZ"){
                        DispatchQueue.main.async{
                            let quizBg = UIView()
                            quizBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            quizBg.clipsToBounds=true
                            quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            quizBg.layer.zPosition = overlay_z_max
                            player.displayView.contentOverlay.addSubview(quizBg)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                quizBg.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.25, animations: {
                                    quizBg.transform = quizBg.transform.scaledBy(x: xScale, y:yScale)
                                })
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                quizBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            quizBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            quizBg.isUserInteractionEnabled = true
                            quizBg.addGestureRecognizer(tapGestureOnActionLabel)
                            
                            let questionString = item["content"] as! String
                            let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
                            
                            let questionLabel = UILabel()
                            questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
                            questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            questionLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                            questionLabel.backgroundColor=UIColor.clear
                            if(parsedQuestion != nil){
                                questionLabel.text = parsedQuestion
                            }
                            questionLabel.textAlignment = NSTextAlignment.center
                            questionLabel.numberOfLines = 0
                            questionLabel.adjustsFontSizeToFitWidth = true
                            quizBg.addSubview(questionLabel)
                            
                            let parsedFirstAnswer = questionString.slice(from: "$_A1_$", to: "$_A1_$")
                            let answer1Btn = UIButton()
                            answer1Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y:  (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedFirstAnswer != nil){
                                answer1Btn.setTitle( parsedFirstAnswer, for: UIControlState.normal)
                            }
                            answer1Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                            answer1Btn.backgroundColor=UIColor.clear
                            answer1Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer1Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer1Btn.layer.cornerRadius = 6.0
                            answer1Btn.accessibilityLabel = "1"
                            answer1Btn.layer.borderWidth = 1.0
                            answer1Btn.layer.borderColor = UIColor.black.cgColor
                            answer1Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            answer1Btn.titleLabel?.adjustsFontSizeToFitWidth = true
                            quizBg.addSubview(answer1Btn)
                            
                            var xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                            let parsedSecondAnswer = questionString.slice(from: "$_A2_$", to: "$_A2_$")
                            let answer2Btn = UIButton()
                            answer2Btn.frame = CGRect(x:xaxies, y: (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedSecondAnswer != nil){
                                answer2Btn.setTitle( parsedSecondAnswer, for: UIControlState.normal)
                            }
                            answer2Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                            answer2Btn.backgroundColor=UIColor.clear
                            answer2Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer2Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer2Btn.layer.cornerRadius = 6.0
                            answer2Btn.accessibilityLabel = "2"
                            answer2Btn.layer.borderWidth = 1.0
                            answer2Btn.layer.borderColor = UIColor.black.cgColor
                            answer2Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            answer2Btn.titleLabel?.adjustsFontSizeToFitWidth = true
                            quizBg.addSubview(answer2Btn)
                            
                            let parsedThirdAnswer = questionString.slice(from: "$_A3_$", to: "$_A3_$")
                            let answer3Btn = UIButton()
                            answer3Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedThirdAnswer != nil){
                                answer3Btn.setTitle( parsedThirdAnswer, for: UIControlState.normal)
                            }
                            answer3Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                            answer3Btn.backgroundColor=UIColor.clear
                            answer3Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer3Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer3Btn.accessibilityLabel = "3"
                            answer3Btn.layer.cornerRadius = 6.0
                            answer3Btn.layer.borderWidth = 1.0
                            answer3Btn.layer.borderColor = UIColor.black.cgColor
                            answer3Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            answer3Btn.titleLabel?.adjustsFontSizeToFitWidth = true
                            quizBg.addSubview(answer3Btn)
                            
                            xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                            let parsedFourthAnswer = questionString.slice(from: "$_A4_$", to: "$_A4_$")
                            let answer4Btn = UIButton()
                            answer4Btn.frame = CGRect(x:xaxies, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedFourthAnswer != nil){
                                answer4Btn.setTitle( parsedFourthAnswer, for: UIControlState.normal)
                            }
                            answer4Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                            answer4Btn.backgroundColor=UIColor.clear
                            answer4Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer4Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer4Btn.accessibilityLabel = "4"
                            answer4Btn.layer.cornerRadius = 6.0
                            answer4Btn.layer.borderWidth = 1.0
                            answer4Btn.layer.borderColor = UIColor.black.cgColor
                            answer4Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            answer4Btn.titleLabel?.adjustsFontSizeToFitWidth = true
                            quizBg.addSubview(answer4Btn)
                        }
                    }
                    
                    let actionValue = item["action"] as! String
                    var sepratedValues = actionValue.components(separatedBy: "://")
                    print("sepratedValues %@",sepratedValues);
                    if(sepratedValues.count>0){
                        if (sepratedValues[0] == "weblink") {
                            buttonType = "ACTION_WEBLINK"
                        }
                        if (sepratedValues[0] == "twitter") {
                            buttonType = "ACTION_TWITTER"
                        }
                        if (sepratedValues[0] == "sms") {
                            buttonType = "ACTION_SMS"
                        }
                        if (sepratedValues[0] == "tel") {
                            buttonType = "ACTION_CALL"
                        }
                        if (sepratedValues[0] == "email") {
                            buttonType = "ACTION_EMAIL"
                        }
                        if (sepratedValues[0] == "video") {
                            buttonType = "ACTION_VIDEO"
                        }
                        if (sepratedValues[0] == "skip") {
                            buttonType = "ACTION_SKIP"
                        }
                    if(contentInfo != nil){
                    let parameters = [
                        "program_id" : contentInfo.content_id,
                        "program_name" : contentInfo.content_name,
                        "overlay_id":  item["overlay_id"] as! String,
                        "overlay_tag": item["overlay_id"] as! String,
                        "button_type" : buttonType,
                        "button_data" : item["action"] as! String
                        ] as [String : Any]
                    print("SHOWN_INTERACTIVE_OVERLAY %@",parameters)
                    TeletangoPlayer.logEvent(oftype:SHOWN_INTERACTIVE_OVERLAY,params:parameters as ([String : AnyObject]),completion:{(result: ([String:AnyObject])) in
                    })
                    }
                    }
                }
            }
            
            var subViews: [UIView] = (player.displayView.contentOverlay.subviews)
            for k in 0..<subViews.count {
                let views = subViews[k]
                let overlaytag = views.tag
                let existingPredicate = NSPredicate(format: "overlay_id == %@",String(format:"%d",overlaytag))
                let removalArray = adsArray.filter { existingPredicate.evaluate(with: $0) } as! NSArray
                //print("removalArray List %@",removalArray)
                if(removalArray.count>0){
                    //print("Existing Tag Value %@",removalArray)
                }
                else{
                    print("Remove Tag Value %@",overlaytag)
                    let viewWithTag = views.viewWithTag(overlaytag)
                    UIView.animate(withDuration: 1, animations: {
                        viewWithTag?.alpha = 0
                    }) { _ in
                        viewWithTag?.removeFromSuperview()
                    }
                }
            }
        }
        else{
            let subViews: [UIView] = (player.displayView.contentOverlay.subviews)
            for subview in subViews{
                UIView.animate(withDuration: 1, animations: {
                    subview.alpha = 0
                }) { _ in
                    subview.removeFromSuperview()
                }
            }
        }
    }
    }
    //MARK:*************** Webview Delgates **********************
    public func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        let scrollheight = CGFloat(Float(webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight")!) ?? 0.0)
        webView.scalesPageToFit = true
        webView.contentMode = UIViewContentMode.scaleAspectFit
    }
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("WebvIew Error \(error.localizedDescription)")
    }
    public func gestureRecognizer(_: UIGestureRecognizer,  shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool{
        return true
    }
    public func gestureRecognizer(_: UIGestureRecognizer, shouldReceive:UITouch) -> Bool {
        return true
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x:view.bounds.size.width * view.layer.anchorPoint.x, y:view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    public func tangoPlayerViewOrientationChnaged(_ playerView: TangoPlayerView, willFullscreen isFullscreen: Bool){
         delegate?.orientationChnaged(isFullscreen)
    }
    public func tangoPlayerdidReachedToend(_ player: TangoPlayer){
        print("tangoPlayerdidReachedToend")
        skipBtnTimer.invalidate()
        if(skipBtn != nil){
        skipBtn.removeFromSuperview()
        }
        videoOverLayTimer.invalidate()
        /*UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.playerViewController.view.frame = CGRect(x:0, y:0, width:self.frame.size.width, height: self.playerView.frame.size.height)
        }, completion: { (finished: Bool) in
        })*/
        overlaySubView.removeFromSuperview()
        fullScreenOverlay.removeFromSuperview()
         print("mainPlayerTime %d",mainPlayerTime)
        if (isFromAd == true){
            if recentAdArray.count > 0 {
                // let dTotalSeconds :Double = CMTimeGetSeconds(queuePlayer!.currentItem?.asset.duration)
                let item = recentAdArray[0] as! NSDictionary
                let dCurrentSeconds : Int = Int(player.currentDuration)
                videoEventsparams = [
                    "ad_id" : item["id"],
                    "video_url" : item["recorded_video"],
                    "skipped" : "false",
                    "skipped_at" : dCurrentSeconds
                ]
                TTPWebserviceHelper().postAddevents(OVERLAY_VIDEOADS, withparameters: videoEventsparams as! [AnyHashable : Any])
            }
            if(contentInfo != nil){
            let videoURL = URL(string: contentInfo.content_url)
            if videoURL != nil {
                tangoPlayer?.replaceVideo(videoURL!)
                tangoPlayer?.displayView.isAds = false
                let timeToAdd: CMTime = CMTimeMakeWithSeconds(1, 1)
                let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds(mainPlayerTime, 1000000), timeToAdd)
                //queuePlayer.seek(to: resultTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                tangoPlayer?.playerItem?.seek(to: resultTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                tangoPlayer?.play()
            }
            isFromAd = false
            recentAdArray.removeAllObjects()
            adTimer.invalidate()
            adTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForAdWithTimer), userInfo: nil, repeats: true)
            }
        }
        videoOverLayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(videoOverLayAdTimer), userInfo: nil, repeats: true)
    }
    public func tangoPlayerView(_ playerView: TangoPlayerView, willFullscreen fullscreen: Bool,videoBoundsRect:CGRect,playercurrentTime: Int) {
        print("screen State ")
        //let  adsArray = sqLiteManager().find(nil, from: "IVPData", where: String(format:"(%d BETWEEN attr_start_time AND attr_end_time)",playercurrentTime))! as NSArray
        let dataSource = UserDefaults.standard.array(forKey: "personlizationArray")
        if(dataSource != nil && dataSource!.count>0){
        let predicate = NSPredicate(format: "%d >= attr_start_time AND %d <= attr_end_time", playercurrentTime,playercurrentTime)
        let adsArray = dataSource?.filter { predicate.evaluate(with: $0) } as! NSArray
        //print("adsArray %@ at time %@",adsArray,playercurrentTime);
        if (adsArray != nil){
            if(adsArray.count == 0){
                let subViews: [UIView] = (tangoPlayer?.displayView.contentOverlay.subviews)!
                for subview in subViews{
                    UIView.animate(withDuration: 1, animations: {
                        subview.alpha = 0
                    }) { _ in
                        subview.removeFromSuperview()
                    }
                }
            }
            for j in 0..<adsArray.count {
                let item = adsArray[j] as! NSDictionary
                let subViews: [UIView] = (tangoPlayer?.displayView.contentOverlay.subviews)!
                if(subViews.count>0){
                    let tag =  Int((item["overlay_id"] as! NSString).intValue)
                    if (tangoPlayer?.displayView.contentOverlay.viewWithTag(tag) != nil) {
                        print("Inside first One")
                        //let  startValue :Int = Int((item["attr_start_time"] as! NSString).intValue)
                        //let  endValue :Int = Int((item["attr_end_time"] as! NSString).intValue)
                        let  startValue :Int = Int(item["attr_start_time"] as! Int)
                        let  overlay_x_min : CGFloat = CGFloat((item["anim_x_min"] as! NSString).floatValue)
                        let  overlay_y_min : CGFloat = CGFloat((item["anim_y_min"] as! NSString).floatValue)
                        let  overlay_x_max : CGFloat = CGFloat((item["anim_x_max"] as! NSString).floatValue)
                        let  overlay_y_max : CGFloat = CGFloat((item["anim_y_max"] as! NSString).floatValue)
                        let  overlay_z_max : CGFloat = CGFloat((item["anim_z_pos"] as! NSString).floatValue)
                        
                        let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                        let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                        let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                        
                        let xMinValue :CGFloat = (overlay_x_min * ((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-videoBoundsRect.size.width))) / 100
                        let xMaxValue :CGFloat = (overlay_x_max * ((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-videoBoundsRect.size.width))) / 100
                        
                        let yMinValue :CGFloat = (overlay_y_min * ((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-videoBoundsRect.size.height))) / 100
                        let yMaxValue :CGFloat = (overlay_y_max * ((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-videoBoundsRect.size.height))) / 100
                        
                        let p1 = CGPoint(x: videoBoundsRect.origin.x + xMinValue, y: videoBoundsRect.origin.y + yMinValue)
                        let p2 = CGPoint(x: videoBoundsRect.origin.x + xMaxValue, y: videoBoundsRect.origin.y  + yMaxValue)
                        
                        let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                        
                        let xradians = xdegrees * .pi / 180
                        let yradians = ydegrees * .pi / 180
                        let zradians = zdegrees * .pi / 180
                         let  contentMode :NSString = item["content_text_gravity"] as! NSString
                        let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                        let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                        var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                        var  backgroundalpha :CGFloat = CGFloat((item["content_background_alpha"] as! NSString).floatValue)
                        if(UIDevice.current.userInterfaceIdiom == .pad){
                            fontSize = 1.5*fontSize
                        }
                        if(tangoPlayer?.displayView.isFullScreen == true){
                            fontSize = fontSize*1.2
                        }
                        let  textalpha :CGFloat = CGFloat((item["content_text_color_alpha"] as! NSString).floatValue)
                        let viewWithTag = tangoPlayer?.displayView.contentOverlay.viewWithTag(tag)
                        if(viewWithTag?.isKind(of: UILabel.self))!{
                            let subLabel:UILabel =  tangoPlayer?.displayView.contentOverlay.viewWithTag(tag) as! UILabel
                            let text = item["content"] as! String
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                subLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            /*UIView.animate(withDuration: 0.5, animations: {
                             subLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             })*/
                            subLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            subLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            if(contentMode == "right"){
                                subLabel.textAlignment=NSTextAlignment.right
                            }
                            else if(contentMode == "left"){
                                subLabel.textAlignment=NSTextAlignment.left
                            }
                            else{
                                subLabel.textAlignment=NSTextAlignment.center
                            }
                            subLabel.numberOfLines = 0
                            subLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                            subLabel.text = text
                            subLabel.tag = startValue
                            subLabel.layer.zPosition = overlay_z_max
                            if (xScale == 1.0 && yScale == 1.0 ){
                                //let oldFrame : CGRect = subLabel.frame
                                //subLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                //subLabel.frame = oldFrame
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    subLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            subLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                subLabel.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    subLabel.transform = subLabel.transform.scaledBy(x: xScale, y:yScale)
                                }, completion: nil )
                            }
                        }
                        if(viewWithTag?.isKind(of: UIImageView.self))!{
                            let overlayImageBg:UIImageView =  tangoPlayer?.displayView.contentOverlay.viewWithTag(tag) as! UIImageView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                overlayImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            /*UIView.animate(withDuration: 0.5, animations: {
                             overlayImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             })*/
                            overlayImageBg.clipsToBounds=true
                            overlayImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            overlayImageBg.imageFromServerURL(urlString: item["content"] as! String)
                            overlayImageBg.layer.zPosition = overlay_z_max
                            overlayImageBg.contentMode=UIViewContentMode.scaleAspectFit //scaleAspectFill
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                overlayImageBg.transform = CGAffineTransform.identity
                                //UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                overlayImageBg.transform = overlayImageBg.transform.scaledBy(x: xScale, y:yScale)
                                //}, completion: nil )
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    overlayImageBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            overlayImageBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                        }
                        if(viewWithTag?.isKind(of: UIWebView.self))!{
                            
                            let webView:UIWebView =  tangoPlayer?.displayView.contentOverlay.viewWithTag(tag) as! UIWebView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                webView.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            webView.isOpaque = false
                            webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            webView.layer.zPosition = overlay_z_max
                            webView.scalesPageToFit = true
                            webView.contentMode = UIViewContentMode.scaleAspectFit
                            webView.isUserInteractionEnabled = true;
                            //webView.loadRequest(request)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                webView.transform = CGAffineTransform.identity
                                webView.transform = webView.transform.scaledBy(x: xScale, y:yScale)
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    webView.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            /*if let recognizers = webView.gestureRecognizers {
                                for recognizer in recognizers {
                                    webView.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                                }
                            }*/
                            
                            /*let webView:WKWebView =  player.displayView.contentOverlay.viewWithTag(tag) as! WKWebView
                             UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                             webView.frame = CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             }, completion: nil )
                             webView.translatesAutoresizingMaskIntoConstraints = false
                             webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                             let url = URL(string: item["content"] as! String)
                             let request = URLRequest(url: url!)
                             webView.isMultipleTouchEnabled = false
                             webView.load(request)*/
                            
                            webView.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            /*let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            webView.isUserInteractionEnabled = true
                            webView.addGestureRecognizer(tapGestureOnActionLabel)*/
                        }
                        if(viewWithTag?.isKind(of: UIView.self))!{
                            
                            let quizBg:UIView =  tangoPlayer?.displayView.contentOverlay.viewWithTag(tag) as! UIView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                quizBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                             quizBg.layer.zPosition = overlay_z_max
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                quizBg.transform = CGAffineTransform.identity
                                quizBg.transform = quizBg.transform.scaledBy(x: xScale, y:yScale)
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    quizBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            quizBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            /*let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            quizBg.isUserInteractionEnabled = true
                            quizBg.addGestureRecognizer(tapGestureOnActionLabel)*/
                        }
                    }
                    else{
                        print("Inside Second One")
                        print("Inside Not Equal toooooooo at %@ with array count %@ of tg %@",playercurrentTime,adsArray.count,tag)
                        //let viewWithTag = player.displayView.contentOverlay.viewWithTag(tag)
                        //viewWithTag?.removeFromSuperview()
                        //let  startValue :Int = Int((item["attr_start_time"] as! NSString).intValue)
                        //let  endValue :Int = Int((item["attr_end_time"] as! NSString).intValue)
                        let  startValue :Int = Int(item["attr_start_time"] as! Int)
                        let  overlay_x_min : CGFloat = CGFloat((item["anim_x_min"] as! NSString).floatValue)
                        let  overlay_y_min : CGFloat = CGFloat((item["anim_y_min"] as! NSString).floatValue)
                        let  overlay_x_max : CGFloat = CGFloat((item["anim_x_max"] as! NSString).floatValue)
                        let  overlay_y_max : CGFloat = CGFloat((item["anim_y_max"] as! NSString).floatValue)
                        let  overlay_z_max : CGFloat = CGFloat((item["anim_z_pos"] as! NSString).floatValue)
                        
                        let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                        let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                        let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                        
                        let xMinValue :CGFloat = (overlay_x_min * ((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-videoBoundsRect.size.width))) / 100
                        let xMaxValue :CGFloat = (overlay_x_max * ((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-videoBoundsRect.size.width))) / 100
                        
                        let yMinValue :CGFloat = (overlay_y_min * ((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-videoBoundsRect.size.height))) / 100
                        let yMaxValue :CGFloat = (overlay_y_max * ((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-videoBoundsRect.size.height))) / 100
                        
                        let p1 = CGPoint(x: videoBoundsRect.origin.x + xMinValue, y: videoBoundsRect.origin.y + yMinValue)
                        let p2 = CGPoint(x: videoBoundsRect.origin.x + xMaxValue, y: videoBoundsRect.origin.y  + yMaxValue)
                        
                        let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                        
                        let xradians = xdegrees * .pi / 180
                        let yradians = ydegrees * .pi / 180
                        let zradians = zdegrees * .pi / 180
                         let  contentMode :NSString = item["content_text_gravity"] as! NSString
                        let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                        let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                        var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                        if(UIDevice.current.userInterfaceIdiom == .pad){
                            fontSize = 1.5*fontSize
                        }
                        if(tangoPlayer?.displayView.isFullScreen == true){
                            fontSize = fontSize*1.2
                        }
                        let  backgroundalpha :CGFloat = CGFloat((item["content_background_alpha"] as! NSString).floatValue)
                        let  textalpha :CGFloat = CGFloat((item["content_text_color_alpha"] as! NSString).floatValue)
                        
                        if( item["content_type"] as! String == "TEXT"){
                            let text = item["content"] as! String
                            DispatchQueue.main.async{
                                
                                let textLabel = UILabel()
                                textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                textLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                textLabel.font = UIFont(name: "Helvetica", size: fontSize)
                                if(contentMode == "right"){
                                    textLabel.textAlignment=NSTextAlignment.right
                                }
                                else if(contentMode == "left"){
                                    textLabel.textAlignment=NSTextAlignment.left
                                }
                                else{
                                    textLabel.textAlignment=NSTextAlignment.center
                                }
                                textLabel.numberOfLines = 0
                                textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                                textLabel.text = text
                                textLabel.layer.zPosition = overlay_z_max
                                if (xScale == 1.0 && yScale == 1.0 ){
                                    let oldFrame : CGRect = textLabel.frame
                                    textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                    textLabel.frame = oldFrame
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                self.tangoPlayer?.displayView.contentOverlay.addSubview(textLabel)
                                
                                textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    textLabel.transform = CGAffineTransform.identity
                                    //UIView.animate(withDuration: 0.25, animations: {
                                    textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
                                    //})
                                }
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                textLabel.isUserInteractionEnabled = true
                                textLabel.addGestureRecognizer(tapGestureOnActionLabel)
                            }
                        }
                        if (item["content_type"] as! String == "IMAGE"){
                            DispatchQueue.main.async{
                                let userImageBg = UIImageView()
                                userImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                userImageBg.clipsToBounds=true
                                userImageBg.tag = startValue
                                userImageBg.imageFromServerURL(urlString: item["content"] as! String)
                                //userImageBg.image = self.selectedImage
                                userImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                userImageBg.layer.zPosition = overlay_z_max
                                userImageBg.contentMode=UIViewContentMode.scaleAspectFit//scaleAspectFill
                                self.tangoPlayer?.displayView.contentOverlay.addSubview(userImageBg)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    userImageBg.transform = CGAffineTransform.identity
                                    UIView.animate(withDuration: 0.25, animations: {
                                        userImageBg.transform = userImageBg.transform.scaledBy(x: xScale, y:yScale)
                                    })
                                }
                                if (xScale == 1 && yScale == 1 ){
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    userImageBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                userImageBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                userImageBg.isUserInteractionEnabled = true
                                userImageBg.addGestureRecognizer(tapGestureOnActionLabel)
                            }
                        }
                        if (item["content_type"] as! String == "WEB"){
                            DispatchQueue.main.async{
                                let webView    = UIWebView()
                                webView.frame = CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                webView.isOpaque = false
                                webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                self.tangoPlayer?.displayView.contentOverlay.addSubview(webView)
                                let url = URL(string: item["content"] as! String)
                                let request = URLRequest(url: url!)
                                webView.scalesPageToFit = true
                                webView.contentMode = UIViewContentMode.scaleAspectFit
                                webView.isUserInteractionEnabled = true;
                                 webView.layer.zPosition = overlay_z_max
                                webView.loadRequest(request)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    webView.transform = CGAffineTransform.identity
                                    UIView.animate(withDuration: 0.25, animations: {
                                        webView.transform = webView.transform.scaledBy(x: xScale, y:yScale)
                                    })
                                }
                                if (xScale == 1 && yScale == 1 ){
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    webView.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                /*let webViewConfiguration = WKWebViewConfiguration()
                                 let webView = WKWebView(frame: CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height), configuration: webViewConfiguration)
                                 webView.translatesAutoresizingMaskIntoConstraints = false
                                 webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                                 let url = URL(string: item["content"] as! String)
                                 let request = URLRequest(url: url!)
                                 webView.load(request)
                                 self.player!.displayView.contentOverlay.addSubview(webView)*/
                                
                                webView.tag =  Int((item["overlay_id"] as! NSString).intValue)
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                webView.isUserInteractionEnabled = true
                                webView.addGestureRecognizer(tapGestureOnActionLabel)
                                webView.scrollView.addGestureRecognizer(tapGestureOnActionLabel)
                                webView.gestureRecognizerShouldBegin(tapGestureOnActionLabel)
                            }
                        }
                        if (item["content_type"] as! String == "QUIZ"){
                            DispatchQueue.main.async{
                                let quizBg = UIView()
                                quizBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                quizBg.clipsToBounds=true
                                quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                                quizBg.layer.zPosition = overlay_z_max
                                self.tangoPlayer?.displayView.contentOverlay.addSubview(quizBg)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    quizBg.transform = CGAffineTransform.identity
                                    UIView.animate(withDuration: 0.25, animations: {
                                        quizBg.transform = quizBg.transform.scaledBy(x: xScale, y:yScale)
                                    })
                                }
                                if (xScale == 1 && yScale == 1 ){
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    quizBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                quizBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                quizBg.isUserInteractionEnabled = true
                                quizBg.addGestureRecognizer(tapGestureOnActionLabel)
                                
                                let questionString = item["content"] as! String
                                let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
                                
                                let questionLabel = UILabel()
                                questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
                                questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
                                questionLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                                questionLabel.backgroundColor=UIColor.clear
                                if(parsedQuestion != nil){
                                    questionLabel.text = parsedQuestion
                                }
                                questionLabel.textAlignment = NSTextAlignment.center
                                questionLabel.numberOfLines = 0
                                questionLabel.adjustsFontSizeToFitWidth = true
                                quizBg.addSubview(questionLabel)
                                
                                let parsedFirstAnswer = questionString.slice(from: "$_A1_$", to: "$_A1_$")
                                let answer1Btn = UIButton()
                                answer1Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y:  (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedFirstAnswer != nil){
                                    answer1Btn.setTitle( parsedFirstAnswer, for: UIControlState.normal)
                                }
                                answer1Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer1Btn.backgroundColor=UIColor.clear
                                answer1Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer1Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer1Btn.layer.cornerRadius = 6.0
                                answer1Btn.layer.borderWidth = 1.0
                                answer1Btn.accessibilityLabel = "1"
                                answer1Btn.layer.borderColor = UIColor.black.cgColor
                                answer1Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer1Btn)
                                
                                var xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                                let parsedSecondAnswer = questionString.slice(from: "$_A2_$", to: "$_A2_$")
                                let answer2Btn = UIButton()
                                answer2Btn.frame = CGRect(x:xaxies, y: (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedSecondAnswer != nil){
                                    answer2Btn.setTitle( parsedSecondAnswer, for: UIControlState.normal)
                                }
                                answer2Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer2Btn.backgroundColor=UIColor.clear
                                answer2Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer2Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer2Btn.layer.cornerRadius = 6.0
                                answer2Btn.layer.borderWidth = 1.0
                                answer2Btn.accessibilityLabel = "2"
                                answer2Btn.layer.borderColor = UIColor.black.cgColor
                                answer2Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer2Btn)
                                
                                let parsedThirdAnswer = questionString.slice(from: "$_A3_$", to: "$_A3_$")
                                let answer3Btn = UIButton()
                                answer3Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedThirdAnswer != nil){
                                    answer3Btn.setTitle( parsedThirdAnswer, for: UIControlState.normal)
                                }
                                answer3Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer3Btn.backgroundColor=UIColor.clear
                                answer3Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer3Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer3Btn.layer.cornerRadius = 6.0
                                answer3Btn.accessibilityLabel = "3"
                                answer3Btn.layer.borderWidth = 1.0
                                answer3Btn.layer.borderColor = UIColor.black.cgColor
                                answer3Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer3Btn)
                                
                                xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                                let parsedFourthAnswer = questionString.slice(from: "$_A4_$", to: "$_A4_$")
                                let answer4Btn = UIButton()
                                answer4Btn.frame = CGRect(x:xaxies, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                                if(parsedFourthAnswer != nil){
                                    answer4Btn.setTitle( parsedFourthAnswer, for: UIControlState.normal)
                                }
                                answer4Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha), for: UIControlState.normal)
                                answer4Btn.backgroundColor=UIColor.clear
                                answer4Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                                answer4Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                                answer4Btn.layer.cornerRadius = 6.0
                                answer4Btn.accessibilityLabel = "4"
                                answer4Btn.layer.borderWidth = 1.0
                                answer4Btn.layer.borderColor = UIColor.black.cgColor
                                answer4Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                                quizBg.addSubview(answer4Btn)
                            }
                        }
                        /* else{
                         let viewWithTag = views.viewWithTag(tag)
                         UIView.animate(withDuration: 1.0, animations: {
                         viewWithTag?.alpha = 0
                         }) { _ in
                         viewWithTag?.removeFromSuperview()
                         }
                         }*/
                    }
                }
                else{
                    let  startValue :Int = Int(item["attr_start_time"] as! Int)
                    let  endValue :Int = Int(item["attr_end_time"] as! Int)
                    let  overlay_x_min : CGFloat = CGFloat((item["anim_x_min"] as! NSString).floatValue)
                    let  overlay_y_min : CGFloat = CGFloat((item["anim_y_min"] as! NSString).floatValue)
                    let  overlay_x_max : CGFloat = CGFloat((item["anim_x_max"] as! NSString).floatValue)
                    let  overlay_y_max : CGFloat = CGFloat((item["anim_y_max"] as! NSString).floatValue)
                    let  overlay_z_max : CGFloat = CGFloat((item["anim_z_pos"] as! NSString).floatValue)
                    
                    let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                    let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                    let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                    
                    let xMinValue :CGFloat = (overlay_x_min * ((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-videoBoundsRect.size.width))) / 100
                    let xMaxValue :CGFloat = (overlay_x_max * ((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-((tangoPlayer?.displayView.contentOverlay.frame.size.width)!-videoBoundsRect.size.width))) / 100
                    
                    let yMinValue :CGFloat = (overlay_y_min * ((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-videoBoundsRect.size.height))) / 100
                    let yMaxValue :CGFloat = (overlay_y_max * ((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-((tangoPlayer?.displayView.contentOverlay.frame.size.height)!-videoBoundsRect.size.height))) / 100
                    
                    let p1 = CGPoint(x: videoBoundsRect.origin.x + xMinValue, y: videoBoundsRect.origin.y + yMinValue)
                    let p2 = CGPoint(x: videoBoundsRect.origin.x + xMaxValue, y: videoBoundsRect.origin.y  + yMaxValue)
                    
                    let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                    
                    let xradians = xdegrees * .pi / 180
                    let yradians = ydegrees * .pi / 180
                    let zradians = zdegrees * .pi / 180
                     let  contentMode :NSString = item["content_text_gravity"] as! NSString
                    let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                    let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                    var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                    if(UIDevice.current.userInterfaceIdiom == .pad){
                        fontSize = 1.5*fontSize
                    }
                    if(tangoPlayer?.displayView.isFullScreen == true){
                        fontSize = fontSize*1.2
                    }
                    let  backgroundalpha :CGFloat = CGFloat((item["content_background_alpha"] as! NSString).floatValue)
                    let  textalpha :CGFloat = CGFloat((item["content_text_color_alpha"] as! NSString).floatValue)
                    
                    if( item["content_type"] as! String == "TEXT"){
                        let text = item["content"] as! String
                        DispatchQueue.main.async{
                            
                            let textLabel = UILabel()
                            textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            textLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            textLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            if(contentMode == "right"){
                                textLabel.textAlignment=NSTextAlignment.right
                            }
                            else if(contentMode == "left"){
                                textLabel.textAlignment=NSTextAlignment.left
                            }
                            else{
                                textLabel.textAlignment=NSTextAlignment.center
                            }
                            textLabel.numberOfLines = 0
                            textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                            textLabel.text = text
                            textLabel.layer.zPosition = overlay_z_max
                            if (xScale == 1.0 && yScale == 1.0 ){
                                let oldFrame : CGRect = textLabel.frame
                                textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                textLabel.frame = oldFrame
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            self.tangoPlayer?.displayView.contentOverlay.addSubview(textLabel)
                            
                            textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                textLabel.transform = CGAffineTransform.identity
                                //UIView.animate(withDuration: 0.25, animations: {
                                textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
                                //})
                            }
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            textLabel.isUserInteractionEnabled = true
                            textLabel.addGestureRecognizer(tapGestureOnActionLabel)
                        }
                    }
                    if (item["content_type"] as! String == "IMAGE"){
                        DispatchQueue.main.async{
                            let userImageBg = UIImageView()
                            userImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            userImageBg.clipsToBounds=true
                            userImageBg.tag = startValue
                            userImageBg.imageFromServerURL(urlString: item["content"] as! String)
                            //userImageBg.image = self.selectedImage
                            userImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                            userImageBg.layer.zPosition = overlay_z_max
                            userImageBg.contentMode=UIViewContentMode.scaleAspectFit//scaleAspectFill
                            self.tangoPlayer?.displayView.contentOverlay.addSubview(userImageBg)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                userImageBg.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.25, animations: {
                                    userImageBg.transform = userImageBg.transform.scaledBy(x: xScale, y:yScale)
                                })
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                userImageBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            userImageBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            userImageBg.isUserInteractionEnabled = true
                            userImageBg.addGestureRecognizer(tapGestureOnActionLabel)
                        }
                    }
                    if (item["content_type"] as! String == "WEB"){
                        DispatchQueue.main.async{
                            let webView    = UIWebView()
                            webView.frame = CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            webView.isOpaque = false
                            webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                             webView.layer.zPosition = overlay_z_max
                            self.tangoPlayer?.displayView.contentOverlay.addSubview(webView)
                            let url = URL(string: item["content"] as! String)
                            let request = URLRequest(url: url!)
                            webView.scalesPageToFit = true
                            webView.contentMode = UIViewContentMode.scaleAspectFit
                            webView.isUserInteractionEnabled = true;
                            webView.loadRequest(request)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                webView.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.25, animations: {
                                    webView.transform = webView.transform.scaledBy(x: xScale, y:yScale)
                                })
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                webView.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            /*let webViewConfiguration = WKWebViewConfiguration()
                             let webView = WKWebView(frame: CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height), configuration: webViewConfiguration)
                             webView.translatesAutoresizingMaskIntoConstraints = false
                             webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                             let url = URL(string: item["content"] as! String)
                             let request = URLRequest(url: url!)
                             webView.load(request)
                             self.player!.displayView.contentOverlay.addSubview(webView)*/
                            
                            webView.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            webView.isUserInteractionEnabled = true
                            webView.addGestureRecognizer(tapGestureOnActionLabel)
                            webView.scrollView.addGestureRecognizer(tapGestureOnActionLabel)
                            webView.gestureRecognizerShouldBegin(tapGestureOnActionLabel)
                        }
                    }
                    if (item["content_type"] as! String == "QUIZ"){
                        DispatchQueue.main.async{
                            let quizBg = UIView()
                            quizBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            quizBg.clipsToBounds=true
                            quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_background_color"] as! String),alpha:backgroundalpha)
                             quizBg.layer.zPosition = overlay_z_max
                            self.tangoPlayer?.displayView.contentOverlay.addSubview(quizBg)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                quizBg.transform = CGAffineTransform.identity
                                UIView.animate(withDuration: 0.25, animations: {
                                    quizBg.transform = quizBg.transform.scaledBy(x: xScale, y:yScale)
                                })
                            }
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                quizBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            quizBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            quizBg.isUserInteractionEnabled = true
                            quizBg.addGestureRecognizer(tapGestureOnActionLabel)
                            
                            let questionString = item["content"] as! String
                            let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
                            
                            let questionLabel = UILabel()
                            questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
                            questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            questionLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_color"] as! String),alpha:textalpha)
                            questionLabel.backgroundColor=UIColor.clear
                            if(parsedQuestion != nil){
                                questionLabel.text = parsedQuestion
                            }
                            questionLabel.textAlignment = NSTextAlignment.center
                            questionLabel.numberOfLines = 0
                            questionLabel.adjustsFontSizeToFitWidth = true
                            quizBg.addSubview(questionLabel)
                            
                            let parsedFirstAnswer = questionString.slice(from: "$_A1_$", to: "$_A1_$")
                            let answer1Btn = UIButton()
                            answer1Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y:  (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedFirstAnswer != nil){
                                answer1Btn.setTitle( parsedFirstAnswer, for: UIControlState.normal)
                            }
                            answer1Btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                            answer1Btn.backgroundColor=UIColor.clear
                            answer1Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer1Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer1Btn.layer.cornerRadius = 6.0
                            answer1Btn.layer.borderWidth = 1.0
                            answer1Btn.accessibilityLabel = "1"
                            answer1Btn.layer.borderColor = UIColor.black.cgColor
                            answer1Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            quizBg.addSubview(answer1Btn)
                            
                            var xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                            let parsedSecondAnswer = questionString.slice(from: "$_A2_$", to: "$_A2_$")
                            let answer2Btn = UIButton()
                            answer2Btn.frame = CGRect(x:xaxies, y: (quizBg.frame.size.height/2)+2.5, width: quizBg.frame.size.width/2.5, height:  ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedSecondAnswer != nil){
                                answer2Btn.setTitle( parsedSecondAnswer, for: UIControlState.normal)
                            }
                            answer2Btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                            answer2Btn.backgroundColor=UIColor.clear
                            answer2Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer2Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer2Btn.layer.cornerRadius = 6.0
                            answer2Btn.layer.borderWidth = 1.0
                            answer2Btn.accessibilityLabel = "2"
                            answer2Btn.layer.borderColor = UIColor.black.cgColor
                            answer2Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            quizBg.addSubview(answer2Btn)
                            
                            let parsedThirdAnswer = questionString.slice(from: "$_A3_$", to: "$_A3_$")
                            let answer3Btn = UIButton()
                            answer3Btn.frame = CGRect(x:((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedThirdAnswer != nil){
                                answer3Btn.setTitle( parsedThirdAnswer, for: UIControlState.normal)
                            }
                            answer3Btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                            answer3Btn.backgroundColor=UIColor.clear
                            answer3Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer3Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer3Btn.layer.cornerRadius = 6.0
                            answer3Btn.layer.borderWidth = 1.0
                            answer3Btn.accessibilityLabel = "3"
                            answer3Btn.layer.borderColor = UIColor.black.cgColor
                            answer3Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            quizBg.addSubview(answer3Btn)
                            
                            xaxies = quizBg.frame.size.width/2+((quizBg.frame.size.width/2)-(quizBg.frame.size.width/2.5))/2
                            let parsedFourthAnswer = questionString.slice(from: "$_A4_$", to: "$_A4_$")
                            let answer4Btn = UIButton()
                            answer4Btn.frame = CGRect(x:xaxies, y: answer2Btn.frame.origin.y+answer2Btn.frame.size.height+2.5, width: quizBg.frame.size.width/2.5, height: ((quizBg.frame.size.height/2)/2)-5)
                            if(parsedFourthAnswer != nil){
                                answer4Btn.setTitle( parsedFourthAnswer, for: UIControlState.normal)
                            }
                            answer4Btn.setTitleColor(UIColor.black, for: UIControlState.normal)
                            answer4Btn.backgroundColor=UIColor.clear
                            answer4Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
                            answer4Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
                            answer4Btn.layer.cornerRadius = 6.0
                            answer4Btn.layer.borderWidth = 1.0
                            answer4Btn.accessibilityLabel = "4"
                            answer4Btn.layer.borderColor = UIColor.black.cgColor
                            answer4Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
                            quizBg.addSubview(answer4Btn)
                        }
                    }
                }
            }
            
            var subViews: [UIView] = (tangoPlayer?.displayView.contentOverlay.subviews)!
            for k in 0..<subViews.count {
                let views = subViews[k]
                let overlaytag = views.tag
                let existingPredicate = NSPredicate(format: "overlay_id == %@",String(format:"%d",overlaytag))
                let removalArray = adsArray.filter { existingPredicate.evaluate(with: $0) } as! NSArray
                //print("removalArray List %@",removalArray)
                if(removalArray.count>0){
                    //print("Existing Tag Value %@",removalArray)
                }
                else{
                    print("Remove Tag Value %@",overlaytag)
                    let viewWithTag = views.viewWithTag(overlaytag)
                    UIView.animate(withDuration: 1, animations: {
                        viewWithTag?.alpha = 0
                    }) { _ in
                        viewWithTag?.removeFromSuperview()
                    }
                }
            }
        }
        else{
            let subViews: [UIView] = (tangoPlayer?.displayView.contentOverlay.subviews)!
            for subview in subViews{
                UIView.animate(withDuration: 1, animations: {
                    subview.alpha = 0
                }) { _ in
                    subview.removeFromSuperview()
                }
            }
        }
    }
    }
    public func tangoPlayerView(didTappedClose playerView: TangoPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            //self.navigationController?.popViewController(animated: true)
        }
    }
    public func tangoPlayerView(didTouched playerView: TangoPlayerView, videoBoundsRect: CGRect,xPercentage:Float,yPercentage:Float,frameImage:UIImage,playercurrentTime:Int) {
        //print("xFPercentage %f",xPercentage)
        //print("yFPercentage %f",yPercentage)
        //print("playercurrentTime %d",playercurrentTime)
        delegate?.didTouchedOnthePlayer(xPercentage: xPercentage, yPercentage: yPercentage)
        //print("Jabong Array %@",UserDefaults.standard.value(forKey: "jabongarray"))
        var result = NSArray()
        //result = sqLiteManager().findAll(from: "AdsData")! as NSArray
        //result = sqLiteManager().find(nil, from: "IVPData", where: String(format:"(%f BETWEEN pos_x_min AND pos_x_max) AND (%f BETWEEN pos_y_min AND pos_y_max) AND (attr_start_time BETWEEN %d AND %d)",xPercentage,yPercentage,playercurrentTime-500,playercurrentTime+500))! as NSArray
        //print("Jabong Array %@",result)
        if(result.count>0){
            let item = result[0] as! NSDictionary
            if (item["action_type"] as! String == "ON_CLICK") {
                if(Int((item["pause_on_action"] as! NSString).intValue) == 1){
                    tangoPlayer?.pause()
                }
                let actionValue = item["action"] as! String
                var sepratedValues = actionValue.components(separatedBy: "://")
                print("sepratedValues %@",sepratedValues);
                if(sepratedValues.count>0){
                    if (sepratedValues[0] == "Weblink") {
                        let dict = [
                            "ad_id" : item["id"],
                            "cta_type" : "Weblink",
                            "responded" : "true"
                        ]
                        TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                        let combinedValues = actionValue.components(separatedBy: "Weblink:")
                        UIApplication.shared.openURL(URL(string: combinedValues[1] as String)!)
                    }
                    if (sepratedValues[0] == "sms") {
                        let dict = [
                            "ad_id" : item["id"],
                            "cta_type" : "sms",
                            "responded" : "true"
                        ]
                        TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                        
                        let innnerText = sepratedValues[1] as String
                        let combinedValues = innnerText.components(separatedBy:"/")
                        print("combinedValues %@",combinedValues);
                        if MFMessageComposeViewController.canSendText() == true {
                            let recipients:[String] = [combinedValues[0] as String]
                            let messageController = MFMessageComposeViewController()
                            messageController.messageComposeDelegate  = self
                            messageController.recipients = recipients
                            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                            let mainController: UIViewController? = keyWindow?.rootViewController
                            mainController?.present(messageController, animated: true, completion: nil)
                        } else {
                            //customAlert().show(title: kErrorTitle, message: "Can't compose messages !" , buttons: ["OK"], completion: nil)
                            let alertController:UIAlertController     = UIAlertController(title: "Errror", message:"Can't compose messages !", preferredStyle:.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                            let mainController: UIViewController? = keyWindow?.rootViewController
                            mainController?.present(alertController, animated: true)
                        }
                    }
                    if (sepratedValues[0] == "tel") {
                        let dict = [
                            "ad_id" : item["id"],
                            "cta_type" : "tel",
                            "responded" : "true"
                        ]
                        TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                        let phoneUrl = URL(string: "telprompt:\(sepratedValues[1])")
                        UIApplication.shared.openURL(phoneUrl!)
                    }
                    if (sepratedValues[0] == "email") {
                        let dict = [
                            "ad_id" : item["id"],
                            "cta_type" : "email",
                            "responded" : "true"
                        ]
                        TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                        let innnerText = sepratedValues[1] as String
                        let combinedValues = innnerText.components(separatedBy:"/")
                        print("combinedValues %@",combinedValues);
                        if !MFMailComposeViewController.canSendMail() {
                            print("Mail services are not available")
                            let alertController:UIAlertController     = UIAlertController(title: "Errror", message:"Mail services are not available", preferredStyle:.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                            let mainController: UIViewController? = keyWindow?.rootViewController
                            mainController?.present(alertController, animated: true)
                        }
                        else{
                            let composeVC = MFMailComposeViewController()
                            composeVC.mailComposeDelegate = self
                            let senederId = combinedValues[0] as String
                            composeVC.setToRecipients([senederId])
                            if(combinedValues.count>0){
                                composeVC.setSubject(combinedValues[1] as String)
                            }
                            if(combinedValues.count>1){
                                composeVC.setMessageBody(combinedValues[2] as String, isHTML: false)
                            }
                            // Present the view controller modally.
                            //self.present(composeVC, animated: true, completion: nil)
                            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                            let mainController: UIViewController? = keyWindow?.rootViewController
                            mainController?.present(composeVC, animated: true, completion: nil)
                        }
                    }
                    if (sepratedValues[0] == "video") {
                    }
                    if (sepratedValues[0] == "skip") {
                        let  skipTime : CGFloat = CGFloat((sepratedValues[1] as NSString).floatValue)
                        let timeToAdd: CMTime = CMTimeMakeWithSeconds(Float64(skipTime/1000.0), 1)
                        let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds((tangoPlayer?.currentDuration)!, 1000000), timeToAdd)
                        //queuePlayer.seek(to: resultTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                        tangoPlayer?.playerItem?.seek(to: timeToAdd, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                    }
                }
            }
        }
    }
    public func tangoPlayerView(didDisplayControl playerView: TangoPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("faild")
        //customAlert().show(title: kErrorTitle, message: "unknown error !" , buttons: ["OK"], completion: nil)
        case .sent:
            break
        }
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainController: UIViewController? = keyWindow?.rootViewController
        mainController?.dismiss(animated: true, completion: nil)
    }
    public func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainController: UIViewController? = keyWindow?.rootViewController
        mainController?.dismiss(animated: true, completion: nil)
    }
    @objc func Quizclicked(sender : UIButton){
        print("Quizclicked %@",sender.titleLabel?.text)
        let viewWithTag = tangoPlayer?.displayView.contentOverlay.viewWithTag(sender.tag)
        if(viewWithTag?.isKind(of: UIView.self))!{
            let quizBg:UIView =  tangoPlayer?.displayView.contentOverlay.viewWithTag(sender.tag) as! UIView
            let subViews: [UIView] = (quizBg.subviews)
            print("Quiz Subviews %@",subViews)
            for k in 0..<subViews.count {
                let viewWithTag = subViews[k]
                if(viewWithTag.isKind(of: UIButton.self)){
                    print("Button %d",k)
                    let questionBtn:UIButton =  viewWithTag as! UIButton
                    questionBtn.removeTarget(nil, action: nil, for: .allEvents)
                }
            }
        }
        var ansString : NSString
        var result = NSArray()
        let dataSource = UserDefaults.standard.array(forKey: "personlizationArray")
        if (dataSource!.count > 0){
            let existingPredicate = NSPredicate(format: "overlay_id == %@",String(format:"%d",sender.tag))
            result = dataSource!.filter { existingPredicate.evaluate(with: $0) } as! NSArray
            if(result.count>0){
                let item = result[0] as! NSDictionary
                let questionString = item["content"] as! String
                let parsedAnswer = questionString.slice(from: "$_RA_$", to: "$_RA_$")
                if(parsedAnswer != nil){
                    if sender.titleLabel?.text == parsedAnswer{
                        ansString = "true"
                        sender.backgroundColor = UIColor.green
                    }
                    else{
                        ansString = "false"
                        sender.backgroundColor = UIColor.red
                    }
                    let dict = [
                     "ad_id" : item["id"],
                     "cta_type" : item["ad_feed_calltoaction_type"],
                     "responded" : "true",
                     "question" : item["ad_feed_overlay_quiz_question"],
                     "answer" : item["ad_feed_overlay_quiz_correct_answer"],
                     "program_id" : contentInfo.content_id,
                     "program_name" : contentInfo.content_name,
                     "answered_correctly" : ansString
                     ]
                     TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                }
            }
        }
    }
    @objc func labelAction(sender:UITapGestureRecognizer){
        let view = sender.view!.tag
        let bundle = Bundle(for: type(of: self))
        print("labelAction view tag %@",view)
        var result = NSArray()
        let dataSource = UserDefaults.standard.array(forKey: "personlizationArray")
        if (dataSource!.count > 0){
            let existingPredicate = NSPredicate(format: "overlay_id == %@",String(format:"%d",view))
            result = dataSource!.filter { existingPredicate.evaluate(with: $0) } as! NSArray
            print("Jabong Array %@",result)
            if(result.count>0){
                delegate?.didTappedontheobject()
                let item = result[0] as! NSDictionary
                var buttonType = NSString()
                buttonType = "ACTION_WEBLINK"
                if (item["action_type"] as! String == "ON_CLICK") {
                    if(Int((item["pause_on_action"] as! NSString).intValue) == 1){
                        tangoPlayer?.pause()
                    }
                    let actionValue = item["action"] as! String
                    var sepratedValues = actionValue.components(separatedBy: "://")
                    print("sepratedValues %@",sepratedValues);
                    if(sepratedValues.count>0){
                        if (sepratedValues[0] == "weblink") {
                            buttonType = "ACTION_WEBLINK"
                            let combinedValues = actionValue.components(separatedBy: "weblink://")
                            UIApplication.shared.openURL(URL(string: combinedValues[1] as String)!)
                        }
                        if (sepratedValues[0] == "twitter") {
                            buttonType = "ACTION_TWITTER"
                            selectedMediaType = ""
                            let combinedValues = actionValue.components(separatedBy: "twitter://")
                             print("combinedValues %@",combinedValues)
                            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                            let mainController: UIViewController? = keyWindow?.rootViewController
                            print("Width And Height %@ %@", (mainController?.view.frame.size.width)!, (mainController?.view.frame.size.height)!)
                            commentView.frame =  CGRect(x:((mainController?.view.frame.size.width)!-( (mainController?.view.frame.size.width)!-100))/2, y: ((mainController?.view.frame.size.height)!-100)/2, width: (mainController?.view.frame.size.width)!-100, height: 100)
                            commentView.backgroundColor=self.sixDigitHexStringToUIColor(hex: "#f5f8f8", alpha: 1.0)
                            commentView.layer.cornerRadius = 5.0
                            commentView.clipsToBounds = true
                            mainController?.view.addSubview(commentView)
                            
                            closeBtn.frame = CGRect(x: ((mainController?.view.frame.size.width)!-30)/2, y: (commentView.frame.origin.y-20), width: 30, height: 30)
                            closeBtn.setImage(UIImage(named:"TTPlayerResources.bundle/close-button.png", in: bundle, compatibleWith: nil), for: UIControlState.normal)
                            closeBtn.backgroundColor=UIColor.clear
                            closeBtn.addTarget(self, action:#selector(self.closeBtnClicked), for: .touchUpInside)
                            mainController?.view.addSubview(closeBtn)
                            closeBtn.layer.shadowColor=UIColor.black.cgColor
                            closeBtn.layer.shadowOpacity=1.0
                            closeBtn.layer.shadowRadius=3.0
                            closeBtn.layer.shadowOffset=CGSize.zero
                            
                            let postLabel = UILabel()
                            postLabel.frame=CGRect(x:15, y: 0, width:commentView.frame.size.width-30, height: 44)
                            postLabel.backgroundColor=UIColor.clear
                            postLabel.text = "Post to Twitter"
                            postLabel.font = UIFont(name: kHelveticaMediumFont, size: 16.0)
                            postLabel.textColor=UIColor.darkGray
                            postLabel.textAlignment = NSTextAlignment.center
                            commentView.addSubview(postLabel)
                            
                            twitterFeedImage.frame =  CGRect(x:0, y: 44, width: (mainController?.view.frame.size.width)!-100, height: 0)
                            twitterFeedImage.backgroundColor = UIColor.white
                            twitterFeedImage.layer.cornerRadius = 2;
                            twitterFeedImage.contentMode = UIViewContentMode.scaleAspectFit
                            commentView.addSubview(twitterFeedImage)
                            
                            commomFeedView.backgroundColor=UIColor.white
                            commomFeedView.frame =  CGRect(x:0, y: twitterFeedImage.frame.origin.y+twitterFeedImage.frame.size.height, width: ScreenSize.SCREEN_WIDTH-100, height: 56)
                            commentView.addSubview(commomFeedView)
                            
                            let galleryBtn                      = UIButton()
                            galleryBtn.frame = CGRect(x:15, y: 13, width: 30, height: 30)
                            galleryBtn.setImage(UIImage(named:"TTPlayerResources.bundle/attachement_picture_icon.png", in: bundle, compatibleWith: nil), for: UIControlState.normal)
                            galleryBtn.backgroundColor=UIColor.clear
                            galleryBtn.addTarget(self, action:#selector(self.galleryBtnClicked), for: .touchUpInside)
                            commomFeedView.addSubview(galleryBtn)
                            
                            let keyboardDoneButtonView = UIToolbar()
                            keyboardDoneButtonView.sizeToFit()
                            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelCommentClicked))
                            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneCommentClicked))
                            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                            keyboardDoneButtonView.items = [cancelButton, flexible, doneButton]
                            
                            commentTV = UITextView(frame: CGRect(x: 50, y: 8, width: (mainController?.view.frame.size.width)!-200, height: 40))
                            commentTV.textColor = UIColor.black
                            commentTV.font = UIFont(name: kHelveticaMediumFont, size: 15.0)
                            commentTV.backgroundColor = self.sixDigitHexStringToUIColor(hex: "#f5f8f8", alpha: 1.0)
                            commentTV.autocorrectionType = .yes
                            commentTV.layer.cornerRadius = 2.0
                            commentTV.tag = 100
                            commentTV.text = combinedValues[1] as! String
                            commentTV.delegate = self
                            commomFeedView.addSubview(commentTV)
                            commentTV.inputAccessoryView = keyboardDoneButtonView
                            
                            let postCommentBtn = UIButton()
                            postCommentBtn.frame = CGRect(x:commentTV.frame.origin.x+commentTV.frame.size.width+5, y: 13, width: 30, height: 30)
                            postCommentBtn.setImage(UIImage(named:"TTPlayerResources.bundle/post_grey.png", in: bundle, compatibleWith: nil), for: UIControlState.normal)
                            postCommentBtn.backgroundColor=UIColor.clear
                            postCommentBtn.addTarget(self, action:#selector(self.postCommentBtnClicked), for: .touchUpInside)
                            commomFeedView.addSubview(postCommentBtn)
                        }
                        if (sepratedValues[0] == "sms") {
                            buttonType = "ACTION_SMS"
                            
                            let innnerText = sepratedValues[1] as String
                            let combinedValues = innnerText.components(separatedBy:"/")
                            print("combinedValues %@",combinedValues);
                            if MFMessageComposeViewController.canSendText() == true {
                                let recipients:[String] = [combinedValues[0] as String]
                                let messageController = MFMessageComposeViewController()
                                messageController.messageComposeDelegate  = self
                                messageController.recipients = recipients
                                if(combinedValues.count>0){
                                    messageController.body =  combinedValues[1] as String
                                }
                                let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                                let mainController: UIViewController? = keyWindow?.rootViewController
                                mainController?.present(messageController, animated: true, completion: nil)
                            } else {
                                //customAlert().show(title: kErrorTitle, message: "Can't compose messages !" , buttons: ["OK"], completion: nil)
                                let alertController:UIAlertController     = UIAlertController(title: "Errror", message:"Can't compose messages !", preferredStyle:.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                                let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                                let mainController: UIViewController? = keyWindow?.rootViewController
                                mainController?.present(alertController, animated: true)
                            }
                        }
                        if (sepratedValues[0] == "tel") {
                            buttonType = "ACTION_CALL"
                            let phoneUrl = URL(string: "telprompt:\(sepratedValues[1])")
                            UIApplication.shared.openURL(phoneUrl!)
                        }
                        if (sepratedValues[0] == "email") {
                            buttonType = "ACTION_EMAIL"
                            let innnerText = sepratedValues[1] as String
                            let combinedValues = innnerText.components(separatedBy:"/")
                            print("combinedValues %@",combinedValues);
                            if !MFMailComposeViewController.canSendMail() {
                                print("Mail services are not available")
                                let alertController:UIAlertController     = UIAlertController(title: "Errror", message:"Mail services are not available", preferredStyle:.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                                let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                                let mainController: UIViewController? = keyWindow?.rootViewController
                                mainController?.present(alertController, animated: true)
                            }
                            else{
                                let composeVC = MFMailComposeViewController()
                                composeVC.mailComposeDelegate = self
                                let senederId = combinedValues[0] as String
                                composeVC.setToRecipients([senederId])
                                if(combinedValues.count>0){
                                    composeVC.setSubject(combinedValues[1] as String)
                                }
                                if(combinedValues.count>1){
                                    composeVC.setMessageBody(combinedValues[2] as String, isHTML: false)
                                }
                                // Present the view controller modally.
                                //self.present(composeVC, animated: true, completion: nil)
                                let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                                let mainController: UIViewController? = keyWindow?.rootViewController
                                mainController?.present(composeVC, animated: true, completion: nil)
                            }
                        }
                        if (sepratedValues[0] == "video") {
                             buttonType = "ACTION_VIDEO"
                            let actionValue = item["action"] as! String
                            var sepratedValues = actionValue.components(separatedBy: "://")
                            print("sepratedValues %@",sepratedValues);
                            let combinedValues = sepratedValues[1].components(separatedBy:"/")
                            if(combinedValues[0] == "29291"){
                                do {
                                    if let file = Bundle.main.url(forResource: "part2", withExtension: "json") {
                                        let data = try Data(contentsOf: file)
                                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                                        if let object = json as? [String: Any] {
                                           self.getPersonalizationData(dataArray: object["list"] as! NSArray)
                                        } else {
                                            print("JSON is invalid")
                                        }
                                    } else {
                                        print("no file")
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            else if(combinedValues[0] == "29292"){
                                do {
                                    if let file = Bundle.main.url(forResource: "part3", withExtension: "json") {
                                        let data = try Data(contentsOf: file)
                                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                                        if let object = json as? [String: Any] {
                                            self.getPersonalizationData(dataArray: object["list"] as! NSArray)
                                        } else {
                                            print("JSON is invalid")
                                        }
                                    } else {
                                        print("no file")
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            else if(combinedValues[0] == "29290"){
                                do {
                                    if let file = Bundle.main.url(forResource: "part1", withExtension: "json") {
                                        let data = try Data(contentsOf: file)
                                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                                        if let object = json as? [String: Any] {
                                            self.getPersonalizationData(dataArray: object["list"] as! NSArray)
                                        } else {
                                            print("JSON is invalid")
                                        }
                                    } else {
                                        print("no file")
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            if(sepratedValues.count>0){
                                RestHelper().contentDetailWithPersonalizationData(contentId: combinedValues[0], completion: { (result,Success) in
                                    DispatchQueue.main.async() {
                                        if (Success && result != nil ){
                                            let item = result as! ([String:AnyObject])
                                            if let val = item["responseMessage"] {
                                                //completion(result! ,Success)
                                            }else{
                                                let item = result as! ([String:AnyObject])
                                                self.contentInfo.parseContentDetail(item as NSDictionary)
                                                if ( self.contentInfo.content_type == "video" ) {
                                                    let videoURL = URL(string: self.contentInfo.content_url)
                                                    self.tangoPlayer?.replaceVideo(videoURL!)
                                                    if(combinedValues.count>1){
                                                        let  skipTime : CGFloat = CGFloat((combinedValues[1] as NSString).floatValue)
                                                        let timeToAdd: CMTime = CMTimeMakeWithSeconds(Float64(skipTime/1000), 1)
                                                        self.tangoPlayer?.playerItem?.seek(to: timeToAdd, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                                                    }
                                                    self.tangoPlayer?.play()
                                                }
                                            }
                                        }
                                    }
                                })
                                /*TeletangoPlayer.videoDetail(contentId:combinedValues[0]){ (result: ([String:AnyObject])) in
                                    print("Video Details %@",result);
                                    let details = result as! NSDictionary
                                    let insideDetails = details["program"] as! NSDictionary
                                    print("Video Details %@",insideDetails["recorded_video"])
                                    let videoURL = URL(string: insideDetails["recorded_video"] as! String)
                                    if videoURL != nil {
                                        self.tangoPlayer?.replaceVideo(videoURL!)
                                        //let timeToAdd: CMTime = CMTimeMakeWithSeconds(1, 1)
                                        if(combinedValues.count>1){
                                            let  skipTime : CGFloat = CGFloat((combinedValues[1] as NSString).floatValue)
                                            let timeToAdd: CMTime = CMTimeMakeWithSeconds(Float64(skipTime/1000), 1)
                                            //let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds((self.player?.currentDuration)!, 1000000), timeToAdd)
                                            self.tangoPlayer?.playerItem?.seek(to: timeToAdd, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                                        }
                                        self.tangoPlayer?.play()
                                    }
                                }*/
                            }
                        }
                        if (sepratedValues[0] == "skip") {
                              buttonType = "ACTION_SKIP"
                            let  skipTime : CGFloat = CGFloat((sepratedValues[1] as NSString).floatValue)
                            let timeToAdd: CMTime = CMTimeMakeWithSeconds(Float64(skipTime/1000.0), 1)
                            let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds((tangoPlayer?.currentDuration)!, 1000000), timeToAdd)
                            //queuePlayer.seek(to: resultTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                            tangoPlayer?.playerItem?.seek(to: timeToAdd, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                        }
                    
                    print("Before Params")
                        if(contentInfo != nil){
                    let parameters = [
                        "program_id" : contentInfo.content_id,
                        "program_name" : contentInfo.content_name,
                        "overlay_id":  String(format:"%d",view),
                        "overlay_tag": String(format:"%d",view),
                        "button_type" : buttonType,
                        "button_data" : actionValue
                        ] as [String : Any]
                        print("After Params %@",parameters)
                    TeletangoPlayer.logEvent(oftype:ACTION_ON_INTERACTIVE_OVERLAY,params:parameters as ([String : AnyObject]),completion:{(result: ([String:AnyObject])) in
                    })
                    }
                    }
                }
            }
        }
    }
    @objc func closeBtnClicked(){
        self.commentTV.resignFirstResponder()
        commentView.removeFromSuperview()
        closeBtn.removeFromSuperview()
    }
    @objc internal func doneCommentClicked(){
        UIView.animate(withDuration: 0.7, delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveLinear], animations: {
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            let mainController: UIViewController? = keyWindow?.rootViewController
            if(self.selectedMediaType.length>1){
                self.commentView.frame =  CGRect(x:((mainController?.view.frame.size.width)!-( (mainController?.view.frame.size.width)!-100))/2, y: ((mainController?.view.frame.size.height)!-300)/2, width: (mainController?.view.frame.size.width)!-100, height: 300)
            }
            else{
            self.commentView.frame =  CGRect(x:((mainController?.view.frame.size.width)!-( (mainController?.view.frame.size.width)!-100))/2, y: ((mainController?.view.frame.size.height)!-100)/2, width: (mainController?.view.frame.size.width)!-100, height: 100)
            }
            self.commentTV.resignFirstResponder()
            self.closeBtn.frame = CGRect(x: ((mainController?.view.frame.size.width)!-30)/2, y: (self.commentView.frame.origin.y-20), width: 30, height: 30)
        }, completion:nil)
    }
    @objc internal func cancelCommentClicked(){
        self.commentTV.resignFirstResponder()
        commentView.removeFromSuperview()
        closeBtn.removeFromSuperview()
    }
    @objc internal func galleryBtnClicked(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ([(kUTTypeMovie as? String), (kUTTypeImage as? String)] as? [String])!
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainController: UIViewController? = keyWindow?.rootViewController
        mainController?.present(picker, animated: true, completion: nil)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        picker.dismiss(animated: true) {
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        if (mediaType == (kUTTypeImage as? String)) {
            let imagePick = info[UIImagePickerControllerEditedImage] as? UIImage
            //selectedImage = imagePick!
            selectedMediaType = "Picture"
            self.twitterFeedImage.image =  imagePick
        }
        else{
            let videoUrl = info[UIImagePickerControllerMediaURL] as? URL
            let moviePath: String? = videoUrl?.path
            /*if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath!) {
             UISaveVideoAtPathToSavedPhotosAlbum(moviePath!, nil, nil, nil)
             }*/
            //appDelegate().attachedVideoPath = moviePath
            //print("Date 1 %@",NSData.init(contentsOfFile: moviePath!))
            //print("Date 2 %@",NSData.init(contentsOf: videoUrl!))
            selectedVideoPath = videoUrl! as NSURL
            selectedMediaType = "Video"
            do {
                let asset = AVURLAsset(url: videoUrl! , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                self.twitterFeedImage.image =  thumbnail
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
        }
        picker.dismiss(animated: true, completion: {() -> Void in
            //self.commentTV.becomeFirstResponder()
            UIView.animate(withDuration: 0.7, delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveLinear], animations: {
                //self.bottomView.frame = CGRect(x: 0, y: self.frame.height-54, width:self.frame.width, height: 54)
                self.commentView.frame = CGRect(x: 50, y: (ScreenSize.SCREEN_HEIGHT-(+100+200))/2, width: ScreenSize.SCREEN_WIDTH-100, height: 100+200)
                self.twitterFeedImage.frame =  CGRect(x:0, y: 44, width: ScreenSize.SCREEN_WIDTH-100, height: 200)
                self.commomFeedView.frame =  CGRect(x:0, y: self.twitterFeedImage.frame.origin.y+self.twitterFeedImage.frame.size.height, width: ScreenSize.SCREEN_WIDTH-100, height: 56)
                self.closeBtn.frame = CGRect(x: (ScreenSize.SCREEN_WIDTH-30)/2, y: (self.commentView.frame.origin.y-20), width: 30, height: 30)
            }, completion:nil)
        })
    }
    @objc internal func postCommentBtnClicked(){
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainController: UIViewController? = keyWindow?.rootViewController
        let commetText : String = commentTV.text
        if(selectedMediaType == "Video"){
            let store = Twitter.sharedInstance().sessionStore
            if let store = store.session() {
                SVProgressHUD.show(withStatus: "Please wait")
                RestHelper().post(tweetString: commetText, tweetVideoUrl: selectedVideoPath, withUserID: store.userID, completion: { (result: ([String:AnyObject]), success) in
                    SVProgressHUD.dismiss()
                    self.selectedMediaType = ""
                    self.commentView.removeFromSuperview()
                    self.closeBtn.removeFromSuperview()
                    if(success){
                        //completion(result as! [String : AnyObject],success)
                        let alertController:UIAlertController     = UIAlertController(title: kSuccessTitle, message:"Successfully posted.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    else{
                        //completion(result as! [String : AnyObject],success)
                        let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:"Something went wrong, please try after some time.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    
                })
            }
            else{
                Twitter.sharedInstance().logIn(completion: { (session, error) in
                    if (session != nil) {
                        print("signed in as \(String(describing: session?.userName))");
                    } else {
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                })
            }
            /*TTPWebserviceHelper().tweet(commetText, withVideoPathUrl: selectedVideoPath as URL!, in: mainController, withcompletion: { (Success, result) in
                DispatchQueue.main.async() {
                    self.selectedMediaType = ""
                    self.commentView.removeFromSuperview()
                    self.closeBtn.removeFromSuperview()
                    if (Success && result != nil ){
                        //completion(result! as! [String : AnyObject])
                        let alertController:UIAlertController     = UIAlertController(title: kSuccessTitle, message:"Successfully posted.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    else if result != nil {
                        let item=result as! NSError
                        //customAlert().show(title: kErrorTitle, message: item["responseMessage"] as? String , buttons: ["OK"], completion: nil)
                        print("Error %@",result);
                        let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:item.localizedDescription, preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    else {
                        let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:"Something went wrong, please try after some time.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                }
            })*/
        }
        else if(selectedMediaType == "Picture"){
            let store = Twitter.sharedInstance().sessionStore
            if let store = store.session() {
                SVProgressHUD.show(withStatus: "Please wait")
                let imageData = UIImagePNGRepresentation(twitterFeedImage.image!) as Data?
                RestHelper().post(tweetString: commetText, tweetImage: imageData!, withUserID: store.userID, completion: { (result: ([String:AnyObject]), success) in
                    SVProgressHUD.dismiss()
                    self.selectedMediaType = ""
                    self.commentView.removeFromSuperview()
                    self.closeBtn.removeFromSuperview()
                    if(success){
                        //completion(result as! [String : AnyObject],success)
                        let alertController:UIAlertController     = UIAlertController(title: kSuccessTitle, message:"Successfully posted.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    else{
                        //completion(result as! [String : AnyObject],success)
                        let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:"Something went wrong, please try after some time.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    
                })
            }
            else{
                Twitter.sharedInstance().logIn(completion: { (session, error) in
                    if (session != nil) {
                        print("signed in as \(String(describing: session?.userName))");
                    } else {
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                })
            }
            /*TTPWebserviceHelper().tweet(commetText, with: twitterFeedImage.image, in: mainController, withcompletion: { (Success, result) in
                DispatchQueue.main.async() {
                    self.selectedMediaType = ""
                    self.commentView.removeFromSuperview()
                    self.closeBtn.removeFromSuperview()
                    if (Success && result != nil ){
                        //completion(result! as! [String : AnyObject])
                        let alertController:UIAlertController     = UIAlertController(title: kSuccessTitle, message:"Successfully posted.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    else if result != nil {
                        let item=result as! NSError
                        //customAlert().show(title: kErrorTitle, message: item["responseMessage"] as? String , buttons: ["OK"], completion: nil)
                        print("Error %@",result);
                        let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:item.localizedDescription, preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    else {
                        let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:"Something went wrong, please try after some time.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                }
            })*/
        }
        else{
            let store = Twitter.sharedInstance().sessionStore
            if let store = store.session() {
                SVProgressHUD.show(withStatus: "Please wait")
                RestHelper().post(tweetString: commetText, withUserID: store.userID, completion: { (result: ([String:AnyObject]), success) in
                    self.selectedMediaType = ""
                    self.commentView.removeFromSuperview()
                    self.closeBtn.removeFromSuperview()
                    SVProgressHUD.dismiss()
                    if(success){
                        //completion(result as! [String : AnyObject],success)
                        let alertController:UIAlertController     = UIAlertController(title: kSuccessTitle, message:"Successfully posted.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                    else{
                        //completion(result as! [String : AnyObject],success)
                        let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:"Something went wrong, please try after some time.", preferredStyle:.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        let mainController: UIViewController? = keyWindow?.rootViewController
                        mainController?.present(alertController, animated: true)
                    }
                })
            }
            else{
                Twitter.sharedInstance().logIn(completion: { (session, error) in
                    if (session != nil) {
                        print("signed in as \(String(describing: session?.userName))");
                    } else {
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                })
            }
        /*TTPWebserviceHelper().tweet(commetText, in: mainController, withcompletion: { (Success, result) in
            DispatchQueue.main.async() {
                self.selectedMediaType = ""
                self.commentView.removeFromSuperview()
                self.closeBtn.removeFromSuperview()
                if (Success && result != nil ){
                    //completion(result! as! [String : AnyObject])
                    let alertController:UIAlertController     = UIAlertController(title: kSuccessTitle, message:"Successfully posted.", preferredStyle:.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                    let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                    let mainController: UIViewController? = keyWindow?.rootViewController
                    mainController?.present(alertController, animated: true)
                }
                else if result != nil {
                    let item=result as! NSError
                    //customAlert().show(title: kErrorTitle, message: item["responseMessage"] as? String , buttons: ["OK"], completion: nil)
                     print("Error %@",result);
                    let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:item.localizedDescription, preferredStyle:.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                    let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                    let mainController: UIViewController? = keyWindow?.rootViewController
                    mainController?.present(alertController, animated: true)
                }
                else {
                    let alertController:UIAlertController     = UIAlertController(title: kErrorTitle, message:"Something went wrong, please try after some time.", preferredStyle:.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.cancel, handler: nil))
                    let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                    let mainController: UIViewController? = keyWindow?.rootViewController
                    mainController?.present(alertController, animated: true)
                }
            }
        })*/
        }
    }
    //MARK:*************** TextView Delegates Action **********************
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            print("return Button Pressed")
        }
        return true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.7, delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveLinear], animations: {
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            let mainController: UIViewController? = keyWindow?.rootViewController
           // self.commentView.frame =  CGRect(x:((mainController?.view.frame.size.width)!-( (mainController?.view.frame.size.width)!-100))/2, y: (((mainController?.view.frame.size.height)!-100)/2)-self.commentView.frame.size.height, width: (mainController?.view.frame.size.width)!-100, height: 100)
            if(self.selectedMediaType.length>1){
                self.commentView.frame =  CGRect(x:((mainController?.view.frame.size.width)!-( (mainController?.view.frame.size.width)!-100))/2, y: (((mainController?.view.frame.size.height)!-300)/2)-200, width: (mainController?.view.frame.size.width)!-100, height: 300)
            }
            else{
                self.commentView.frame =  CGRect(x:((mainController?.view.frame.size.width)!-( (mainController?.view.frame.size.width)!-100))/2, y: (((mainController?.view.frame.size.height)!-100)/2)-50, width: (mainController?.view.frame.size.width)!-100, height: 100)
            }
            self.closeBtn.frame = CGRect(x: ((mainController?.view.frame.size.width)!-30)/2, y: (self.commentView.frame.origin.y-20), width: 30, height: 30)
        }, completion:nil)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let line: CGRect = textView.caretRect(for: textView.selectedTextRange?.start ?? UITextPosition())
        let overflow: CGFloat = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top)
        if overflow > 0 {
            // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
            // Scroll caret to visible area
            var offset: CGPoint = textView.contentOffset
            offset.y += overflow + 7
            // leave 7 pixels margin
            // Cannot animate with setContentOffset:animated: or caret will not appear
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                textView.contentOffset = offset
            })
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func getPersonalizationData(dataArray:NSArray){
        let jsonArray = dataArray
        /*do {
         if let file = Bundle.main.url(forResource: "MetaData_case1", withExtension: "json") {
         let data = try Data(contentsOf: file)
         let json = try JSONSerialization.jsonObject(with: data, options: [])
         if let object = json as? [String: Any] {
         // json is an array
         jsonArray = object["list"] as! NSArray
         /*if(jsonArray != nil ){
         UserDefaults.standard.set(jsonArray, forKey: "filterArray")
         }*/
         } else {
         print("JSON is invalid")
         }
         } else {
         print("no file")
         }
         } catch {
         print(error.localizedDescription)
         }*/
        
        let filterArray = NSMutableArray()
        for i in 0..<jsonArray.count {
            let tempDict = NSMutableDictionary()
            let item = jsonArray[i] as! NSDictionary
            
            //tempDict["id"] = item["id"]!
            if item["anim_x_min"] == nil || (item["anim_x_min"] is NSNull) {
                tempDict["anim_x_min"] = ""
            }
            else {
                let upadted : Float = Float(3.0)*Float(i)
                let xmin : Float = Float(Float(item["anim_x_min"] as! Float)+upadted)
                //                if(i==0){
                tempDict["anim_x_min"] = String(describing: item["anim_x_min"]!)
                //                }
                //               else{
                //                tempDict["pos_x_min"] = String(describing: xmin)
                //                }
            }
            if item["anim_x_max"] == nil || (item["anim_x_max"] is NSNull){
                tempDict["anim_x_max"] = ""
            }
            else {
                //                let upadted : Float = Float(3.0)*Float(i)
                //                let xmax : Float = Float(Float(item["pos_x_max"] as! Float)+upadted)
                //                if(i==0){
                tempDict["anim_x_max"] = String(describing: item["anim_x_max"]!)
                //                }
                //                else{
                //                tempDict["pos_x_max"] = String(describing: xmax)
                //                }
            }
            if item["anim_y_min"] == nil || (item["anim_y_min"] is NSNull) {
                tempDict["anim_y_min"] = ""
            }
            else {
                //                //tempDict["pos_y_min"] = String(describing: item["pos_y_min"]!)
                //                let upadted : Float = Float(3.0)*Float(i)
                //                let ymin : Float = Float(Float(item["pos_y_min"] as! Float)-upadted)
                //                if(i==0){
                tempDict["anim_y_min"] = String(describing: item["anim_y_min"]!)
                //                }
                //                else{
                //                    tempDict["pos_y_min"] = String(describing: ymin)
                //                }
            }
            if item["anim_y_max"] == nil || (item["anim_y_max"] is NSNull) {
                tempDict["anim_y_max"] = ""
            }
            else {
                let upadted : Float = Float(3.0)*Float(i)
                //tempDict["pos_y_max"] = String(describing: item["pos_y_max"]!)
                //                let ymax : Float = Float(Float(item["pos_y_max"] as! Float)-upadted)
                //                if(i==0){
                tempDict["anim_y_max"] = String(describing: item["anim_y_max"]!)
                //                }
                //                else{
                //                    tempDict["pos_y_max"] = String(describing: ymax)
                //                }
            }
            if item["anim_z_pos"] == nil || (item["anim_z_pos"] is NSNull) {
                tempDict["anim_z_pos"] = ""
            }
            else {
                tempDict["anim_z_pos"] = String(describing: item["anim_z_pos"]!)
            }
            if item["attr_time_relative"] == nil || (item["attr_time_relative"] is NSNull) {
                tempDict["attr_time_relative"] = ""
            }
            else {
                tempDict["attr_time_relative"] = String(describing: item["attr_time_relative"]!)
            }
            if item["attr_start_time"] == nil || (item["attr_start_time"] is NSNull) {
                tempDict["attr_start_time"] = ""
            }
            else {
                //                //tempDict["attr_start_time"] = String(describing: item["attr_start_time"]!)
                //                let upadted : Float = Float(300)*Float(i)
                //                let start : Float = Float(Float(item["attr_start_time"] as! Float)+upadted)
                //                if(i==0){
                tempDict["attr_start_time"] = item["attr_start_time"]! //String(describing: item["attr_start_time"]!)
                //                }
                //                else{
                //                    tempDict["attr_start_time"] = String(describing: start)
                //                }
            }
            if item["attr_end_time"] == nil || (item["attr_end_time"] is NSNull) {
                tempDict["attr_end_time"] = ""
            }
            else {
                //                //tempDict["attr_end_time"] = String(describing: item["attr_end_time"]!)
                //                let upadted : Float = Float(300)*Float(i)
                //                let end : Float = Float(Float(item["attr_end_time"] as! Float)+upadted)
                //                if(i==0){
                tempDict["attr_end_time"] = item["attr_end_time"]!//String(describing: item["attr_end_time"]!)
                //                }
                //                else{
                //                    tempDict["attr_end_time"] = String(describing: end)
                //                }
            }
            if item["anim_scale_factor_x"] == nil || (item["anim_scale_factor_x"] is NSNull) {
                tempDict["anim_scale_factor_x"] = ""
            }
            else {
                //                //tempDict["anim_scale_factor_x"] = String(describing: item["anim_scale_factor_x"]!)
                //                if(i==0){
                tempDict["anim_scale_factor_x"] = String(describing: item["anim_scale_factor_x"]!)
                //                }
                //                /*else if(i%2 == 0){
                //                    tempDict["anim_scale_factor_x"] = "0.7"
                //                }*/
                //                else{
                //                    tempDict["anim_scale_factor_x"] = "1"
                //                }
            }
            if item["anim_scale_factor_y"] == nil || (item["anim_scale_factor_y"] is NSNull) {
                tempDict["anim_scale_factor_y"] = ""
            }
            else {
                //                //tempDict["anim_scale_factor_y"] = String(describing: item["anim_scale_factor_y"]!)
                //                if(i==0){
                tempDict["anim_scale_factor_y"] = String(describing: item["anim_scale_factor_y"]!)
                //                }
                //                /*else if(i%2 == 0){
                //                     tempDict["anim_scale_factor_y"] = "0.7"
                //                }*/
                //                else{
                //                    tempDict["anim_scale_factor_y"] = "1"
                //                }
                
            }
            if item["content_background_color"] == nil || (item["content_background_color"] is NSNull) {
                tempDict["content_background_color"] = ""
            }
            else {
                tempDict["content_background_color"] = String(describing: item["content_background_color"]!)
            }
            if item["anim_rotate_angle_x"] == nil || (item["anim_rotate_angle_x"] is NSNull) {
                tempDict["anim_rotate_angle_x"] = ""
            }
            else {
                tempDict["anim_rotate_angle_x"] = String(describing: item["anim_rotate_angle_x"]!)
            }
            if item["anim_rotate_angle_y"] == nil || (item["anim_rotate_angle_y"] is NSNull) {
                tempDict["anim_rotate_angle_y"] = ""
            }
            else {
                //                if(i==0){
                tempDict["anim_rotate_angle_y"] = String(describing: item["anim_rotate_angle_y"]!)
                //                }
                //                /*else if(i%2 == 0){
                //                    tempDict["anim_rotate_angle_y"] = "50"
                //                }*/
                //                else{
                //                    tempDict["anim_rotate_angle_y"] = "0"
                //                }
            }
            if item["anim_rotate_angle_z"] == nil || (item["anim_rotate_angle_z"] is NSNull) {
                tempDict["anim_rotate_angle_z"] = ""
            }
            else {
                tempDict["anim_rotate_angle_z"] = String(describing: item["anim_rotate_angle_z"]!)
            }
            if item["content_type"] == nil || (item["content_type"] is NSNull) {
                tempDict["content_type"] = ""
            }
            else {
                tempDict["content_type"] = String(describing: item["content_type"]!)
            }
            if item["content"] == nil || (item["content"] is NSNull) {
                tempDict["content"] = ""
            }
            else {
                tempDict["content"] = String(describing: item["content"]!)
            }
            if item["content_text_size_multiplier"] == nil || (item["content_text_size_multiplier"] is NSNull) {
                tempDict["content_text_size_multiplier"] = ""
            }
            else {
                tempDict["content_text_size_multiplier"] = String(describing: item["content_text_size_multiplier"]!)
            }
            if item["content_text_color"] == nil || (item["content_text_color"] is NSNull) {
                tempDict["content_text_color"] = ""
            }
            else {
                tempDict["content_text_color"] = String(describing: item["content_text_color"]!)
            }
            if item["content_text_style"] == nil || (item["content_text_style"] is NSNull) {
                tempDict["content_text_style"] = ""
            }
            else {
                tempDict["content_text_style"] = String(describing: item["content_text_style"]!)
            }
            if item["action_type"] == nil || (item["action_type"] is NSNull) {
                tempDict["action_type"] = ""
            }
            else {
                tempDict["action_type"] = String(describing: item["action_type"]!)
            }
            if item["action_time"] == nil || (item["action_time"] is NSNull) {
                tempDict["action_time"] = ""
            }
            else {
                tempDict["action_time"] = String(describing: item["action_time"]!)
            }
            if item["action"] == nil || (item["action"] is NSNull) {
                tempDict["action"] = ""
            }
            else {
                tempDict["action"] = String(describing: item["action"]!)
            }
            if item["pause_on_action"] == nil || (item["pause_on_action"] is NSNull) {
                tempDict["pause_on_action"] = ""
            }
            else {
                tempDict["pause_on_action"] = String(describing: item["pause_on_action"]!)
            }
            if item["overlay_id"] == nil || (item["overlay_id"] is NSNull) {
                tempDict["overlay_id"] = ""
            }
            else {
                tempDict["overlay_id"] = String(describing: item["overlay_id"]!)
            }
            if item["type"] == nil || (item["type"] is NSNull) {
                tempDict["type"] = ""
            }
            else {
                tempDict["type"] = String(describing: item["type"]!)
            }
            if item["content_background_alpha"] == nil || (item["content_background_alpha"] is NSNull) {
                tempDict["content_background_alpha"] = ""
            }
            else {
                tempDict["content_background_alpha"] = String(describing: item["content_background_alpha"]!)
            }
            if item["content_text_color_alpha"] == nil || (item["content_text_color_alpha"] is NSNull) {
                tempDict["content_text_color_alpha"] = ""
            }
            else {
                tempDict["content_text_color_alpha"] = String(describing: item["content_text_color_alpha"]!)
            }
            if item["id"] == nil || (item["id"] is NSNull) {
                tempDict["id"] = ""
            }
            else {
                tempDict["id"] = String(describing: item["id"]!)
            }
            filterArray.add(tempDict);
            //sqLiteManager().save(toSheet: tempDict, into: "IVPData")
        }
        print("filterArray %@",filterArray)
        UserDefaults.standard.set(filterArray, forKey: "personlizationArray")
        UserDefaults.standard.synchronize()
    }
    func reloadMainVideoPersonalization(){
        var jsonArray = NSArray()
        do {
            if let file = Bundle.main.url(forResource: "MetaData_image", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is an array
                    jsonArray = object["list"] as! NSArray
                    /*if(jsonArray != nil ){
                     UserDefaults.standard.set(jsonArray, forKey: "filterArray")
                     }*/
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let filterArray = NSMutableArray()
        for i in 0..<jsonArray.count {
            let tempDict = NSMutableDictionary()
            let item = jsonArray[i] as! NSDictionary
            
            //tempDict["id"] = item["id"]!
            if item["anim_x_min"] == nil || (item["anim_x_min"] is NSNull) {
                tempDict["anim_x_min"] = ""
            }
            else {
                let upadted : Float = Float(3.0)*Float(i)
                let xmin : Float = Float(Float(item["anim_x_min"] as! Float)+upadted)
                //                if(i==0){
                tempDict["anim_x_min"] = String(describing: item["anim_x_min"]!)
                //                }
                //               else{
                //                tempDict["pos_x_min"] = String(describing: xmin)
                //                }
            }
            if item["anim_x_max"] == nil || (item["anim_x_max"] is NSNull){
                tempDict["anim_x_max"] = ""
            }
            else {
                //                let upadted : Float = Float(3.0)*Float(i)
                //                let xmax : Float = Float(Float(item["pos_x_max"] as! Float)+upadted)
                //                if(i==0){
                tempDict["anim_x_max"] = String(describing: item["anim_x_max"]!)
                //                }
                //                else{
                //                tempDict["pos_x_max"] = String(describing: xmax)
                //                }
            }
            if item["anim_y_min"] == nil || (item["anim_y_min"] is NSNull) {
                tempDict["anim_y_min"] = ""
            }
            else {
                //                //tempDict["pos_y_min"] = String(describing: item["pos_y_min"]!)
                //                let upadted : Float = Float(3.0)*Float(i)
                //                let ymin : Float = Float(Float(item["pos_y_min"] as! Float)-upadted)
                //                if(i==0){
                tempDict["anim_y_min"] = String(describing: item["anim_y_min"]!)
                //                }
                //                else{
                //                    tempDict["pos_y_min"] = String(describing: ymin)
                //                }
            }
            if item["anim_y_max"] == nil || (item["anim_y_max"] is NSNull) {
                tempDict["anim_y_max"] = ""
            }
            else {
                let upadted : Float = Float(3.0)*Float(i)
                //tempDict["pos_y_max"] = String(describing: item["pos_y_max"]!)
                //                let ymax : Float = Float(Float(item["pos_y_max"] as! Float)-upadted)
                //                if(i==0){
                tempDict["anim_y_max"] = String(describing: item["anim_y_max"]!)
                //                }
                //                else{
                //                    tempDict["pos_y_max"] = String(describing: ymax)
                //                }
            }
            if item["anim_z_pos"] == nil || (item["anim_z_pos"] is NSNull) {
                tempDict["anim_z_pos"] = ""
            }
            else {
                tempDict["anim_z_pos"] = String(describing: item["anim_z_pos"]!)
            }
            if item["attr_time_relative"] == nil || (item["attr_time_relative"] is NSNull) {
                tempDict["attr_time_relative"] = ""
            }
            else {
                tempDict["attr_time_relative"] = String(describing: item["attr_time_relative"]!)
            }
            if item["attr_start_time"] == nil || (item["attr_start_time"] is NSNull) {
                tempDict["attr_start_time"] = ""
            }
            else {
                //                //tempDict["attr_start_time"] = String(describing: item["attr_start_time"]!)
                //                let upadted : Float = Float(300)*Float(i)
                //                let start : Float = Float(Float(item["attr_start_time"] as! Float)+upadted)
                //                if(i==0){
                tempDict["attr_start_time"] = item["attr_start_time"]! //String(describing: item["attr_start_time"]!)
                //                }
                //                else{
                //                    tempDict["attr_start_time"] = String(describing: start)
                //                }
            }
            if item["attr_end_time"] == nil || (item["attr_end_time"] is NSNull) {
                tempDict["attr_end_time"] = ""
            }
            else {
                //                //tempDict["attr_end_time"] = String(describing: item["attr_end_time"]!)
                //                let upadted : Float = Float(300)*Float(i)
                //                let end : Float = Float(Float(item["attr_end_time"] as! Float)+upadted)
                //                if(i==0){
                tempDict["attr_end_time"] = item["attr_end_time"]!//String(describing: item["attr_end_time"]!)
                //                }
                //                else{
                //                    tempDict["attr_end_time"] = String(describing: end)
                //                }
            }
            if item["anim_scale_factor_x"] == nil || (item["anim_scale_factor_x"] is NSNull) {
                tempDict["anim_scale_factor_x"] = ""
            }
            else {
                //                //tempDict["anim_scale_factor_x"] = String(describing: item["anim_scale_factor_x"]!)
                //                if(i==0){
                tempDict["anim_scale_factor_x"] = String(describing: item["anim_scale_factor_x"]!)
                //                }
                //                /*else if(i%2 == 0){
                //                    tempDict["anim_scale_factor_x"] = "0.7"
                //                }*/
                //                else{
                //                    tempDict["anim_scale_factor_x"] = "1"
                //                }
            }
            if item["anim_scale_factor_y"] == nil || (item["anim_scale_factor_y"] is NSNull) {
                tempDict["anim_scale_factor_y"] = ""
            }
            else {
                //                //tempDict["anim_scale_factor_y"] = String(describing: item["anim_scale_factor_y"]!)
                //                if(i==0){
                tempDict["anim_scale_factor_y"] = String(describing: item["anim_scale_factor_y"]!)
                //                }
                //                /*else if(i%2 == 0){
                //                     tempDict["anim_scale_factor_y"] = "0.7"
                //                }*/
                //                else{
                //                    tempDict["anim_scale_factor_y"] = "1"
                //                }
                
            }
            if item["content_background_color"] == nil || (item["content_background_color"] is NSNull) {
                tempDict["content_background_color"] = ""
            }
            else {
                tempDict["content_background_color"] = String(describing: item["content_background_color"]!)
            }
            if item["anim_rotate_angle_x"] == nil || (item["anim_rotate_angle_x"] is NSNull) {
                tempDict["anim_rotate_angle_x"] = ""
            }
            else {
                tempDict["anim_rotate_angle_x"] = String(describing: item["anim_rotate_angle_x"]!)
            }
            if item["anim_rotate_angle_y"] == nil || (item["anim_rotate_angle_y"] is NSNull) {
                tempDict["anim_rotate_angle_y"] = ""
            }
            else {
                //                if(i==0){
                tempDict["anim_rotate_angle_y"] = String(describing: item["anim_rotate_angle_y"]!)
                //                }
                //                /*else if(i%2 == 0){
                //                    tempDict["anim_rotate_angle_y"] = "50"
                //                }*/
                //                else{
                //                    tempDict["anim_rotate_angle_y"] = "0"
                //                }
            }
            if item["anim_rotate_angle_z"] == nil || (item["anim_rotate_angle_z"] is NSNull) {
                tempDict["anim_rotate_angle_z"] = ""
            }
            else {
                tempDict["anim_rotate_angle_z"] = String(describing: item["anim_rotate_angle_z"]!)
            }
            if item["content_type"] == nil || (item["content_type"] is NSNull) {
                tempDict["content_type"] = ""
            }
            else {
                tempDict["content_type"] = String(describing: item["content_type"]!)
            }
            if item["content"] == nil || (item["content"] is NSNull) {
                tempDict["content"] = ""
            }
            else {
                tempDict["content"] = String(describing: item["content"]!)
            }
            if item["content_text_size_multiplier"] == nil || (item["content_text_size_multiplier"] is NSNull) {
                tempDict["content_text_size_multiplier"] = ""
            }
            else {
                tempDict["content_text_size_multiplier"] = String(describing: item["content_text_size_multiplier"]!)
            }
            if item["content_text_color"] == nil || (item["content_text_color"] is NSNull) {
                tempDict["content_text_color"] = ""
            }
            else {
                tempDict["content_text_color"] = String(describing: item["content_text_color"]!)
            }
            if item["content_text_style"] == nil || (item["content_text_style"] is NSNull) {
                tempDict["content_text_style"] = ""
            }
            else {
                tempDict["content_text_style"] = String(describing: item["content_text_style"]!)
            }
            if item["action_type"] == nil || (item["action_type"] is NSNull) {
                tempDict["action_type"] = ""
            }
            else {
                tempDict["action_type"] = String(describing: item["action_type"]!)
            }
            if item["action_time"] == nil || (item["action_time"] is NSNull) {
                tempDict["action_time"] = ""
            }
            else {
                tempDict["action_time"] = String(describing: item["action_time"]!)
            }
            if item["action"] == nil || (item["action"] is NSNull) {
                tempDict["action"] = ""
            }
            else {
                tempDict["action"] = String(describing: item["action"]!)
            }
            if item["pause_on_action"] == nil || (item["pause_on_action"] is NSNull) {
                tempDict["pause_on_action"] = ""
            }
            else {
                tempDict["pause_on_action"] = String(describing: item["pause_on_action"]!)
            }
            if item["overlay_id"] == nil || (item["overlay_id"] is NSNull) {
                tempDict["overlay_id"] = ""
            }
            else {
                tempDict["overlay_id"] = String(describing: item["overlay_id"]!)
            }
            if item["type"] == nil || (item["type"] is NSNull) {
                tempDict["type"] = ""
            }
            else {
                tempDict["type"] = String(describing: item["type"]!)
            }
            if item["content_text_gravity"] == nil || (item["content_text_gravity"] is NSNull) {
                tempDict["content_text_gravity"] = ""
            }
            else {
                tempDict["content_text_gravity"] = String(describing: item["content_text_gravity"]!)
            }
            filterArray.add(tempDict);
            //sqLiteManager().save(toSheet: tempDict, into: "IVPData")
        }
        //print("filterArray %@",filterArray)
        UserDefaults.standard.set(filterArray, forKey: "personlizationArray")
        UserDefaults.standard.synchronize()
    }
    //MARK:*************** Check For YouTube Video's **********************
    public func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState){
        switch playerState.rawValue {
        case "1" :
            print("Started playback")
            let parameters = [
                "program_id" : contentInfo.content_id,
                "video_url" : contentInfo.content_url,
                "program_name" : contentInfo.content_name,
                "video_source" : "YouTube",
                "total_video_time" : youtubePlayerView.getDuration(),
                "drop_time" : youtubePlayerView.getCurrentTime()
                ] as [String : Any]
           TTPWebserviceHelper().logEventofType(CONTENT_PLAY_RESUME, withParameters: parameters)
        case "2" :
            print("Paused playback")
            let parameters = [
                "program_id" : contentInfo.content_id,
                "video_url" : contentInfo.content_url,
                "program_name" : contentInfo.content_name,
                "video_source" : "YouTube",
                "total_video_time" :youtubePlayerView.getDuration(),
                "drop_time" : youtubePlayerView.getCurrentTime()
                ] as [String : Any]
            TTPWebserviceHelper().logEventofType(CONTENT_PLAY_PAUSE, withParameters: parameters)
        case "0" :
            print("Paused playback")
            let parameters = [
                "program_id" : contentInfo.content_id,
                "video_url" : contentInfo.content_url,
                "program_name" : contentInfo.content_name,
                "video_source" : "YouTube",
                "total_video_time" : youtubePlayerView.getDuration(),
                "drop_time" : youtubePlayerView.getCurrentTime()
                ] as [String : Any]
            TTPWebserviceHelper().logEventofType(CONTENT_PLAY_STOP, withParameters: parameters)
        default:
            break
        }
    }
    public func playerReady(_ videoPlayer: YouTubePlayerView){
        let parameters = [
            "program_id" : contentInfo.content_id,
            "video_url" : contentInfo.content_url,
            "program_name" : contentInfo.content_name,
            "video_source" : "YouTube",
            "total_video_time" : youtubePlayerView.getDuration(),
            "drop_time" : youtubePlayerView.getCurrentTime()
            ] as [String : Any]
       TTPWebserviceHelper().logEventofType(CONTENT_PLAY_START, withParameters: parameters)
        youtubePlayerView.play()
    }

    //MARK:*************** Check For Ads **********************
    /**
     This method will get called to check the ads in the mid of the main programe video
     */
    @objc func checkForAdWithTimer(){
        var adsArray = contentInfo.insert_videos
        let dTotalSeconds : Int = Int(tangoPlayer!.currentDuration)
        for i in 0..<adsArray.count {
            if isFromAd == false {
                 mainPlayerTime = (tangoPlayer?.currentDuration)!
                let item = adsArray[i] as! NSDictionary
                if (dTotalSeconds == Int(item["start_offset_secs"] as! Int)) {
                    let videoURL = URL(string: item["recorded_video"] as! String)
                    if !( item["recorded_video"] as! String).isEmpty {
                        isFromAd = true
                         if videoURL != nil {
                        tangoPlayer?.displayView.isAds = true
                        tangoPlayer?.replaceVideo(videoURL!)
                        tangoPlayer?.play()
                        }
                    recentAdArray.removeAllObjects()
                    recentAdArray.add(adsArray[i])
                    skipBtnTimer.invalidate()
                    videoOverLayTimer.invalidate()
                    overlaySubView.removeFromSuperview()
                    fullScreenOverlay.removeFromSuperview()
                    skipBtnTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showSkipButton), userInfo: nil, repeats: true)
                    videoOverLayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(videoOverLayAdTimer), userInfo: nil, repeats: true)
                    break
                    }
                }
            }
        }
        playerTime = playerTime+1
    }
     //MARK:*************** Check For Video Overlays  **********************
    /**
     This method will get called to check the Video Overlays in the mid of the main programe video/Ad Video
     */
    @objc func videoOverLayAdTimer(){

        if (tangoPlayer?.displayView.isFullScreen == true){
            fullScreenOverlay.isHidden =  false
        }
        else {
            fullScreenOverlay.isHidden =  true
        }
        if (isFromAd ==  true){
        if recentAdArray.count>0{
            let item = recentAdArray[0] as! NSDictionary
            self.CreateoverlayaddsforvideoplayeronFullScreen(overlayAdsList: item["overlay_ads_list"] as! NSArray)
            self.Createoverlayaddsforvideoplayer(overlayAdsList: item["overlay_ads_list"] as! NSArray)
        }
        }
        else if (isFromAd == false){
            if(contentInfo != nil){
            if contentInfo.overlayads_list != nil {
            if(contentInfo.overlayads_list.count>0){
                self.CreateoverlayaddsforvideoplayeronFullScreen(overlayAdsList: contentInfo.overlayads_list as NSArray)
                self.Createoverlayaddsforvideoplayer(overlayAdsList: contentInfo.overlayads_list as NSArray)
            }
            }
            }
        }
    }
    //MARK:*************** Check For Skip Button  **********************
    /**
     This method will get called to check Skip button in th mid of Ad Video
     */
    @objc func showSkipButton(){
        
        /*let currentItem: AVPlayerItem? = queuePlayer.currentItem
        let currentTime: CMTime? = currentItem?.currentTime()*/
        let dTotalSeconds : Int = Int(tangoPlayer!.currentDuration)
        
        let item = recentAdArray[0] as! NSDictionary
        if dTotalSeconds == Int(item["skip_after"] as! Int) {
            skipBtnTimer.invalidate()
            skipBtn.backgroundColor=UIColor.clear
            skipBtn.setTitle("SKIP", for: UIControlState.normal)
            skipBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            skipBtn.layer.cornerRadius=2.0
            skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            skipBtn.addTarget(self, action:#selector(self.skipBtnPressed), for: .touchUpInside)
            tangoPlayer?.displayView.addSubview(skipBtn)
            skipBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(-10)
                make.bottom.equalTo(-100)
                make.height.equalTo(35)
                make.width.equalTo(70)
            })
            /*if isVideoinFullscreen == false{
            playerViewController.view.addSubview(skipBtn)
            }
            else{
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            keyWindow?.addSubview(skipBtn)
            }*/
        }
    }
    //MARK:*************** Skip Button Action **********************
    /**
     This method will get called When user pressed on skip button
     */
    @objc func skipBtnPressed(){
        skipBtnTimer.invalidate()
        skipBtn.removeFromSuperview()
        videoOverLayTimer.invalidate()
        overlaySubView.removeFromSuperview()
        fullScreenOverlay.removeFromSuperview()
        let dTotalSeconds : Int = Int(tangoPlayer!.currentDuration)
        if recentAdArray.count > 0 {
            // let dTotalSeconds :Double = CMTimeGetSeconds(queuePlayer!.currentItem?.asset.duration)
            let item = recentAdArray[0] as! NSDictionary
            videoEventsparams = [
                "ad_id" : item["id"],
                "video_url" : item["recorded_video"],
                "skipped" : "true",
                "skipped_at" : dTotalSeconds
            ]
            TTPWebserviceHelper().postAddevents(OVERLAY_VIDEOADS, withparameters: videoEventsparams as! [AnyHashable : Any])
        }
        let videoURL = URL(string: contentInfo.content_url)
        if videoURL != nil {
            tangoPlayer?.replaceVideo(videoURL!)
            tangoPlayer?.displayView.isAds = false
            let timeToAdd: CMTime = CMTimeMakeWithSeconds(1, 1)
            let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds(mainPlayerTime, 1000000), timeToAdd)
            tangoPlayer?.playerItem?.seek(to: resultTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            tangoPlayer?.play()
        }
        isFromAd = false
        recentAdArray.removeAllObjects()
        adTimer.invalidate()
        adTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForAdWithTimer), userInfo: nil, repeats: true)
        videoOverLayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(videoOverLayAdTimer), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.tangoPlayer?.displayView.frame = CGRect(x:0, y:0, width:self.playerView.frame.size.width, height: self.playerView.frame.size.height-20)
        }, completion: { (finished: Bool) in
        })
    }
    //MARK:*************** Avplayer Observers **********************
   @objc func playerItemDidReachEnd(sender : NSNotification)  {
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        /*if ((cString.characters.count) != 6) {
         return UIColor.gray
         }*/
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
            blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
            //alpha: CGFloat(1.0)
            alpha : CGFloat( rgbValue & 0x000000FF) / 255.0
        )
    }
    func sixDigitHexStringToUIColor(hex:String,alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
/**
 This Extension method will get called When user want to load image from url asynchronously
 */
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
}
extension UIView {
    
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
}
extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}
