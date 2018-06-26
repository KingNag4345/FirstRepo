//
//  ViewController.swift
//  PersonalizedVideo
//
//  Created by Nagaraju Surisetty on 11/11/17.
//  Copyright © 2017 PrimeFocus Technologies. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate {
    let nameField             = UITextField()
    let nicknameField         = UITextField()
    let crnField              = UITextField()
    let currentBillField      = UITextField()
    let electricityBillField  = UITextField()
    var profileImageButton    = UIButton()
    var galleryImage          = UIImage()
    var scrollView            = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor=UIColor.white
        self.view.isUserInteractionEnabled = true
        
        scrollView.frame  = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        
        let nameLabel = UILabel()
        nameLabel.frame=CGRect(x:((self.view.frame.size.width)/2)-160, y: 40, width:100, height: 34)
        nameLabel.backgroundColor=UIColor.clear
        nameLabel.font = UIFont(name: "MyriadPro-Regular", size: 18.0)
        nameLabel.textColor=UIColor.black
        nameLabel.text = "Name :"
        //nameLabel.animate(newText: nameLabel.text ?? "Name :", characterDelay: 0.3)
        nameLabel.textAlignment = NSTextAlignment.right
        scrollView.addSubview(nameLabel)
        
        nameField.frame =  CGRect(x:(self.view.frame.size.width/2)-50, y: 40, width: 200, height: 34.00)
        nameField.placeholder = "Enter Name"
        nameField.delegate=self
        nameField.borderStyle = UITextBorderStyle.line
        nameField.backgroundColor = UIColor.white
        nameField.returnKeyType=UIReturnKeyType.next
        nameField.textColor = UIColor.black
        scrollView.addSubview(nameField)
        
        let crnLabel = UILabel()
        crnLabel.frame=CGRect(x:((self.view.frame.size.width)/2)-160, y: nameField.frame.origin.y+nameField.frame.size.height+5, width:100, height: 34)
        crnLabel.backgroundColor=UIColor.clear
        crnLabel.font = UIFont(name: "MyriadPro-Regular", size: 18.0)
        crnLabel.textColor=UIColor.black
        crnLabel.text = "CRN No. :"
        crnLabel.textAlignment = NSTextAlignment.right
        scrollView.addSubview(crnLabel)
        
        crnField.frame =  CGRect(x:(self.view.frame.size.width/2)-50, y: nameField.frame.origin.y+nameField.frame.size.height+5, width: 200, height: 34.00)
        crnField.placeholder = "CRN"
        crnField.delegate=self
        crnField.borderStyle = UITextBorderStyle.line
        crnField.returnKeyType=UIReturnKeyType.next
        crnField.backgroundColor = UIColor.white
        crnField.textColor = UIColor.black
        scrollView.addSubview(crnField)
        
        let currentBillLabel = UILabel()
        currentBillLabel.frame=CGRect(x:((self.view.frame.size.width)/2)-160, y: crnField.frame.origin.y+crnField.frame.size.height+5, width:100, height: 34)
        currentBillLabel.backgroundColor=UIColor.clear
        currentBillLabel.font = UIFont(name: "MyriadPro-Regular", size: 18.0)
        currentBillLabel.textColor=UIColor.black
        currentBillLabel.text = "Water Bill :"
        currentBillLabel.textAlignment = NSTextAlignment.right
        scrollView.addSubview(currentBillLabel)
        
        currentBillField.frame =  CGRect(x:(self.view.frame.size.width/2)-50, y: crnField.frame.origin.y+crnField.frame.size.height+5, width: 200, height: 34.00)
        currentBillField.placeholder = "Water Bill"
        currentBillField.delegate=self
        currentBillField.borderStyle = UITextBorderStyle.line
        currentBillField.returnKeyType=UIReturnKeyType.next
        currentBillField.backgroundColor = UIColor.white
        currentBillField.textColor = UIColor.black
        scrollView.addSubview(currentBillField)
        
        let electricBillLabel = UILabel()
        electricBillLabel.frame=CGRect(x:((self.view.frame.size.width)/2)-160, y: currentBillField.frame.origin.y+currentBillField.frame.size.height+5, width:100, height: 34)
        electricBillLabel.backgroundColor=UIColor.clear
        electricBillLabel.font = UIFont(name: "MyriadPro-Regular", size: 18.0)
        electricBillLabel.textColor=UIColor.black
        electricBillLabel.text = "Electric Bill :"
        electricBillLabel.textAlignment = NSTextAlignment.right
        scrollView.addSubview(electricBillLabel)
        
        electricityBillField.frame =  CGRect(x:(self.view.frame.size.width/2)-50, y: currentBillField.frame.origin.y+currentBillField.frame.size.height+5, width: 200, height: 34.00)
        electricityBillField.placeholder = "Electric Bill"
        electricityBillField.delegate=self
        electricityBillField.borderStyle = UITextBorderStyle.line
        electricityBillField.returnKeyType=UIReturnKeyType.done
        electricityBillField.backgroundColor = UIColor.white
        electricityBillField.textColor = UIColor.black
        scrollView.addSubview(electricityBillField)
        
        let imageLabel = UILabel()
        imageLabel.frame=CGRect(x:((self.view.frame.size.width)/2)-160, y: electricityBillField.frame.origin.y+electricityBillField.frame.size.height+40, width:100, height: 34)
        imageLabel.backgroundColor=UIColor.clear
        imageLabel.font = UIFont(name: "MyriadPro-Regular", size: 18.0)
        imageLabel.textColor=UIColor.black
        imageLabel.text = "Profile Pic :"
        imageLabel.textAlignment = NSTextAlignment.right
        scrollView.addSubview(imageLabel)
        
        let signupImage = UIImage(named: "upload_Image")
        profileImageButton = UIButton(type: .custom)
        profileImageButton.addTarget(self, action: #selector(self.profileImageButtonPressed), for: .touchUpInside)
        profileImageButton.backgroundColor = UIColor.clear
        profileImageButton.setBackgroundImage(signupImage, for: .normal)
        profileImageButton.frame = CGRect(x: (self.view.frame.size.width/2)-40, y: electricityBillField.frame.origin.y+electricityBillField.frame.size.height+10, width: 80, height: 80)
        profileImageButton.setImage( UIImage(named: "defaultImage"), for: UIControlState.normal)
        profileImageButton.layer.cornerRadius = 40.0
        profileImageButton.layer.masksToBounds = true
        scrollView.addSubview(profileImageButton)
        
        let nextBtn = UIButton();
        nextBtn.frame = CGRect(x:(self.view.frame.size.width-50)/2, y:profileImageButton.frame.origin.y+profileImageButton.frame.size.height+50, width: 70, height: 50)
        nextBtn.backgroundColor=UIColor.clear
        nextBtn.setTitle("NEXT", for: UIControlState.normal)
        nextBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        nextBtn.layer.cornerRadius=2.0
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        nextBtn.addTarget(self, action:#selector(self.nextBtnPressed), for: .touchUpInside)
        scrollView.addSubview(nextBtn)
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: nextBtn.frame.origin.y+nextBtn.frame.size.height+20)
        
        galleryImage = UIImage(named: "defaultImage")!
        nameField.text = "Michael"
        currentBillField.text = "456"
        electricityBillField.text = "550"
        crnField.text = "4345"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchesBegan Called")
    }
    @objc func profileImageButtonPressed(){
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.isFullScreen = true
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
        self.present(picker, animated: true) {
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        if (mediaType == (kUTTypeImage as? String)) {
            let imagePick = info[UIImagePickerControllerEditedImage] as? UIImage
            profileImageButton.setImage(imagePick, for: UIControlState.normal)
            galleryImage = imagePick!
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.isFullScreen = false
        }
         picker.dismiss(animated: true, completion: {() -> Void in
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.isFullScreen = false
        })
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == crnField || textField == electricityBillField || textField == currentBillField {
            let cs = CharacterSet(charactersIn: "0123456789").inverted
            let filtered: String = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }
        let newLength: Int = (textField.text?.count ?? 0) + (string.count ) - range.length
        return (newLength > 86) ? false : true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField==nameField){
           scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if(textField==crnField){
          scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if(textField==currentBillField){
           scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if(textField==electricityBillField){
           scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameField) {
            nameField.resignFirstResponder()
            crnField.becomeFirstResponder()
        }
        else if (textField == crnField) {
            crnField.resignFirstResponder()
            currentBillField.becomeFirstResponder()
        }
        else if (textField == currentBillField) {
            currentBillField.resignFirstResponder()
            electricityBillField.becomeFirstResponder()
        }
        else if (textField == electricityBillField) {
            electricityBillField.resignFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else{
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            textField.resignFirstResponder()
        }
        return true
    }
    @objc func nextBtnPressed(){
        print("galleryImage %@",galleryImage)
        if(nameField.text!.count > 0) && (currentBillField.text!.count > 0) && (electricityBillField.text!.count > 0) && (crnField.text!.count > 0) && galleryImage.hasContent && (crnField.text!.count > 0){
        UserDefaults.standard.set(nameField.text, forKey: "UserName")
        UserDefaults.standard.set(currentBillField.text, forKey: "WaterBill")
        UserDefaults.standard.set(electricityBillField.text, forKey: "ElectricBill")
        UserDefaults.standard.set(crnField.text, forKey: "CRNNumber")
        UserDefaults.standard.synchronize()
            
            var jsonArray = NSArray()
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
            }
            
        let playerDetail = playerVC()
        playerDetail.selectedImage = galleryImage
        self.navigationController?.pushViewController(playerDetail, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Please enter all fields and select profile image.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    tempDict["pos_x_min"] = String(describing: item["pos_x_min"]!)
    }
    if item["pos_x_max"] == nil || (item["pos_x_max"] is NSNull){
    tempDict["pos_x_max"] = ""
    }
    else {
    tempDict["pos_x_max"] = String(describing: item["pos_x_max"]!)
    }
    if item["pos_y_min"] == nil || (item["pos_y_min"] is NSNull) {
    tempDict["pos_y_min"] = ""
    }
    else {
    tempDict["pos_y_min"] = String(describing: item["pos_y_min"]!)
    }
    if item["pos_y_max"] == nil || (item["pos_y_max"] is NSNull) {
    tempDict["pos_y_max"] = ""
    }
    else {
    tempDict["pos_y_max"] = String(describing: item["pos_y_max"]!)
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
    tempDict["attr_start_time"] = item["attr_start_time"]! //String(describing: item["attr_start_time"]!)
    }
    if item["attr_end_time"] == nil || (item["attr_end_time"] is NSNull) {
    tempDict["attr_end_time"] = ""
    }
    else {
    tempDict["attr_end_time"] = item["attr_end_time"]!//String(describing: item["attr_end_time"]!)
    }
    if item["anim_scale_factor_x"] == nil || (item["anim_scale_factor_x"] is NSNull) {
    tempDict["anim_scale_factor_x"] = ""
    }
    else {
    tempDict["anim_scale_factor_x"] = String(describing: item["anim_scale_factor_x"]!)
    }
    if item["anim_scale_factor_y"] == nil || (item["anim_scale_factor_y"] is NSNull) {
    tempDict["anim_scale_factor_y"] = ""
    }
    else {
    tempDict["anim_scale_factor_y"] = String(describing: item["anim_scale_factor_y"]!)
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
    tempDict["anim_rotate_angle_y"] = String(describing: item["anim_rotate_angle_y"]!)
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
        let contentString : NSString = String(describing: item["content"]!) as NSString
        if contentString.contains("$CUSTOM_NAME$") {
            print("exists")
            contentString.replacingOccurrences(of: "$CUSTOM_NAME$", with: UserDefaults.standard.value(forKey: "UserName") as! String)
            print("Contenyt Text %@",contentString.replacingOccurrences(of: "$CUSTOM_NAME$", with: UserDefaults.standard.value(forKey: "UserName") as! String))
            tempDict["content"] = contentString.replacingOccurrences(of: "$CUSTOM_NAME$", with: UserDefaults.standard.value(forKey: "UserName") as! String)
        }
        else if contentString.contains("$CUSTOM_CRN$") {
            print("exists")
            contentString.replacingOccurrences(of: "$CUSTOM_CRN$", with: UserDefaults.standard.value(forKey: "CRNNumber") as! String)
            print("Contenyt Text %@",contentString.replacingOccurrences(of: "$CUSTOM_CRN$", with: UserDefaults.standard.value(forKey: "CRNNumber") as! String))
            tempDict["content"] = contentString.replacingOccurrences(of: "$CUSTOM_CRN$", with: UserDefaults.standard.value(forKey: "CRNNumber") as! String)
        }
        else if contentString.contains("$CUSTOM_WATERBILL$") {
            print("exists")
            contentString.replacingOccurrences(of: "$CUSTOM_WATERBILL$", with: UserDefaults.standard.value(forKey: "WaterBill") as! String)
            print("Contenyt Text %@",contentString.replacingOccurrences(of: "$CUSTOM_WATERBILL$", with: UserDefaults.standard.value(forKey: "WaterBill") as! String))
            tempDict["content"] = contentString.replacingOccurrences(of: "$CUSTOM_WATERBILL$", with: UserDefaults.standard.value(forKey: "WaterBill") as! String)
        }
        else if contentString.contains("$CUSTOM_ELECTRICITYBILL$") {
            print("exists")
            contentString.replacingOccurrences(of: "$CUSTOM_ELECTRICITYBILL$", with: UserDefaults.standard.value(forKey: "ElectricBill") as! String)
            print("Contenyt Text %@",contentString.replacingOccurrences(of: "$CUSTOM_ELECTRICITYBILL$", with: UserDefaults.standard.value(forKey: "ElectricBill") as! String))
            tempDict["content"] = contentString.replacingOccurrences(of: "$CUSTOM_ELECTRICITYBILL$", with: UserDefaults.standard.value(forKey: "ElectricBill") as! String)
        }
        else if contentString.contains("$CUSTOM_TOTAL$") {
            print("exists")
            let waterBill : Int = Int((UserDefaults.standard.value(forKey: "WaterBill") as! NSString).intValue)
            let electricBill : Int = Int((UserDefaults.standard.value(forKey: "ElectricBill") as! NSString).intValue)
            let total : Int = waterBill+electricBill
            contentString.replacingOccurrences(of: "$CUSTOM_TOTAL$", with: String(format:"%d",total))
            print("Contenyt Text %@",contentString.replacingOccurrences(of: "$CUSTOM_TOTAL$", with: String(format:"%d",total)))
            tempDict["content"] = contentString.replacingOccurrences(of: "$CUSTOM_TOTAL$", with: String(format:"%d",total))
        }
        else{
      tempDict["content"] = contentString
        }
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
    }
    print("filterArray %@",filterArray)
    UserDefaults.standard.set(filterArray, forKey: "personlizationArray")
    UserDefaults.standard.synchronize()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


