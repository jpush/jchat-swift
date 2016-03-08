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
    self.navigationController?.navigationBar.translucent = false
    self.navigationItem.hidesBackButton = true
    let tittleLabel = UILabel(frame: CGRectMake(0, 0, 200, 44))
    tittleLabel.backgroundColor = UIColor.clearColor()
    tittleLabel.font = UIFont.boldSystemFontOfSize(20)
    tittleLabel.textColor = UIColor.whiteColor()
    tittleLabel.textAlignment = .Center
    tittleLabel.text = "输入昵称"
    self.navigationItem.titleView = tittleLabel
  }
  
  func layoutAllViews() {
    self.finishiBtn.setBackgroundColor(UIColor(netHex: 0x6fd66b), forState: .Normal)
    self.finishiBtn.layer.cornerRadius = 5
    self.finishiBtn.layer.masksToBounds = true
  }
  
  @IBAction func clickToPickPhoto(sender: AnyObject) {
    self.nameTF.resignFirstResponder()
    let actionSheet = UIActionSheet(title: "更换头像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
    actionSheet.showInView(UIApplication.sharedApplication().keyWindow!)
    
  }

  @IBAction func clickToFinishi(sender: AnyObject) {
    var nickName = self.nameTF.text
    nickName = nickName?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    if nickName == "" {
      MBProgressHUD.showMessage("请输入昵称", view: self.view)
      return
    }
    
    JMSGUser.updateMyInfoWithParameter(nickName!, userFieldType: .FieldsNickname) { (resultObject, error) -> Void in
      UIApplication.sharedApplication().delegate?.window!!.rootViewController = JChatMainTabViewController.sharedInstance
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension JCHATSetDetailViewController : UIActionSheetDelegate {
  
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 0 {
      self.cameraClick()
    } else {
      self.photoClick()
    }
    
  }
  
  func cameraClick() {
    let picker:UIImagePickerController = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      picker.sourceType = .Camera
      let requiredMediaType = kUTTypeImage as String
      let arrMediaTypes = [requiredMediaType]
      picker.mediaTypes = arrMediaTypes
      picker.showsCameraControls = true
      picker.modalTransitionStyle = .CoverVertical
      picker.editing = true
      picker.delegate = self
      self.presentViewController(picker, animated: true, completion: nil)  
    }
  }
  
  func photoClick() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .PhotoLibrary
    let tempMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(picker.sourceType)
    picker.mediaTypes = tempMediaTypes!
    picker.modalTransitionStyle = .CoverVertical
    self.presentViewController(picker, animated: true, completion: nil)
    
  }
}

extension JCHATSetDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    print("Action - imagePickerController")
    MBProgressHUD.showMessage("正在上传", toView: self.view)
    let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    JMSGUser.updateMyInfoWithParameter(UIImageJPEGRepresentation(pickedImage, 1)!, userFieldType: .FieldsAvatar) { (resultObject, error) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        if error == nil {
          MBProgressHUD.showMessage("上传成功", toView: self.view)
          let image = info[UIImagePickerControllerOriginalImage] as! UIImage
          self.avatarBtn.setBackgroundImage(image, forState: .Normal)
        } else {
          MBProgressHUD.showMessage("上传失败", toView: self.view)
        }
      })
    }
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
