//
//  JCHATSetDetailViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD
import MobileCoreServices

class JCHATSetDetailViewController: UIViewController {

  @IBOutlet weak var finishiBtn: UIButton!
  @IBOutlet weak var baseLine: UIView!
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var avatarBtn: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupNavigationBar()
    self.layoutAllViews()
  }

  func setupNavigationBar() {
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationItem.hidesBackButton = true
    let tittleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    tittleLabel.backgroundColor = UIColor.clear
    tittleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    tittleLabel.textColor = UIColor.white
    tittleLabel.textAlignment = .center
    tittleLabel.text = "输入昵称"
    self.navigationItem.titleView = tittleLabel
  }
  
  func layoutAllViews() {
    self.finishiBtn.setBackgroundColor(UIColor(netHex: 0x6fd66b), forState: UIControlState())
    self.finishiBtn.layer.cornerRadius = 5
    self.finishiBtn.layer.masksToBounds = true
  }
  
  @IBAction func clickToPickPhoto(_ sender: AnyObject) {
    self.nameTF.resignFirstResponder()
    let actionSheet = UIActionSheet(title: "更换头像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
    actionSheet.show(in: self.view)
  }

  @IBAction func clickToFinishi(_ sender: AnyObject) {
    var nickName = self.nameTF.text
    nickName = nickName?.trimmingCharacters(in: CharacterSet.whitespaces)
    if nickName == "" {
      MBProgressHUD.showMessage("请输入昵称", view: self.view)
      return
    }
    
    JMSGUser.updateMyInfo(withParameter: nickName!, userFieldType: .fieldsNickname) { (resultObject, error) -> Void in
      UIApplication.shared.delegate?.window!!.rootViewController = JChatMainTabViewController.sharedInstance
      NotificationCenter.default.post(name: Notification.Name(rawValue: kAccountChangeNotification), object: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension JCHATSetDetailViewController : UIActionSheetDelegate {
  
  func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {

    if buttonIndex == 1 {
      self.cameraClick()
    }
    
    if buttonIndex == 2 {
      self.photoClick()
    }
    
  }
  
  func cameraClick() {
    let picker:UIImagePickerController = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
      let requiredMediaType = kUTTypeImage as String
      let arrMediaTypes = [requiredMediaType]
      picker.mediaTypes = arrMediaTypes
      picker.showsCameraControls = true
      picker.modalTransitionStyle = .coverVertical
      picker.isEditing = true
      picker.delegate = self
      DispatchQueue.main.async(execute: { 
        self.present(picker, animated: true, completion: nil)
      })
    }
  }
  
  func photoClick() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    let tempMediaTypes = UIImagePickerController.availableMediaTypes(for: picker.sourceType)
    picker.mediaTypes = tempMediaTypes!
    picker.modalTransitionStyle = .coverVertical
    DispatchQueue.main.async { 
      self.present(picker, animated: true, completion: nil)
    }
  }
}

extension JCHATSetDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    print("Action - imagePickerController")
    MBProgressHUD.showMessage("正在上传", toView: self.view)
    let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    JMSGUser.updateMyInfo(withParameter: UIImageJPEGRepresentation(pickedImage, 1)!, userFieldType: .fieldsAvatar) { (resultObject, error) -> Void in
      DispatchQueue.main.async(execute: { () -> Void in
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        if error == nil {
          MBProgressHUD.showMessage("上传成功", view: self.view)
          let image = info[UIImagePickerControllerOriginalImage] as! UIImage
          self.avatarBtn.setBackgroundImage(image, for: UIControlState())
          self.avatarBtn.setBackgroundImage(image, for: .highlighted)
        } else {
          MBProgressHUD.showMessage("上传失败", view: self.view)
        }
      })
    }
    
    self.dismiss(animated: true, completion: nil)
  }
}
