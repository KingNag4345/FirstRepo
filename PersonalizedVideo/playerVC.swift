//
//  playerVC.swift
//  PersonalizedVideo
//
//  Created by Nagaraju Surisetty on 11/11/17.
//  Copyright © 2017 PrimeFocus Technologies. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI
import WebKit

class playerVC: UIViewController,AVPlayerViewControllerDelegate,TangoPlayerDelegate,TangoPlayerViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate {
    func didTouchedOnthePlayer(xPercentage: Float, yPercentage: Float) {
        
    }
    
    func didTappedontheobject() {
        
    }
    
    var selectedImage                   = UIImage()
    var player                          : TangoPlayer?
    var croppedImage                    = UIImageView()
    var timeString                      : Int = 0
    let textLabel                       = UILabel()
    var videoRectFrame                  : CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor=UIColor.white
         self.view.isUserInteractionEnabled=true
         self.view.isMultipleTouchEnabled = false
        // Do any additional setup after loading the view.
        
        let topHeaderView = UIView()
        topHeaderView.frame = CGRect(x:0, y: 0, width: self.view.frame.size.width, height: 64)
        topHeaderView.backgroundColor = UIColor.clear  //UIColor(red:24.0/255.0, green:24.0/255.0, blue:24.0/255.0, alpha:1.0)
        self.view.addSubview(topHeaderView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = topHeaderView.bounds
        blurEffectView.clipsToBounds = true
        topHeaderView.addSubview(blurEffectView)
        
        let nextBtn = UIButton();
        nextBtn.frame = CGRect(x:20, y:20, width: 70, height: 44)
        nextBtn.backgroundColor=UIColor.clear
        nextBtn.setTitle("Back", for: UIControlState.normal)
        nextBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        nextBtn.layer.cornerRadius=2.0
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        nextBtn.addTarget(self, action:#selector(self.backBtnPressed), for: .touchUpInside)
        topHeaderView.addSubview(nextBtn)
        
        /*//let videoURL = URL(string: "https://d2bj9mscp1erqx.cloudfront.net/incdev/fbee3a75-9144-4525-81e1-af337dba46ae/master.m3u8")
         //http://45.79.203.234:1935/murasutv/myStream/playlist.m3u8
        let player = TTPlayerView.init(frame: CGRect(x:0, y:40, width:self.view.frame.size.width,height: self.view.frame.size.height/2), playImage: nil, pauseImage: nil, localFileUrl: "https://s3-ap-southeast-1.amazonaws.com/ovp-transcoded-data/Mobile_App_without_VO.mov")
        player.backgroundColor=UIColor.clear
        player.delegate = self
        player.placeholderLogo = selectedImage
        self.view.addSubview(player)*/
        
        //let videoURL = URL(string: "http://inchara.ddns.net/stream.m3u8")//Mobile_App_without_VO
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "mobile_app_withaudio", ofType: "mp4")!)
        if url != nil {
            self.player = TangoPlayer(URL: url)
        }
        self.player?.delegate = self
        self.view.addSubview((self.player?.displayView)!)
        self.player?.backgroundMode = .proceed
        self.player?.displayView.delegate = self
        self.player?.displayView.titleLabel.text = "Sample Video"
        self.player?.displayView.isAds = false
        self.player?.displayView.frame = CGRect(x:0, y:64, width:self.view.frame.size.width, height: ((self.view.frame.size.height-64)))//-118
        self.player?.displayView.backgroundColor = UIColor.black
        self.player?.displayView.contentOverlay.backgroundColor = UIColor.clear
        self.player?.play()
        
        UserDefaults.standard.set("SYUNJl/8kMijIP6oBrTsQ3YozkYr2V1im70F14JX+Gk=", forKey: "ApiKey")
        UserDefaults.standard.set("223679981237397", forKey: "AppUserId")
        //SVProgressHUD.show(withStatus: "Please wait")
        /*TeletangoPlayer.contentDetail(contentId:"31775"){ (result: ([String:AnyObject])) in
                        //SVProgressHUD.dismiss()
                        let player = TTPlayerView.init(frame: CGRect(x:0, y:64, width:self.view.frame.size.width, height: ((self.view.frame.size.height-64)/2)), playImage: nil,pauseImage: nil)
                        player.backgroundColor=UIColor.clear
                        player.placeholderLogo = UIImage(named:"logoImage.png")!
                        self.view.addSubview(player)
                }*/
        
        textLabel.frame=CGRect(x:0, y: (self.view.frame.size.height/2)+50, width:350, height:50)
        textLabel.backgroundColor=UIColor.clear
        textLabel.font = UIFont(name: "MyriadPro-Regular", size: 16)
        textLabel.text = "Nagaraju How are you "
        textLabel.textAlignment=NSTextAlignment.center
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.black
        //self.view.addSubview(textLabel)
    }
    func orientationChnaged(_ isLandscape: Bool){
        appDelegate().isFullScreen = isLandscape
    }
    public func tangoPlayerViewOrientationChnaged(_ playerView: TangoPlayerView, willFullscreen isFullscreen: Bool){
        appDelegate().isFullScreen = isFullscreen
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    @objc func backBtnPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    func tangoPlayer(_ player: TangoPlayer, playerFailed error: TangoPlayerError) {
        print(error)
    }
    func tangoPlayer(_ player: TangoPlayer, stateDidChange state: TangoPlayerState) {
        print("player State ",state)
        if (state == TangoPlayerState.paused){
            print("Current Time at paused State %@",player.currentDuration)
            print("Total Time at paused State %@",player.totalDuration)
            var subViews: [UIView] = (player.displayView.contentOverlay.subviews)
            var dTotalSeconds : Int = 0
            if(player.totalDuration >= 0){
                dTotalSeconds = Int(player.totalDuration)
            }
            let dCurrentSeconds : Int = Int(player.currentDuration)
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
            var subViews: [UIView] = (player.displayView.contentOverlay.subviews)
            var dTotalSeconds : Int = 0
            if(player.totalDuration >= 0){
                dTotalSeconds = Int(player.totalDuration)
            }
            let dCurrentSeconds : Int = Int(player.currentDuration)
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
        if (state == TangoPlayerState.playFinished){
            print("Current Time at finished State %@",player.currentDuration)
            print("Total Time at finished State %@",player.totalDuration)
        }
    }
    func tangoPlayer(_ player: TangoPlayer, bufferStateDidChange state: TangoPlayerBufferstate) {
        print("buffer State", state)
        if state == TangoPlayerBufferstate.readyToPlay {
            croppedImage.removeFromSuperview()
        }
    }
    func tangoPlayerPeriodicObserver(_ player: TangoPlayer, playercurrentTime:Int,DifferenceTime:Int,videoBounds: CGRect,isForwarded:Bool){
    //print("Periodic Observer Called %@",playercurrentTime)
    //print("Periodic Observer DifferenceTime %@",DifferenceTime)
    //print("Periodic Observer Player Rect %f %f %f %f",videoBounds.origin.x,videoBounds.origin.y,videoBounds.size.width,videoBounds.size.height)
    let dataSource = UserDefaults.standard.array(forKey: "personlizationArray")
    //print("New Json Data %@",adsArray)
    timeString = playercurrentTime
    videoRectFrame = videoBounds
    
    //let  adsArray = sqLiteManager().find(nil, from: "IVPData", where: String(format:"(%d BETWEEN attr_start_time AND attr_end_time)",playercurrentTime))! as NSArray
    if(dataSource != nil && dataSource!.count>0){
    let predicate = NSPredicate(format: "%d >= attr_start_time AND %d <= attr_end_time", playercurrentTime,playercurrentTime)
    let adsArray = dataSource?.filter { predicate.evaluate(with: $0) } as! NSArray
    // print("adsArray %@",adsArray)
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
    let  overlay_x_min : CGFloat = CGFloat((item["pos_x_min"] as! NSString).floatValue)
    let  overlay_y_min : CGFloat = CGFloat((item["pos_y_min"] as! NSString).floatValue)
    let  overlay_x_max : CGFloat = CGFloat((item["pos_x_max"] as! NSString).floatValue)
    let  overlay_y_max : CGFloat = CGFloat((item["pos_y_max"] as! NSString).floatValue)
    let  overlay_z_max : CGFloat = CGFloat((item["pos_z_pos"] as! NSString).floatValue)
    
    let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
    let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
    let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
    
    let xMinValue :CGFloat = (overlay_x_min * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
    let xMaxValue :CGFloat = (overlay_x_max * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
    
    let yMinValue :CGFloat = (overlay_y_min * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
    let yMaxValue :CGFloat = (overlay_y_max * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
    
    let p1 = CGPoint(x: videoBounds.origin.x + xMinValue, y: videoBounds.origin.y + yMinValue)
    let p2 = CGPoint(x: videoBounds.origin.x + xMaxValue, y: videoBounds.origin.y  + yMaxValue)
    
    let  backgroundalpha :CGFloat = CGFloat((item["background_color_alpha"] as! NSString).floatValue)
    let  textalpha :CGFloat = CGFloat((item["text_color_alpha"] as! NSString).floatValue)
    
    let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
    
    let xradians = xdegrees * .pi / 180
    let yradians = ydegrees * .pi / 180
    let zradians = zdegrees * .pi / 180
    let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
    let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
    var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
    if(UIDevice.current.userInterfaceIdiom == .pad){
        fontSize = 1.5*fontSize
    }
    if(player.displayView.isFullScreen == true){
    fontSize = fontSize*1.2
    }
    
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
    subLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //subLabel.alpha = backgroundalpha
    subLabel.font = UIFont(name: "Helvetica", size: fontSize)
    subLabel.textAlignment=NSTextAlignment.center
    subLabel.numberOfLines = 0
    subLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String) , alpha:textalpha)
    subLabel.text = text
    if (xScale == 1.0 && yScale == 1.0 ){
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
    overlayImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //overlayImageBg.alpha = backgroundalpha
    overlayImageBg.imageFromServerURL(urlString: item["content"] as! String)
    overlayImageBg.layer.zPosition = overlay_z_max
    overlayImageBg.image = selectedImage
    overlayImageBg.contentMode=UIViewContentMode.scaleAspectFill
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
    quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //quizBg.alpha = backgroundalpha
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
     tapGestureOnActionLabel.delegate = self
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
    //webView.backgroundColor = UIColor.clear
    //webView.backgroundColor?.withAlphaComponent(0)
    webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //webView.alpha = backgroundalpha
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
    webView.tag =  Int((item["overlay_id"] as! NSString).intValue)
    /*if let recognizers = webView.gestureRecognizers {
     for recognizer in recognizers {
     webView.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
     }
     }
     
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
     
     let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
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
    let  overlay_x_min : CGFloat = CGFloat((item["pos_x_min"] as! NSString).floatValue)
    let  overlay_y_min : CGFloat = CGFloat((item["pos_y_min"] as! NSString).floatValue)
    let  overlay_x_max : CGFloat = CGFloat((item["pos_x_max"] as! NSString).floatValue)
    let  overlay_y_max : CGFloat = CGFloat((item["pos_y_max"] as! NSString).floatValue)
    let  overlay_z_max : CGFloat = CGFloat((item["pos_z_pos"] as! NSString).floatValue)
    
    let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
    let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
    let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
    
    let xMinValue :CGFloat = (overlay_x_min * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
    let xMaxValue :CGFloat = (overlay_x_max * (player.displayView.contentOverlay.frame.size.width-(player.displayView.contentOverlay.frame.size.width-videoBounds.size.width))) / 100
    
    let yMinValue :CGFloat = (overlay_y_min * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
    let yMaxValue :CGFloat = (overlay_y_max * (player.displayView.contentOverlay.frame.size.height-(player.displayView.contentOverlay.frame.size.height-videoBounds.size.height))) / 100
    
    let  backgroundalpha :CGFloat = CGFloat((item["background_color_alpha"] as! NSString).floatValue)
    let  textalpha :CGFloat = CGFloat((item["text_color_alpha"] as! NSString).floatValue)
    
    let p1 = CGPoint(x: videoBounds.origin.x + xMinValue, y: videoBounds.origin.y + yMinValue)
    let p2 = CGPoint(x: videoBounds.origin.x + xMaxValue, y: videoBounds.origin.y  + yMaxValue)
    
    let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
    
    let xradians = xdegrees * .pi / 180
    let yradians = ydegrees * .pi / 180
    let zradians = zdegrees * .pi / 180
    let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
    let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
    var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            fontSize = 1.5*fontSize
        }
    if(player.displayView.isFullScreen == true){
    fontSize = fontSize*1.2
    }
    if( item["content_type"] as! String == "TEXT"){
    let text = item["content"] as! String
    DispatchQueue.main.async{
    
    let textLabel = UILabel()
    textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
    textLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //textLabel.alpha = backgroundalpha
    textLabel.font = UIFont(name: "Helvetica", size: fontSize)
    textLabel.textAlignment=NSTextAlignment.center
    textLabel.numberOfLines = 0
    textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha)
    textLabel.text = text
    if (xScale == 1.0 && yScale == 1.0 ){
    let oldFrame : CGRect = textLabel.frame
    textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
    textLabel.frame = oldFrame
    var rotationWithPerspective = CATransform3DIdentity;
    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
    textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
    }
    self.player!.displayView.contentOverlay.addSubview(textLabel)
    
    textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
    if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
    textLabel.transform = CGAffineTransform.identity
    //UIView.animate(withDuration: 0.25, animations: {
    textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
    //})
    }
    let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
    tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
    userImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    userImageBg.layer.zPosition = overlay_z_max
    //userImageBg.alpha = backgroundalpha
        userImageBg.image = self.selectedImage
    userImageBg.contentMode=UIViewContentMode.scaleAspectFill
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
    tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
    webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //webView.alpha = backgroundalpha
    //webView.backgroundColor = UIColor.clear
    //webView.backgroundColor?.withAlphaComponent(0)
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
    quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //quizBg.alpha = backgroundalpha
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
    tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
    tapGestureOnActionLabel.numberOfTouchesRequired = 1
    quizBg.isUserInteractionEnabled = true
    quizBg.addGestureRecognizer(tapGestureOnActionLabel)
    
    let questionString = item["content"] as! String
    let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
    
    let questionLabel = UILabel()
    questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
    questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
    questionLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha)
    //questionLabel.backgroundColor=UIColor.clear
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
    answer1Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
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
    answer2Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
    answer2Btn.backgroundColor=UIColor.clear
    answer2Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
    answer2Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
    answer2Btn.accessibilityLabel = "2"
    answer2Btn.layer.cornerRadius = 6.0
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
    answer3Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
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
    answer4Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
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
    let  overlay_x_min : CGFloat = CGFloat((item["pos_x_min"] as! NSString).floatValue)
    let  overlay_y_min : CGFloat = CGFloat((item["pos_y_min"] as! NSString).floatValue)
    let  overlay_x_max : CGFloat = CGFloat((item["pos_x_max"] as! NSString).floatValue)
    let  overlay_y_max : CGFloat = CGFloat((item["pos_y_max"] as! NSString).floatValue)
    let  overlay_z_max : CGFloat = CGFloat((item["pos_z_pos"] as! NSString).floatValue)
    
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
    let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
    let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
    var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
        if(UIDevice.current.userInterfaceIdiom == .pad){
            fontSize = 1.5*fontSize
        }
    if(player.displayView.isFullScreen == true){
    fontSize = fontSize*1.2
    }
    let  backgroundalpha :CGFloat = CGFloat((item["background_color_alpha"] as! NSString).floatValue)
    let  textalpha :CGFloat = CGFloat((item["text_color_alpha"] as! NSString).floatValue)
    
    if( item["content_type"] as! String == "TEXT"){
    let text = item["content"] as! String
    DispatchQueue.main.async{
    
    let textLabel = UILabel()
    textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
    textLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    textLabel.font = UIFont(name: "Helvetica", size: fontSize)
    textLabel.textAlignment=NSTextAlignment.center
    textLabel.numberOfLines = 0
    textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha)
    textLabel.text = text
    if (xScale == 1.0 && yScale == 1.0 ){
    let oldFrame : CGRect = textLabel.frame
    textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
    textLabel.frame = oldFrame
    var rotationWithPerspective = CATransform3DIdentity;
    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
    textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
    }
    self.player!.displayView.contentOverlay.addSubview(textLabel)
    
    textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
    if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
    textLabel.transform = CGAffineTransform.identity
    //UIView.animate(withDuration: 0.25, animations: {
    textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
    //})
    }
    let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
    tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
    userImageBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //userImageBg.alpha = backgroundalpha
    userImageBg.layer.zPosition = overlay_z_max
        userImageBg.image = self.selectedImage
    userImageBg.contentMode=UIViewContentMode.scaleAspectFill
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
    tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
    webView.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //webView.alpha = backgroundalpha
    //webView.backgroundColor = UIColor.clear
    //webView.backgroundColor?.withAlphaComponent(0)
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
    quizBg.backgroundColor = self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
    //quizBg.alpha = backgroundalpha
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
    tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
    tapGestureOnActionLabel.numberOfTouchesRequired = 1
    quizBg.isUserInteractionEnabled = true
    quizBg.addGestureRecognizer(tapGestureOnActionLabel)
    
    let questionString = item["content"] as! String
    let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
    
    let questionLabel = UILabel()
    questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
    questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
    questionLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha)
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
    answer1Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
    answer1Btn.backgroundColor=UIColor.clear
    answer1Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
    answer1Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
    answer1Btn.layer.cornerRadius = 6.0
    answer1Btn.layer.borderWidth = 1.0
    answer1Btn.layer.borderColor = UIColor.black.cgColor
    answer1Btn.accessibilityLabel = "1"
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
    answer2Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
    answer2Btn.backgroundColor=UIColor.clear
    answer2Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
    answer2Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
    answer2Btn.layer.cornerRadius = 6.0
    answer2Btn.layer.borderWidth = 1.0
    answer2Btn.accessibilityLabel = "2"
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
    answer3Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
    answer3Btn.backgroundColor=UIColor.clear
    answer3Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
    answer3Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
    answer3Btn.layer.cornerRadius = 6.0
    answer3Btn.layer.borderWidth = 1.0
    answer3Btn.accessibilityLabel = "3"
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
    answer4Btn.setTitleColor(self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha), for: UIControlState.normal)
    answer4Btn.backgroundColor=UIColor.clear
    answer4Btn.titleLabel?.font = UIFont(name: "Helvetica", size: fontSize) ?? UIFont()
    answer4Btn.tag = Int((item["overlay_id"] as! NSString).intValue)
    answer4Btn.layer.cornerRadius = 6.0
    answer4Btn.layer.borderWidth = 1.0
    answer4Btn.accessibilityLabel = "4"
    answer4Btn.layer.borderColor = UIColor.black.cgColor
    answer4Btn.addTarget(self, action:#selector(self.Quizclicked(sender:)), for: .touchUpInside)
    answer4Btn.titleLabel?.adjustsFontSizeToFitWidth = true
    quizBg.addSubview(answer4Btn)
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
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let scrollheight = CGFloat(Float(webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight")!) ?? 0.0)
        webView.scalesPageToFit = true
        webView.contentMode = UIViewContentMode.scaleAspectFit
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("WebvIew Error \(error.localizedDescription)")
    }
    func gestureRecognizer(_: UIGestureRecognizer,  shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool{
        return true
    }
    func gestureRecognizer(_: UIGestureRecognizer, shouldReceive:UITouch) -> Bool {
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
    func tangoPlayerView(_ playerView: TangoPlayerView, willFullscreen fullscreen: Bool,videoBoundsRect:CGRect,playercurrentTime: Int) {
        print("screen State ")
        let subViews: [UIView] = (player!.displayView.contentOverlay.subviews)
        for subview in subViews{
            subview.removeFromSuperview()
            /*UIView.animate(withDuration: 1, animations: {
                subview.alpha = 0
            }) { _ in
                subview.removeFromSuperview()
            }*/
        }
        //let  adsArray = sqLiteManager().find(nil, from: "IVPData", where: String(format:"(%d BETWEEN attr_start_time AND attr_end_time)",playercurrentTime))! as NSArray
        let dataSource = UserDefaults.standard.array(forKey: "personlizationArray")
        let predicate = NSPredicate(format: "%d >= attr_start_time AND %d <= attr_end_time", playercurrentTime,playercurrentTime)
        let adsArray = dataSource?.filter { predicate.evaluate(with: $0) } as! NSArray
        //print("adsArray %@ at time %@",adsArray,playercurrentTime);
        if (adsArray != nil){
            if(adsArray.count == 0){
                let subViews: [UIView] = (player!.displayView.contentOverlay.subviews)
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
                print("Item at the object %@",item)
                let subViews: [UIView] = (player!.displayView.contentOverlay.subviews)
                if(subViews.count>0){
                    let tag =  Int((item["overlay_id"] as! NSString).intValue)
                    if (player!.displayView.contentOverlay.viewWithTag(tag) != nil) {
                        print("Inside first One")
                        //let  startValue :Int = Int((item["attr_start_time"] as! NSString).intValue)
                        //let  endValue :Int = Int((item["attr_end_time"] as! NSString).intValue)
                        let  startValue :Int = Int(item["attr_start_time"] as! Int)
                        let  overlay_x_min : CGFloat = CGFloat((item["pos_x_min"] as! NSString).floatValue)
                        let  overlay_y_min : CGFloat = CGFloat((item["pos_y_min"] as! NSString).floatValue)
                        let  overlay_x_max : CGFloat = CGFloat((item["pos_x_max"] as! NSString).floatValue)
                        let  overlay_y_max : CGFloat = CGFloat((item["pos_y_max"] as! NSString).floatValue)
                        let  overlay_z_max : CGFloat = CGFloat((item["pos_z_pos"] as! NSString).floatValue)
                        
                        let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                        let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                        let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                        
                        let xMinValue :CGFloat = (overlay_x_min * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
                        let xMaxValue :CGFloat = (overlay_x_max * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
                        
                        let yMinValue :CGFloat = (overlay_y_min * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
                        let yMaxValue :CGFloat = (overlay_y_max * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
                        
                        let p1 = CGPoint(x: videoBoundsRect.origin.x + xMinValue, y: videoBoundsRect.origin.y + yMinValue)
                        let p2 = CGPoint(x: videoBoundsRect.origin.x + xMaxValue, y: videoBoundsRect.origin.y  + yMaxValue)
                        
                        let  backgroundalpha :CGFloat = CGFloat((item["background_color_alpha"] as! NSString).floatValue)
                        let  textalpha :CGFloat = CGFloat((item["text_color_alpha"] as! NSString).floatValue)
                        
                        let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                        
                        let xradians = xdegrees * .pi / 180
                        let yradians = ydegrees * .pi / 180
                        let zradians = zdegrees * .pi / 180
                        let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                        let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                        var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                        if(UIDevice.current.userInterfaceIdiom == .pad){
                            fontSize = 1.5*fontSize
                        }
                        if(player?.displayView.isFullScreen == true){
                            fontSize = fontSize*1.2
                        }
                        let viewWithTag = player!.displayView.contentOverlay.viewWithTag(tag)
                        if(viewWithTag?.isKind(of: UILabel.self))!{
                            let subLabel:UILabel =  player!.displayView.contentOverlay.viewWithTag(tag) as! UILabel
                            let text = item["content"] as! String
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                subLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            /*UIView.animate(withDuration: 0.5, animations: {
                             subLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             })*/
                            subLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
                            subLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            subLabel.textAlignment=NSTextAlignment.center
                            subLabel.numberOfLines = 0
                            print("Background clor %@",item["anim_background_colour"] as! String)
                            print("Background clor  with alphs %@",self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha))
                            subLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha)
                            subLabel.text = text
                            subLabel.layer.zPosition = overlay_z_max
                            subLabel.tag = startValue
                            if (xScale == 1.0 && yScale == 1.0 ){
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
                            let overlayImageBg:UIImageView =  player!.displayView.contentOverlay.viewWithTag(tag) as! UIImageView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                overlayImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            /*UIView.animate(withDuration: 0.5, animations: {
                             overlayImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                             })*/
                            overlayImageBg.clipsToBounds=true
                            overlayImageBg.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                            overlayImageBg.layer.zPosition = overlay_z_max
                            overlayImageBg.imageFromServerURL(urlString: item["content"] as! String)
                            overlayImageBg.alpha = backgroundalpha
                            overlayImageBg.image = selectedImage
                            overlayImageBg.contentMode=UIViewContentMode.scaleAspectFill
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
                            
                            let webView:UIWebView =  player!.displayView.contentOverlay.viewWithTag(tag) as! UIWebView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                webView.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            webView.isOpaque = false
                            webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                            webView.alpha = backgroundalpha
                            webView.scalesPageToFit = true
                            webView.contentMode = UIViewContentMode.scaleAspectFit
                            webView.isUserInteractionEnabled = true;
                            webView.layer.zPosition = overlay_z_max
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
                        }
                        if(viewWithTag?.isKind(of: UIView.self))!{
                            
                            let quizBg:UIView =  player!.displayView.contentOverlay.viewWithTag(tag) as! UIView
                            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                quizBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            }, completion: nil )
                            quizBg.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                quizBg.transform = CGAffineTransform.identity
                                quizBg.transform = quizBg.transform.scaledBy(x: xScale, y:yScale)
                            }
                            quizBg.layer.zPosition = overlay_z_max
                            if (xScale == 1 && yScale == 1 ){
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                                    quizBg.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }, completion: nil )
                            }
                            quizBg.tag =  Int((item["overlay_id"] as! NSString).intValue)
                            
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
                        let  overlay_x_min : CGFloat = CGFloat((item["pos_x_min"] as! NSString).floatValue)
                        let  overlay_y_min : CGFloat = CGFloat((item["pos_y_min"] as! NSString).floatValue)
                        let  overlay_x_max : CGFloat = CGFloat((item["pos_x_max"] as! NSString).floatValue)
                        let  overlay_y_max : CGFloat = CGFloat((item["pos_y_max"] as! NSString).floatValue)
                        let  overlay_z_max : CGFloat = CGFloat((item["pos_z_pos"] as! NSString).floatValue)
                        
                        let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                        let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                        let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                        
                        let xMinValue :CGFloat = (overlay_x_min * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
                        let xMaxValue :CGFloat = (overlay_x_max * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
                        
                        let yMinValue :CGFloat = (overlay_y_min * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
                        let yMaxValue :CGFloat = (overlay_y_max * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
                        
                        let p1 = CGPoint(x: videoBoundsRect.origin.x + xMinValue, y: videoBoundsRect.origin.y + yMinValue)
                        let p2 = CGPoint(x: videoBoundsRect.origin.x + xMaxValue, y: videoBoundsRect.origin.y  + yMaxValue)
                        
                        let  backgroundalpha :CGFloat = CGFloat((item["background_color_alpha"] as! NSString).floatValue)
                        let  textalpha :CGFloat = CGFloat((item["text_color_alpha"] as! NSString).floatValue)
                        
                        let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                        
                        let xradians = xdegrees * .pi / 180
                        let yradians = ydegrees * .pi / 180
                        let zradians = zdegrees * .pi / 180
                        let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                        let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                        var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                        if(UIDevice.current.userInterfaceIdiom == .pad){
                            fontSize = 1.5*fontSize
                        }
                        if(player?.displayView.isFullScreen == true){
                            fontSize = fontSize*1.2
                        }
                        if( item["content_type"] as! String == "TEXT"){
                            let text = item["content"] as! String
                            DispatchQueue.main.async{
                                
                                let textLabel = UILabel()
                                textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                                textLabel.backgroundColor=self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                                textLabel.font = UIFont(name: "Helvetica", size: fontSize)
                                textLabel.textAlignment=NSTextAlignment.center
                                textLabel.numberOfLines = 0
                                textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha)
                                textLabel.text = text
                                //textLabel.alpha = backgroundalpha
                                textLabel.layer.zPosition = overlay_z_max
                                if (xScale == 1.0 && yScale == 1.0 ){
                                    let oldFrame : CGRect = textLabel.frame
                                    textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                    textLabel.frame = oldFrame
                                    var rotationWithPerspective = CATransform3DIdentity;
                                    rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                    textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                                }
                                self.player!.displayView.contentOverlay.addSubview(textLabel)
                                
                                textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                                if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                    textLabel.transform = CGAffineTransform.identity
                                    //UIView.animate(withDuration: 0.25, animations: {
                                    textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
                                    //})
                                }
                                let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                                tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
                                userImageBg.layer.zPosition = overlay_z_max
                                userImageBg.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                                userImageBg.alpha = backgroundalpha
                                userImageBg.image = self.selectedImage
                                userImageBg.contentMode=UIViewContentMode.scaleAspectFill
                                self.player!.displayView.contentOverlay.addSubview(userImageBg)
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
                                tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
                                webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                                self.player!.displayView.contentOverlay.addSubview(webView)
                                let url = URL(string: item["content"] as! String)
                                let request = URLRequest(url: url!)
                                webView.scalesPageToFit = true
                                webView.contentMode = UIViewContentMode.scaleAspectFit
                                webView.isUserInteractionEnabled = true;
                                webView.layer.zPosition = overlay_z_max
                                webView.loadRequest(request)
                                webView.alpha = backgroundalpha
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
                                quizBg.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                                quizBg.layer.zPosition = overlay_z_max
                                quizBg.alpha = backgroundalpha
                                self.player!.displayView.contentOverlay.addSubview(quizBg)
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
                                tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
                                tapGestureOnActionLabel.numberOfTouchesRequired = 1
                                quizBg.isUserInteractionEnabled = true
                                quizBg.addGestureRecognizer(tapGestureOnActionLabel)
                                
                                let questionString = item["content"] as! String
                                let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
                                
                                let questionLabel = UILabel()
                                questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
                                questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
                                questionLabel.textColor=self.hexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String))
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
                    let  overlay_x_min : CGFloat = CGFloat((item["pos_x_min"] as! NSString).floatValue)
                    let  overlay_y_min : CGFloat = CGFloat((item["pos_y_min"] as! NSString).floatValue)
                    let  overlay_x_max : CGFloat = CGFloat((item["pos_x_max"] as! NSString).floatValue)
                    let  overlay_y_max : CGFloat = CGFloat((item["pos_y_max"] as! NSString).floatValue)
                    let  overlay_z_max : CGFloat = CGFloat((item["pos_z_pos"] as! NSString).floatValue)
                    
                    let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
                    let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
                    let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
                    
                    let xMinValue :CGFloat = (overlay_x_min * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
                    let xMaxValue :CGFloat = (overlay_x_max * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
                    
                    let yMinValue :CGFloat = (overlay_y_min * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
                    let yMaxValue :CGFloat = (overlay_y_max * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
                    
                    let p1 = CGPoint(x: videoBoundsRect.origin.x + xMinValue, y: videoBoundsRect.origin.y + yMinValue)
                    let p2 = CGPoint(x: videoBoundsRect.origin.x + xMaxValue, y: videoBoundsRect.origin.y  + yMaxValue)
                    
                    let  backgroundalpha :CGFloat = CGFloat((item["background_color_alpha"] as! NSString).floatValue)
                    let  textalpha :CGFloat = CGFloat((item["text_color_alpha"] as! NSString).floatValue)
                    
                    let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
                    
                    let xradians = xdegrees * .pi / 180
                    let yradians = ydegrees * .pi / 180
                    let zradians = zdegrees * .pi / 180
                    let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
                    let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
                    var  fontSize :CGFloat = CGFloat((item["content_text_size_multiplier"] as! NSString).floatValue)
                    if(UIDevice.current.userInterfaceIdiom == .pad){
                        fontSize = 1.5*fontSize
                    }
                    if(player?.displayView.isFullScreen == true){
                        fontSize = fontSize*1.2
                    }
                    if( item["content_type"] as! String == "TEXT"){
                        let text = item["content"] as! String
                        DispatchQueue.main.async{
                            
                            let textLabel = UILabel()
                            textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
                            textLabel.backgroundColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String), alpha:backgroundalpha)
                            textLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            textLabel.textAlignment=NSTextAlignment.center
                            textLabel.numberOfLines = 0
                            textLabel.textColor=self.sixDigitHexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String), alpha:textalpha)
                            textLabel.text = text
                            //textLabel.alpha = backgroundalpha
                            textLabel.layer.zPosition = overlay_z_max
                            if (xScale == 1.0 && yScale == 1.0 ){
                                let oldFrame : CGRect = textLabel.frame
                                textLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
                                textLabel.frame = oldFrame
                                var rotationWithPerspective = CATransform3DIdentity;
                                rotationWithPerspective.m34 = 1.0/500.0 ///2/2
                                textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
                            }
                            self.player!.displayView.contentOverlay.addSubview(textLabel)
                            
                            textLabel.tag = Int((item["overlay_id"] as! NSString).intValue)
                            if (xdegrees == 0 && ydegrees == 0 && zdegrees == 0 ){
                                textLabel.transform = CGAffineTransform.identity
                                //UIView.animate(withDuration: 0.25, animations: {
                                textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale)
                                //})
                            }
                            let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
                            tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
                            userImageBg.layer.zPosition = overlay_z_max
                            userImageBg.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                            userImageBg.alpha = backgroundalpha
                            userImageBg.image = self.selectedImage
                            userImageBg.contentMode=UIViewContentMode.scaleAspectFill
                            self.player!.displayView.contentOverlay.addSubview(userImageBg)
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
                            tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
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
                            webView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                            webView.alpha = backgroundalpha
                            webView.layer.zPosition = overlay_z_max
                            self.player!.displayView.contentOverlay.addSubview(webView)
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
                            quizBg.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",item["anim_background_colour"] as! String))
                            quizBg.alpha = backgroundalpha
                            quizBg.layer.zPosition = overlay_z_max
                            self.player!.displayView.contentOverlay.addSubview(quizBg)
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
                            tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
                            tapGestureOnActionLabel.numberOfTouchesRequired = 1
                            quizBg.isUserInteractionEnabled = true
                            quizBg.addGestureRecognizer(tapGestureOnActionLabel)
                            
                            let questionString = item["content"] as! String
                            let parsedQuestion = questionString.slice(from: "$_QS_$", to: "$_QS_$")
                            
                            let questionLabel = UILabel()
                            questionLabel.frame=CGRect(x:10, y: 5, width:quizBg.frame.size.width-20, height: (quizBg.frame.size.height/2)-10)
                            questionLabel.font = UIFont(name: "Helvetica", size: fontSize)
                            questionLabel.textColor=self.hexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String))
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
            var subViews: [UIView] = (player!.displayView.contentOverlay.subviews)
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
            let subViews: [UIView] = (player!.displayView.contentOverlay.subviews)
            for subview in subViews{
                UIView.animate(withDuration: 1, animations: {
                    subview.alpha = 0
                }) { _ in
                    subview.removeFromSuperview()
                }
            }
        }
        /*
         let adsArray = sqLiteManager().findAll(from:"IVPData")
         if(adsArray != nil) {
         let subViews: [UIView] = (player!.displayView.contentOverlay.subviews)
         for subview in subViews{
         UIView.animate(withDuration: 1, animations: {
         subview.alpha = 0
         }) { _ in
         subview.removeFromSuperview()
         }
         }
         let sortedArray  = NSMutableArray()
         for i in 0..<adsArray!.count {
         let item = adsArray![i] as! NSDictionary
         let  startValue :Int = Int((item["attr_start_time"] as! NSString).intValue)
         let  endValue :Int = Int((item["attr_end_time"] as! NSString).intValue)
         if ((Int(timeString) >= startValue) && (Int(timeString) <= endValue)){
         sortedArray.add(adsArray![i])
         }
         print("sortedArray %@",sortedArray)
         let subViews: [UIView] = (player!.displayView.contentOverlay.subviews)
         for subview in subViews{
         UIView.animate(withDuration: 1, animations: {
         subview.alpha = 0
         }) { _ in
         subview.removeFromSuperview()
         }
         }
         for i in 0..<sortedArray.count {
         let innerObject = sortedArray[i] as! NSDictionary
         
         let  startValue :Int = Int((innerObject["attr_start_time"] as! NSString).intValue)
         let  endValue :Int = Int((innerObject["attr_end_time"] as! NSString).intValue)
         
         let  overlay_x_min : CGFloat = CGFloat((innerObject["pos_x_min"] as! NSString).floatValue)
         let  overlay_y_min : CGFloat = CGFloat((innerObject["pos_y_min"] as! NSString).floatValue)
         let  overlay_x_max : CGFloat = CGFloat((innerObject["pos_x_max"] as! NSString).floatValue)
         let  overlay_y_max : CGFloat = CGFloat((innerObject["pos_y_max"] as! NSString).floatValue)
         //let  delayValue    : CGFloat = innerObject["character_delay"] as! CGFloat
         //let fontSize       : CGFloat = innerObject["font_size"] as! CGFloat
         //let degrees        : CGFloat = innerObject["rotate_angle_y"] as! CGFloat
         //let idValue        : Int = Int(innerObject["id"] as! String)!
         
         let  xdegrees :CGFloat = CGFloat((item["anim_rotate_angle_x"] as! NSString).floatValue)
         let  ydegrees :CGFloat = CGFloat((item["anim_rotate_angle_y"] as! NSString).floatValue)
         let  zdegrees :CGFloat = CGFloat((item["anim_rotate_angle_z"] as! NSString).floatValue)
         
         let xMinValue :CGFloat = (overlay_x_min * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
         let xMaxValue :CGFloat = (overlay_x_max * (player!.displayView.contentOverlay.frame.size.width-(player!.displayView.contentOverlay.frame.size.width-videoBoundsRect.size.width))) / 100
         
         let yMinValue :CGFloat = (overlay_y_min * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
         let yMaxValue :CGFloat = (overlay_y_max * (player!.displayView.contentOverlay.frame.size.height-(player!.displayView.contentOverlay.frame.size.height-videoBoundsRect.size.height))) / 100
         
         let p1 = CGPoint(x: videoBoundsRect.origin.x + xMinValue, y: videoBoundsRect.origin.y + yMinValue)
         let p2 = CGPoint(x: videoBoundsRect.origin.x + xMaxValue, y: videoBoundsRect.origin.y  + yMaxValue)
         
         let r = CGRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
         
         let xradians = xdegrees * .pi / 180
         let yradians = ydegrees * .pi / 180
         let zradians = zdegrees * .pi / 180
         let  xScale :CGFloat = CGFloat((item["anim_scale_factor_x"] as! NSString).floatValue)
         let  yScale :CGFloat = CGFloat((item["anim_scale_factor_y"] as! NSString).floatValue)
         
         if( innerObject["content_type"] as! String == "TEXT"){
         let text = innerObject["content"] as! String
         DispatchQueue.main.async{
         let textLabel = UILabel()
         textLabel.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
         //textLabel.backgroundColor=self.hexStringToUIColor(hex: String(format:"%@",innerObject["background_color"] as! String))
         textLabel.backgroundColor=UIColor.green
         textLabel.font = UIFont(name: "HelveticaNeue", size: 10)
         textLabel.text = innerObject["content"] as? String
         textLabel.textAlignment=NSTextAlignment.center
         textLabel.numberOfLines = 0
         textLabel.textColor=self.hexStringToUIColor(hex: String(format:"%@",item["content_text_colour"] as! String))
         textLabel.text = text
         textLabel.tag = startValue
         self.player!.displayView.contentOverlay.addSubview(textLabel)
         if (xScale == 1 && yScale == 1 ){
         var rotationWithPerspective = CATransform3DIdentity;
         rotationWithPerspective.m34 = 1.0/500.0 ///2/2
         textLabel.layer.transform = CATransform3DRotate(CATransform3DRotate(CATransform3DRotate(rotationWithPerspective, CGFloat(xradians), 1, 0, 0), CGFloat(yradians), 0, 1, 0), CGFloat(zradians), 0, 0, 1);
         }
         if (xdegrees != 0 && ydegrees != 0 && zdegrees != 0 ){
         textLabel.transform = CGAffineTransform.identity
         UIView.animate(withDuration: 0.25, animations: {
         textLabel.transform = textLabel.transform.scaledBy(x: xScale, y:yScale) //CGAffineTransform(scaleX: CGFloat(xScale), y: CGFloat(yScale))
         })
         }
         textLabel.tag = Int(innerObject["id"] as! String)!
         let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
         tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
         tapGestureOnActionLabel.numberOfTouchesRequired = 1
         textLabel.isUserInteractionEnabled = true
         textLabel.addGestureRecognizer(tapGestureOnActionLabel)
         }
         }
         if (innerObject["content_type"] as! String == "IMAGE"){
         DispatchQueue.main.async{
         let userImageBg = UIImageView()
         userImageBg.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
         userImageBg.clipsToBounds=true
         userImageBg.tag = startValue
         //userImageBg.image = self.selectedImage
         userImageBg.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",innerObject["background_color"] as! String))
         userImageBg.backgroundColor = UIColor.clear
         userImageBg.contentMode=UIViewContentMode.scaleAspectFill
         self.player!.displayView.contentOverlay.addSubview(userImageBg)
         if (xdegrees != 0 && ydegrees != 0 && zdegrees != 0 ){
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
         userImageBg.tag = Int(innerObject["id"] as! String)!
         let tapGestureOnActionLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelAction))
         tapGestureOnActionLabel.delegate = self as? UIGestureRecognizerDelegate
         tapGestureOnActionLabel.numberOfTouchesRequired = 1
         userImageBg.isUserInteractionEnabled = true
         userImageBg.addGestureRecognizer(tapGestureOnActionLabel)
         }
         }
         if (innerObject["content_type"] as! String == "ALPHA"){
         DispatchQueue.main.async{
         let alphaValue        :CGFloat = innerObject["alpha"] as! CGFloat
         let alphaView = UIView()
         alphaView.frame=CGRect(x:r.origin.x, y: r.origin.y, width:r.size.width, height: r.size.height)
         alphaView.backgroundColor = self.hexStringToUIColor(hex: String(format:"%@",innerObject["background_color"] as! String))
         alphaView.alpha = alphaValue
         alphaView.tag = startValue
         self.player!.displayView.contentOverlay.addSubview(alphaView)
         }
         }
         }
         }
         }*/
    }
    func tangoPlayerView(didTappedClose playerView: TangoPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func tangoPlayerView(didTouched playerView: TangoPlayerView, videoBoundsRect: CGRect,xPercentage:Float,yPercentage:Float,frameImage:UIImage,playercurrentTime:Int) {
        print("xFPercentage %f",xPercentage)
        print("yFPercentage %f",yPercentage)
        print("playercurrentTime %d",playercurrentTime)
        textLabel.text = String(format:"Xpercentage = %f \n Ypercentage = %f",xPercentage,yPercentage)
        //print("Jabong Array %@",UserDefaults.standard.value(forKey: "jabongarray"))
        var result = NSArray()
        //result = sqLiteManager().findAll(from: "AdsData")! as NSArray
        //result = sqLiteManager().find(nil, from: "IVPData", where: String(format:"(%f BETWEEN pos_x_min AND pos_x_max) AND (%f BETWEEN pos_y_min AND pos_y_max) AND (attr_start_time BETWEEN %d AND %d)",xPercentage,yPercentage,playercurrentTime-500,playercurrentTime+500))! as NSArray
        print("Jabong Array %@",result)
        if(result.count>0){
            let item = result[0] as! NSDictionary
            if (item["action_type"] as! String == "ON_CLICK") {
                if(Int((item["pause_on_action"] as! NSString).intValue) == 1){
                    player?.pause()
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
                        //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                        //let combinedValues = actionValue.components(separatedBy: "Weblink:")
                        //UIApplication.shared.openURL(URL(string: combinedValues[1] as String)!)
                    }
                    if (sepratedValues[0] == "sms") {
                        let dict = [
                            "ad_id" : item["id"],
                            "cta_type" : "sms",
                            "responded" : "true"
                        ]
                        //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                        
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
                        //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                        let phoneUrl = URL(string: "telprompt:\(sepratedValues[1])")
                        UIApplication.shared.openURL(phoneUrl!)
                    }
                    if (sepratedValues[0] == "email") {
                        let dict = [
                            "ad_id" : item["id"],
                            "cta_type" : "email",
                            "responded" : "true"
                        ]
                        //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
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
                            self.present(composeVC, animated: true, completion: nil)
                        }
                    }
                    if (sepratedValues[0] == "video") {
                    }
                    if (sepratedValues[0] == "skip") {
                        let  skipTime : CGFloat = CGFloat((sepratedValues[1] as NSString).floatValue)
                        let timeToAdd: CMTime = CMTimeMakeWithSeconds(Float64(skipTime/1000.0), 1)
                        let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds((player?.currentDuration)!, 1000000), timeToAdd)
                        //queuePlayer.seek(to: resultTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                        player?.playerItem?.seek(to: timeToAdd, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                    }
                }
            }
        }
    }
    func tangoPlayerView(didDisplayControl playerView: TangoPlayerView) {
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
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainController: UIViewController? = keyWindow?.rootViewController
        mainController?.dismiss(animated: true, completion: nil)
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
        /*let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))*/
        
        /*var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return UIColor(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: CGFloat(alpha))*/
    }
    @objc func Quizclicked(sender : UIButton){
        print("Quizclicked %@",sender.titleLabel?.text)
        print("Quizclicked Tag %d",sender.tag)
        let viewWithTag = player!.displayView.contentOverlay.viewWithTag(sender.tag)
        if(viewWithTag?.isKind(of: UIView.self))!{
            let quizBg:UIView =  player!.displayView.contentOverlay.viewWithTag(sender.tag) as! UIView
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
                    if sender.accessibilityLabel == parsedAnswer{
                        ansString = "true"
                        sender.backgroundColor = UIColor.green
                    }
                    else{
                        ansString = "false"
                        sender.backgroundColor = UIColor.red
                    }
                    sender.isSelected =  true;
                    let tmpButton = self.view.viewWithTag(sender.tag) as? UIButton
                    print("Buuton Actions %@",tmpButton)
                    tmpButton?.removeTarget(nil, action: nil, for: .allEvents)
                    /*let dict = [
                     "ad_id" : item["id"],
                     "cta_type" : item["ad_feed_calltoaction_type"],
                     "responded" : "true",
                     "question" : item["ad_feed_overlay_quiz_question"],
                     "answer" : item["ad_feed_overlay_quiz_correct_answer"],
                     "program_id" : singleProgramDetailObj.program_id,
                     "program_name" : singleProgramDetailObj.name,
                     "answered_correctly" : ansString
                     ]
                     TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])*/
                    /*var subViews: [UIView] = (player?.displayView.contentOverlay.subviews)!
                     print("Remove Tag Value %@",sender.tag)
                     for k in 0..<subViews.count {
                     let views = subViews[k]
                     //let viewWithTag = views.viewWithTag(sender.tag)
                     if let viewWithTag = views.viewWithTag(sender.tag) {
                     viewWithTag.removeFromSuperview()
                     }
                     //let existingPredicate = NSPredicate(format: "overlay_id == %@",String(format:"%d",overlaytag))
                     //let removalArray = adsArray.filter { existingPredicate.evaluate(with: $0) } as! NSArray
                     //print("removalArray List %@",removalArray)
                     
                     /* UIView.animate(withDuration: 1, animations: {
                     viewWithTag?.alpha = 0
                     }) { _ in
                     viewWithTag?.removeFromSuperview()
                     }*/
                     }*/
                }
            }
        }
    }
    @objc func labelAction(sender:UITapGestureRecognizer){
        let view = sender.view!.tag
        print("view %@",view)
        var result = NSArray()
        let dataSource = UserDefaults.standard.array(forKey: "personlizationArray")
        if (dataSource!.count > 0){
            let existingPredicate = NSPredicate(format: "overlay_id == %@",String(format:"%d",view))
            result = dataSource!.filter { existingPredicate.evaluate(with: $0) } as! NSArray
            print("Jabong Array %@",result)
            if(result.count>0){
                let item = result[0] as! NSDictionary
                if (item["action_type"] as! String == "ON_CLICK") {
                    if(Int((item["pause_on_action"] as! NSString).intValue) == 1){
                        player?.pause()
                    }
                    let actionValue = item["action"] as! String
                    var sepratedValues = actionValue.components(separatedBy: "://")
                    print("sepratedValues %@",sepratedValues);
                    if(sepratedValues.count>0){
                        if (sepratedValues[0] == "weblink") {
                            let dict = [
                                "ad_id" : item["id"],
                                "cta_type" : "weblink",
                                "responded" : "true"
                            ]
                            //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                            let combinedValues = actionValue.components(separatedBy: "weblink://")
                            UIApplication.shared.openURL(URL(string: combinedValues[1] as String)!)
                        }
                        if (sepratedValues[0] == "sms") {
                            let dict = [
                                "ad_id" : item["id"],
                                "cta_type" : "sms",
                                "responded" : "true"
                            ]
                            //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
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
                            let dict = [
                                "ad_id" : item["id"],
                                "cta_type" : "tel",
                                "responded" : "true"
                            ]
                            //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
                            let phoneUrl = URL(string: "telprompt:\(sepratedValues[1])")
                            UIApplication.shared.openURL(phoneUrl!)
                        }
                        if (sepratedValues[0] == "email") {
                            let dict = [
                                "ad_id" : item["id"],
                                "cta_type" : "email",
                                "responded" : "true"
                            ]
                            //TTPWebserviceHelper().postAddevents(OVERLAY_ADS, withparameters: dict as [AnyHashable : Any])
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
                                self.present(composeVC, animated: true, completion: nil)
                            }
                        }
                        if (sepratedValues[0] == "video") {
                            let actionValue = item["action"] as! String
                            var sepratedValues = actionValue.components(separatedBy: "://")
                            print("sepratedValues %@",sepratedValues);
                            let combinedValues = sepratedValues[1].components(separatedBy:"/")
                            if(sepratedValues.count>0){
                                /*TeletangoPlayer.videoDetail(contentId:combinedValues[0]){ (result: ([String:AnyObject])) in
                                    print("Video Details %@",result);
                                    let details = result as! NSDictionary
                                    let insideDetails = details["program"] as! NSDictionary
                                    print("Video Details %@",insideDetails["recorded_video"])
                                    let videoURL = URL(string: insideDetails["recorded_video"] as! String)
                                    if videoURL != nil {
                                        self.player?.replaceVideo(videoURL!)
                                        //let timeToAdd: CMTime = CMTimeMakeWithSeconds(1, 1)
                                        if(combinedValues.count>1){
                                            //self.reloadMainVideoPersonalization()
                                            let  skipTime : CGFloat = CGFloat((combinedValues[1] as NSString).floatValue)
                                            let timeToAdd: CMTime = CMTimeMakeWithSeconds(Float64(skipTime/1000), 1)
                                            //let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds((self.player?.currentDuration)!, 1000000), timeToAdd)
                                            self.player?.playerItem?.seek(to: timeToAdd, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                                        }
                                        self.player?.play()
                                    }
                                }*/
                            }
                        }
                        if (sepratedValues[0] == "skip") {
                            let  skipTime : CGFloat = CGFloat((sepratedValues[1] as NSString).floatValue)
                            let timeToAdd: CMTime = CMTimeMakeWithSeconds(Float64(skipTime/1000.0), 1)
                            //let resultTime: CMTime = CMTimeAdd(CMTimeMakeWithSeconds((player?.currentDuration)!, 1000000), timeToAdd)
                            //queuePlayer.seek(to: resultTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                            player?.playerItem?.seek(to: timeToAdd, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                        }
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
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
