//
//  TangoPlayerSubTitle.swift
//  TTPlayerDemo
//
//  Created by Nagaraju Surisetty on 01/12/17.
//  Copyright © 2017 Nagaraju Surisetty. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TangoPlayerSubTitle: UIView,UITableViewDataSource,UITableViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var blurEffectView                  : UIVisualEffectView!
    var tracksListingTV                 : UITableView!
    var audioList                       =  NSMutableArray()
    var subtitleList                    =  NSMutableArray()
    var tempAudioName                   = NSString()
    var temptitleName                   = NSString()
    typealias CallBack = () -> Void
    var callBack:CallBack?
    typealias CustomCallBack = (Any,Int) -> Void
    var customCallBack:CustomCallBack?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        print("Width %f",self.frame.width)
        let headerBg = UIView()
        headerBg.frame = CGRect(x: 0, y: 0, width:self.frame.width, height:64)
        headerBg.backgroundColor=UIColor.black
        self.addSubview(headerBg)
        
        /*headerBg.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.height.equalTo(64)
            make.width.equalTo(strongSelf)
        }*/
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.frame
        self.insertSubview(blurEffectView, at: 0)
        
        tracksListingTV = UITableView()
        tracksListingTV.backgroundColor = UIColor.clear
        tracksListingTV.delegate=self
        tracksListingTV.dataSource=self
        tracksListingTV.separatorColor=UIColor.lightGray
        tracksListingTV.tableFooterView = UIView()
        //self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        tracksListingTV.frame = CGRect(x: 0, y: 64, width:frame.size.width, height:frame.size.height-64)
        self.addSubview(tracksListingTV)
        
        /*tracksListingTV.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(64)
            make.width.equalTo(strongSelf)
        }*/
        
        /*var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
         blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame =  tracksListingTV.bounds
         blurEffectView.alpha=0.7;
         blurEffectView.layer.cornerRadius = 8
         blurEffectView.clipsToBounds = true
         tracksListingTV.addSubview(blurEffectView)*/
        
        let viewLabel = UILabel()
        viewLabel.frame=CGRect(x:0, y: 20, width:headerBg.frame.size.width, height: 44)
        viewLabel.backgroundColor=UIColor.clear
        viewLabel.text = "Audio & Subtitles"
        viewLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        viewLabel.textColor=UIColor.white
        viewLabel.textAlignment = NSTextAlignment.center
        headerBg.addSubview(viewLabel)
        /*viewLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(20)
            make.height.equalTo(44)
            make.width.equalTo(strongSelf)
        }*/
        
        let doneBtn = UIButton(type: UIButtonType.custom)
        doneBtn.backgroundColor             =  UIColor.clear
        doneBtn.frame=CGRect(x:self.frame.size.width-80, y: 20, width:60, height: 44)
        doneBtn.setTitle(String(format:"Done"), for: .normal)
        doneBtn.setTitleColor(UIColor.white, for: .normal)
        doneBtn.titleLabel?.font             =  UIFont(name: "HelveticaNeue-Medium", size: 16)
        doneBtn.layer.masksToBounds          = true
        doneBtn.sizeToFit()
        doneBtn.addTarget(self, action:#selector(self.backBtnClicked), for: .touchUpInside)
        headerBg.addSubview(doneBtn)
        /*doneBtn.snp.makeConstraints {(make) in
            make.top.equalTo(20)
            make.height.equalTo(44)
            make.width.equalTo(60)
            make.right.equalTo(-20)
        }*/
        tempAudioName = UserDefaults.standard.value(forKey: "DefaultAudioTrack") as! NSString
        temptitleName = UserDefaults.standard.value(forKey: "DefaultTitleTrack") as! NSString
    }
    //MARK:*************** Tableview Delegates and DataSources **********************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return audioList.count
        }
        else{
            return subtitleList.count + 1 ;
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewBg = UIView()
        viewBg.frame = CGRect(x: 0, y: 0, width:self.frame.size.width, height: 50)
        viewBg.backgroundColor=UIColor.clear
        
        let titleLabel = UILabel()
        titleLabel.frame=CGRect(x:15, y: 0, width:viewBg.frame.size.width-30, height: 50)
        titleLabel.backgroundColor=UIColor.clear
        if section == 0 {
            titleLabel.text = "Audio"
        }
        if section == 1 {
            titleLabel.text = "Subtitles"
        }
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        titleLabel.textColor=UIColor.white
        titleLabel.textAlignment = NSTextAlignment.left
        viewBg.addSubview(titleLabel)
        
        return viewBg
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MyMoreCell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor=UIColor.clear
        let subViews = cell.contentView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let viewBg = UIView()
        viewBg.frame = CGRect(x: 0, y: 0, width:self.frame.size.width, height: 50)
        viewBg.backgroundColor=UIColor.black
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        let titleLabel = UILabel()
        titleLabel.frame=CGRect(x:15, y: 5, width:viewBg.frame.size.width-30, height: 50)
        titleLabel.backgroundColor=UIColor.clear
        if indexPath.section == 0 {
            let item  = audioList[indexPath.row] as! AVMediaSelectionOption
            titleLabel.text = item.displayName
            if(tempAudioName as String == item.displayName){
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
        }
        if indexPath.section == 1 {
            if(indexPath.row==0){
              titleLabel.text = "Off"
                if(temptitleName as String == "Off"){
                    cell.accessoryType = .checkmark
                }
                else{
                    cell.accessoryType = .none
                }
            }
            else{
            let item  = subtitleList[indexPath.row-1] as! AVMediaSelectionOption
            titleLabel.text = item.displayName
            if(temptitleName as String == item.displayName){
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
        }
        }
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        titleLabel.textColor=UIColor.white
        titleLabel.textAlignment = NSTextAlignment.left
        viewBg.addSubview(titleLabel)
        
        cell.contentView.addSubview(viewBg)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section==0{
            let item  = audioList[indexPath.row] as! AVMediaSelectionOption
            tempAudioName = item.displayName as NSString
            customCallBack!(audioList[indexPath.row],indexPath.section)
        }
        else{
            if(indexPath.row == 0){
              temptitleName = "Off"
                callBack!()
            }
            else{
            let item  = subtitleList[indexPath.row-1] as! AVMediaSelectionOption
            temptitleName = item.displayName as NSString
            customCallBack!(subtitleList[indexPath.row-1],indexPath.section)
            }
        }
        //tracksListingTV.reloadData()
        UserDefaults.standard.set(tempAudioName, forKey: "DefaultAudioTrack")
        UserDefaults.standard.set(temptitleName, forKey: "DefaultTitleTrack")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async() {
            /*let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            let mainController: UIViewController? = keyWindow?.rootViewController
            mainController?.dismiss(animated: true, completion: nil)*/
            self.removeFromSuperview()
        }
    }
    @objc func backBtnClicked(){
        UserDefaults.standard.set(tempAudioName, forKey: "DefaultAudioTrack")
        UserDefaults.standard.set(temptitleName, forKey: "DefaultTitleTrack")
        UserDefaults.standard.synchronize()
        self.removeFromSuperview()
        /*let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainController: UIViewController? = keyWindow?.rootViewController
        mainController?.dismiss(animated: true, completion: nil)*/
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
