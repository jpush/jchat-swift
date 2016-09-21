//
//  JChatAboutMeViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MobileCoreServices
import MBProgressHUD

@objc(JChatAboutMeViewController)
class JChatAboutMeViewController: UIViewController {
  var table:UITableView!
  var cellDataArr:NSArray?
  var cellImgArr:NSArray?
  var bgView:JChatAvatarView!
  var tableHeader:JChatExpandHeader!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isTranslucent = false
    self.title = "我"
    
    self.table = UITableView()
    self.table.delegate = self
    self.table.dataSource = self
    self.view.addSubview(self.table)
    self.table.separatorStyle = .none
    self.table.estimatedRowHeight = 40
    self.table.rowHeight = UITableViewAutomaticDimension
    self.table.tableFooterView = UIView()
    self.table.tableHeaderView = UIView()

    self.table.snp_makeConstraints { (make) -> Void in
      make.left.top.right.bottom.equalTo(self.view)
    }
    
    self.getData()
    self.setAvatar()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateAvatar), name: NSNotification.Name(rawValue: kupdateUserInfo), object: nil)
  }

  func getData() {
    if JMSGUser.myInfo().nickname == nil {
      self.cellDataArr = [JMSGUser.myInfo().username, "设置", "退出登录"]
    } else {
      self.cellDataArr = [JMSGUser.myInfo().nickname!, "设置", "退出登录"]
    }
    self.cellImgArr = ["wo_20", "setting_22", "loginOut_17"]
  }
  
  override func viewDidLayoutSubviews() {
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.getData()
    self.table.reloadData()
  }
  
  func setAvatar() {
    self.bgView = JChatAvatarView(frame: CGRect(x: 0, y: 0, width: kApplicationWidth, height: 0.55 * kApplicationWidth))

    self.bgView.backgroundColor = UIColor(netHex: 0xdddddd)
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapPicture(_:)))
    gesture.numberOfTapsRequired = 1
    self.bgView.isUserInteractionEnabled = true
    self.bgView.addGestureRecognizer(gesture)
    
    self.tableHeader = JChatExpandHeader.expandWithScrollView(self.table, expandView: self.bgView)
    self.updateAvatar()

  }

  func updateAvatar() {
    let user:JMSGUser = JMSGUser.myInfo()
    self.bgView.updataNameLable()
    user.thumbAvatarData { (data, objectId, error) -> Void in
      if error == nil {
        if data != nil {
          self.bgView.setHeadImage(UIImage(data: data!)!)
        } else {
          self.bgView.setDefaultAvatar()
        }
      } else {
        self.bgView.setDefaultAvatar()
      }
    }
  }

  func tapPicture(_ gesture:UIGestureRecognizer) {
    let actionSheet = UIActionSheet(title: "更换头像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
    actionSheet.show(in: self.view)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension JChatAboutMeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    identify = "JChatAboutMeCell"
    var cell:JChatAboutMeCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatAboutMeCell
    if cell == nil {
      tableView.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatAboutMeCell
    }
    let tittle = self.cellDataArr![(indexPath as NSIndexPath).row] as! String
    let imgName = self.cellImgArr![(indexPath as NSIndexPath).row] as! String
    
    cell?.setCellData(tittle, icon: imgName)
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    
    switch (indexPath as NSIndexPath).row {
    case 0:
      let userInfoVC = JChatUserInfoViewController()
      userInfoVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(userInfoVC, animated: true)
      break
    case 1:
      let settingVC = JChatSettingTableViewController()
      settingVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(settingVC, animated: true)
      break
    default:
      let alertView = UIAlertView(title: "温馨提示", message: "退出登录!", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
      alertView.show()

      break
    }
  }

}

extension JChatAboutMeViewController: UIActionSheetDelegate {
  func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
    if buttonIndex == 1 {
      self.cameraClick()
      return
    }
    
    if buttonIndex == 2 {
      self.photoClick()
      return
    }
  }
  
  func photoClick() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    let temp_mediaType = UIImagePickerController.availableMediaTypes(for: picker.sourceType)
    picker.mediaTypes = temp_mediaType!
    picker.modalTransitionStyle = .coverVertical
    DispatchQueue.main.async { 
      self.present(picker, animated: true, completion: nil)
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
  
}

extension JChatAboutMeViewController: UIAlertViewDelegate {

  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    if buttonIndex == 0 {
      return
    }
    
    if buttonIndex == 1 {
      MBProgressHUD.showMessage("正在退出登录！", view: self.view)
      print("Logout anyway")
      JChatMainTabViewController.sharedInstance.selectedIndex = 0
      MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      JMSGUser.logout({ (resultObject, error) -> Void in
        if error == nil {
          print("Action logout success")
        }
      })
      let loginVC = JChatAlreadyLoginViewController()
      let loginNC = UINavigationController(rootViewController: loginVC)
      let appDelegate = UIApplication.shared.delegate
      appDelegate!.window!!.rootViewController = loginNC
      UserDefaults.standard.removeObject(forKey: kuserName)
      
      return
    }
  }
}

extension JChatAboutMeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    print("Action - imagePickerController ")//UIImageJPEGRepresentation
    MBProgressHUD.showMessage("正在上传", toView: self.view)
    let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    
    JMSGUser.updateMyInfo(withParameter: UIImageJPEGRepresentation(pickedImage, 1)!, userFieldType: .fieldsAvatar) { (resultObject, error) -> Void in
      DispatchQueue.main.async(execute: { () -> Void in
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        if error == nil {
          MBProgressHUD.showMessage("上传成功", view: self.view)
          let user = JMSGUser.myInfo()
          user.thumbAvatarData({ (data, ObjectId, error) -> Void in
            if error == nil {
              self.bgView.setHeadImage(UIImage(data: data!)!)
            } else {
              print("get thumbAvatarData fail")
            }
          })
          
        } else {
          MBProgressHUD.showMessage("上传失败", view: self.view)
        }
      })
    }
    self.dismiss(animated: true, completion: nil)
  }
}
