//
//  AppDelegate.swift
//  PersonalizedVideo
//
//  Created by Nagaraju Surisetty on 11/11/17.
//  Copyright © 2017 PrimeFocus Technologies. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var  isFullScreen : Bool = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*var jsonArray = NSArray()
        do {
            if let file = Bundle.main.url(forResource: "kotak_json", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                 if let object = json as? [String: Any] {
                    // json is an array
                    jsonArray = object["list"] as! NSArray
                    if(jsonArray != nil ){
                        //UserDefaults.standard.set(jsonArray, forKey: "filterArray")
                        self.getPersonalizationData(dataArray: object["list"] as! NSArray)
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }*/
        //print("jsonArray %@",jsonArray)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
        }catch {
            print(error)
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        UserDefaults.standard.set("DEV", forKey: "AppName")
        UserDefaults.standard.setValue("http://incdev.teletango.com/ApptarixTV", forKey: "ServerUrl")
        UserDefaults.standard.setValue("http://incdev-appta.teletango.com:8080/appta", forKey: "ApptaUrl")
        
        let rootViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.isNavigationBarHidden = true // or not, your choice.
        // self.window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navigationController
        
        return true
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
            if item["pos_x_min"] == nil || (item["pos_x_min"] is NSNull) {
                tempDict["pos_x_min"] = ""
            }
            else {
                let upadted : Float = Float(3.0)*Float(i)
                let xmin : Float = Float(Float(item["pos_x_min"] as! Float)+upadted)
                //                if(i==0){
                tempDict["pos_x_min"] = String(describing: item["pos_x_min"]!)
                //                }
                //               else{
                //                tempDict["pos_x_min"] = String(describing: xmin)
                //                }
            }
            if item["pos_x_max"] == nil || (item["pos_x_max"] is NSNull){
                tempDict["pos_x_max"] = ""
            }
            else {
                //                let upadted : Float = Float(3.0)*Float(i)
                //                let xmax : Float = Float(Float(item["pos_x_max"] as! Float)+upadted)
                //                if(i==0){
                tempDict["pos_x_max"] = String(describing: item["pos_x_max"]!)
                //                }
                //                else{
                //                tempDict["pos_x_max"] = String(describing: xmax)
                //                }
            }
            if item["pos_y_min"] == nil || (item["pos_y_min"] is NSNull) {
                tempDict["pos_y_min"] = ""
            }
            else {
                //                //tempDict["pos_y_min"] = String(describing: item["pos_y_min"]!)
                //                let upadted : Float = Float(3.0)*Float(i)
                //                let ymin : Float = Float(Float(item["pos_y_min"] as! Float)-upadted)
                //                if(i==0){
                tempDict["pos_y_min"] = String(describing: item["pos_y_min"]!)
                //                }
                //                else{
                //                    tempDict["pos_y_min"] = String(describing: ymin)
                //                }
            }
            if item["pos_y_max"] == nil || (item["pos_y_max"] is NSNull) {
                tempDict["pos_y_max"] = ""
            }
            else {
                let upadted : Float = Float(3.0)*Float(i)
                //tempDict["pos_y_max"] = String(describing: item["pos_y_max"]!)
                //                let ymax : Float = Float(Float(item["pos_y_max"] as! Float)-upadted)
                //                if(i==0){
                tempDict["pos_y_max"] = String(describing: item["pos_y_max"]!)
                //                }
                //                else{
                //                    tempDict["pos_y_max"] = String(describing: ymax)
                //                }
            }
            if item["pos_z_pos"] == nil || (item["pos_z_pos"] is NSNull) {
                tempDict["pos_z_pos"] = ""
            }
            else {
                tempDict["pos_z_pos"] = String(describing: item["pos_z_pos"]!)
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
            if item["anim_background_colour"] == nil || (item["anim_background_colour"] is NSNull) {
                tempDict["anim_background_colour"] = ""
            }
            else {
                tempDict["anim_background_colour"] = String(describing: item["anim_background_colour"]!)
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
            if item["content_text_colour"] == nil || (item["content_text_colour"] is NSNull) {
                tempDict["content_text_colour"] = ""
            }
            else {
                tempDict["content_text_colour"] = String(describing: item["content_text_colour"]!)
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
            if item["background_color_alpha"] == nil || (item["background_color_alpha"] is NSNull) {
                tempDict["background_color_alpha"] = ""
            }
            else {
                tempDict["background_color_alpha"] = String(describing: item["background_color_alpha"]!)
            }
            if item["text_color_alpha"] == nil || (item["text_color_alpha"] is NSNull) {
                tempDict["text_color_alpha"] = ""
            }
            else {
                tempDict["text_color_alpha"] = String(describing: item["text_color_alpha"]!)
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
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if(UIDevice.current.userInterfaceIdiom == .pad){
            return .landscapeRight
        }
        else{
            if isFullScreen {
                return .landscape
            }
            else {
                return .portrait
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
func appDelegate() -> AppDelegate {
    return (UIApplication.shared.delegate as? AppDelegate) ?? AppDelegate()
}
