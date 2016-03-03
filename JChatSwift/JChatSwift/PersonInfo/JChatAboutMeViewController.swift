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
let kupdateUserInfo = "updateUserInfo"
internal let kApplicationWidth = CGRectGetWidth((UIScreen.mainScreen().bounds))

@objc(JChatAboutMeViewController)
class JChatAboutMeViewController: UIViewController {
  var table:UITableView!
  var cellDataArr:NSArray?
  var cellImgArr:NSArray?
  var bgView:JChatAvatarView!
  var headerView:JChatExpandHeader!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.translucent = false
    
    self.table = UITableView()
    self.table.delegate = self
    self.table.dataSource = self
    self.view.addSubview(self.table)
    self.table.separatorStyle = .None
    self.table.estimatedRowHeight = 40
    self.table.rowHeight = UITableViewAutomaticDimension
    self.table.tableFooterView = UIView()
    self.table.snp_makeConstraints { (make) -> Void in
      make.left.top.right.bottom.equalTo(self.view)
    }
    
    if JMSGUser.myInfo().nickname == nil {
      self.cellDataArr = [JMSGUser.myInfo().username, "设置", "退出登陆"]
    } else {
      self.cellDataArr = [JMSGUser.myInfo().nickname!, "设置", "退出登陆"]
    }
    self.cellImgArr = ["wo_20", "setting_22", "loginOut_17"]
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setAvatar"), name: kupdateUserInfo, object: nil)
  }

  override func viewDidLayoutSubviews() {
    self.setAvatar()
    
  }
  
  @objc func setAvatar() {
    self.bgView = JChatAvatarView(frame: CGRectMake(0, 0, kApplicationWidth, 0.54 * kApplicationWidth))
    self.bgView.backgroundColor = UIColor.redColor()
    let gesture = UITapGestureRecognizer(target: self, action: Selector("tapPicture:"))
    self.bgView.addGestureRecognizer(gesture)
    self.headerView = JChatExpandHeader.expandWithScrollView(self.table, expandView: self.bgView)
  }

  func updateAvatar() {
    let user:JMSGUser = JMSGUser.myInfo()
    self.bgView.updataNameLable()
    user.thumbAvatarData { (data, objectId, error) -> Void in
      if data == nil {
        if data != nil {
          self.bgView.setHeadImage(UIImage(data: data)!)
        } else {
          self.bgView.setDefaultAvatar()
        }
      } else {
        self.bgView.setDefaultAvatar()
      }
    }
    
  }

  @objc func tapPicture(gesture:UIGestureRecognizer) {
    let actionSheet = UIActionSheet(title: "更换头像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
    actionSheet.showInView(UIApplication.sharedApplication().keyWindow!)
    
  }

  func photoClick() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .PhotoLibrary
    let temp_mediaType = UIImagePickerController.availableMediaTypesForSourceType(picker.sourceType)
    picker.mediaTypes = temp_mediaType!
    picker.modalTransitionStyle = .CoverVertical
    self.presentViewController(picker, animated: true, completion: nil)
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
//  #pragma mark - UIImagePickerController Delegate
//  
//  //相机,相册Finish的代理


//  - (void)viewWillAppear:(BOOL)animated {
//  [super viewWillAppear:YES];
//  [self.settingTableView reloadData];
//  
//  self.title = @"我";
//  
//  [_bgView updataNameLable];
//  
//  self.view.backgroundColor = [UIColor whiteColor];
//  self.settingTableView.backgroundColor = [UIColor whiteColor];
//  [self updateUserInfo];
//  }
//  
//  - (void)viewDidDisappear:(BOOL)animated {
//  [super viewDidDisappear:YES];
//  [self.navigationController setNavigationBarHidden:NO];
//  }
//  
//  // FIXME 这里应该是想要重新拉取一次整个的 MyInfo。但实际上只是重新取了 avatar
//  - (void)updateUserInfo {
//  DDLogDebug(@"Action - updateUserInfo");
//  JMSGUser *user = [JMSGUser myInfo];
//  [self updateAvatar];
//  if (user.username) {
//  self.titleArr = @[user.username, @"设置", @"退出登录"];
//  } else {
//  self.titleArr = @[@"", @"设置", @"退出登录"];
//  }
//  
//  [self.settingTableView reloadData];
//  }
//  
//  - (void)viewWillDisappear:(BOOL)animated {
//  [super viewWillDisappear:YES];
//  }
//  
//  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  static NSString *cellIdentifier = @"headCell";
//  JCHATSettingCell *cell = (JCHATSettingCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//  if (cell == nil) {
//  cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATSettingCell" owner:self options:nil] lastObject];
//  cell.selectionStyle = UITableViewCellSelectionStyleGray;
//  UILabel *line = [[UILabel alloc] initWithFrame:separateLineFrame];
//  [line setBackgroundColor:separateLineColor];
//  }
//  
//  cell.nickNameBtn.text = self.titleArr[indexPath.row];
//  cell.headImgView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
//  return cell;
//  }
//  
//  - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return 57;
//  }
//  
//  - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//  cell.selected = NO;
//  
//  switch (indexPath.row) {
//  case 0:
//  {
//  JCHATPersonViewController *personCtl = [[JCHATPersonViewController alloc] init];
//  personCtl.hidesBottomBarWhenPushed = YES;
//  [self.navigationController pushViewController:personCtl animated:YES];
//  }
//  break;
//  case 1:
//  {
//  JCHATSettingViewController *settingCtl = [[JCHATSettingViewController alloc] init];
//  settingCtl.hidesBottomBarWhenPushed = YES;
//  [self.navigationController pushViewController:settingCtl animated:YES];
//  }
//  break;
//  case 2:
//  {
//  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//  message:@"退出登录!"
//  delegate:self
//  cancelButtonTitle:@"取消"
//  otherButtonTitles:@"确定", nil];
//  [alerView show];
//  }
//  break;
//  default:
//  break;
//  }
//  }
//  
//
//  - (void)didReceiveMemoryWarning {
//  [super didReceiveMemoryWarning];
//  }
//  
//  @end

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

extension JChatAboutMeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    identify = "JChatAboutMeCell"
    var cell:JChatAboutMeCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatAboutMeCell
    if cell == nil {
      tableView.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatAboutMeCell
    }
    let tittle = self.cellDataArr![indexPath.row] as! String
    let imgName = self.cellImgArr![indexPath.row] as! String
    
    cell?.setCellData(tittle, icon: imgName)
    return cell!
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.selected = false
    
    switch indexPath.row {
    case 0:
      let userInfoVC = JChatUserInfoViewController()
      userInfoVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(userInfoVC, animated: true)
      break
    case 1:
      //  JCHATSettingViewController *settingCtl = [[JCHATSettingViewController alloc] init];
      //  settingCtl.hidesBottomBarWhenPushed = YES;
      //  [self.navigationController pushViewController:settingCtl animated:YES];
      
      break
    default:
      //  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
      //  message:@"退出登录!"
      //  delegate:self
      //  cancelButtonTitle:@"取消"
      //  otherButtonTitles:@"确定", nil];
      //  [alerView show];

      break
    }
  }

}

extension JChatAboutMeViewController: UIActionSheetDelegate {
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 0 {
      self.cameraClick()
      return
    }
    
    if buttonIndex == 1 {
      self.photoClick()
      return
    }
  }
  
}

extension JChatAboutMeViewController: UIAlertViewDelegate {

  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 0 {
      return
    }
    
    if buttonIndex == 1 {
      MBProgressHUD.showMessage("正在退出登录！", view: self.view)
      print("Logout anyway")
      JChatMainTabViewController.sharedInstance.selectedIndex = 0
      MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
      JMSGUser.logout({ (resultObject, error) -> Void in
        if error == nil {
          print("Action logout success")
        }
      })
      let loginVC = JChatAlreadyLoginViewController()
      let loginNC = UINavigationController(rootViewController: loginVC)
      let appDelegate = UIApplication.sharedApplication().delegate
      appDelegate!.window!!.rootViewController = loginNC
      NSUserDefaults.standardUserDefaults().removeObjectForKey(kuserName)
      
      return
    }
  }
}

extension JChatAboutMeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    print("Action - imagePickerController ")
    MBProgressHUD.showMessage("正在上传", toView: self.view)
    let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    JMSGUser.updateMyInfoWithParameter(UIImageJPEGRepresentation(pickedImage, 1)!, userFieldType: .FieldsAvatar) { (resultObject, error) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        if error == nil {
          MBProgressHUD.showMessage("上传成功", toView: self.view)
          let user = JMSGUser.myInfo()
          user.thumbAvatarData({ (data, ObjectId, error) -> Void in
            if error == nil {
              self.bgView.setHeadImage(UIImage(data: data)!)
            } else {
              print("get thumbAvatarData fail")
            }
          })
          
        } else {
          MBProgressHUD.showMessage("上传失败", toView: self.view)
        }
      })
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}