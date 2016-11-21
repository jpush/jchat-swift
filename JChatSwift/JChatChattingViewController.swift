//
//  JChatChattingViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit

internal let interval = 60
internal let messagePageNumber = 25
internal let messageFristPageNumber = 20

@objc(JChatChattingViewController)
class JChatChattingViewController: UIViewController {
  
  var conversation:JMSGConversation!
  
  var messageTable:JChatMessageTable!
  var messageInputView:JChatInputView!
  var messageDataSource:JChatChattingDataSource!
  var chatLayout:JChatChattingLayout!
  
  var messageOffset = 0
  var isAllowToScrollMessageTable:Bool = true
  
  var locationManager:JChatLocationManager!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Action - viewDidLoad")
    self.locationManager = JChatLocationManager(delegate: self)
    
    self.setupNavigation()
    self.setupAllViews()
    self.setupDataSource()
    self.addAllNotification()
    
    self.chatLayout = JChatChattingLayout(messageTable: self.messageTable, inputView: self.messageInputView)
    
    let gesture = UITapGestureRecognizer(target: self, action:#selector(JChatChattingViewController.handleTap(_:)))
    gesture.delegate = self
    self.messageTable.addGestureRecognizer(gesture)
    messageTable.rowHeight = UITableViewAutomaticDimension

  }
  
  override func viewDidLayoutSubviews() {
    if isAllowToScrollMessageTable {
      self.chatLayout.messageTableScrollToBottom(false)
      isAllowToScrollMessageTable = false
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    JMessage.remove(self, with: self.conversation)
  }
  
  func setupNavigation() {
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.navigationBar.isTranslucent = false
    self.title = "会话"
    let leftBtn = UIButton(type: .custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.backClick), for: .touchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)

    let rightBtn = UIButton(type: .custom)
    rightBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
    rightBtn.addTarget(self, action: #selector(self.clickRightBtn), for: .touchUpInside)
    rightBtn.setImage(UIImage(named: "createConversation"), for: UIControlState())
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15 * UIScreen.main.scale)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
  }
  
  func addAllNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.cleanMessageCache), name: NSNotification.Name(rawValue: kDeleteAllMessage), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.alertToSendImage(_:)), name: NSNotification.Name(rawValue: kAlertToSendImage), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.deleteMessage(_:)), name: NSNotification.Name(rawValue: kDeleteMessage), object: nil)
    
    JMessage.add(self, with: self.conversation)
//    JMessage.add(self, with: nil)
  }
  
  func deleteMessage(_ notifacation: Notification) {
    let message = notifacation.object as! JMSGMessage
    self.conversation.deleteMessage(withMessageId: message.msgId)
    self.messageDataSource.deleteMessage(message)
    self.chatLayout.loadMoreMessage()
  }
  
  func alertToSendImage(_ notification:Notification) {
    let image = notification.object as! UIImage
    self.prepareSendImageMessage(image)
  }
  
  func cleanMessageCache() {
    self.messageDataSource.cleanCache()
    self.messageTable.reloadData()
  }
  
  func backClick() {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func clickRightBtn() {
    let detailCtl = JCHATGroupDetailViewController()
    detailCtl.conversation = self.conversation
    detailCtl.chattingVC = self
    self.navigationController?.pushViewController(detailCtl, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    print("Action - viewWillAppear")
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    self.messageTable.reloadData()
//    self.conversation.refreshTargetInfoFromServer { (resultObject, error) in
//      if error == nil {
//
//      } else {
//        print("\(NSString.errorAlert(error)))")
//      }
//    }
  }
  
  func setupAllViews() {
    self.view.backgroundColor = UIColor.white
    
    self.messageInputView = JChatInputView(delegate: self)
    self.view.addSubview(messageInputView)
    self.messageInputView.inputDelegate = self
    self.messageInputView.snp.makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.view)
    }
    
    self.messageInputView.moreView.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(self.view.snp.bottom)
    }
    //init messageTable
    self.messageTable = JChatMessageTable(frame: CGRect.zero)
    self.messageTable.separatorStyle = .none
    self.messageTable.backgroundColor = kTableViewBackgroupColor
    self.messageTable.delegate = self
    self.messageTable.dataSource = self
    self.messageTable.keyboardDismissMode = .interactive
    self.view.addSubview(messageTable)
    self.messageTable.snp.makeConstraints { (make) -> Void in
      make.top.left.right.equalTo(self.view)
      make.bottom.equalTo(self.messageInputView.snp.top)
    }
  }
  
  func setupDataSource() {
    self.conversation.clearUnreadCount()
    self.messageDataSource = JChatChattingDataSource(conversation: self.conversation, showTimeInterval: 60 * 5, fristPageNumber: 20, limit: 11)
    self.messageDataSource.getPageMessage()
  }

  func flashToLoadMessage() {
    self.messageDataSource.getMoreMessage()
    self.chatLayout.loadMoreMessage()
  }
  
  func keyboardFrameChanged(_ notification: Notification) {
    let dic = NSDictionary(dictionary: (notification as NSNotification).userInfo!)
    let keyboardValue = dic.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    let bottomDistance = UIScreen.main.bounds.size.height - keyboardValue.cgRectValue.origin.y
    let duration = Double(dic.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
    
    UIView.animate(withDuration: duration, animations: {
      self.messageInputView.moreView?.snp.updateConstraints({ (make) -> Void in
        make.height.equalTo(bottomDistance)
      })
      self.view.layoutIfNeeded()
      }, completion: {
        (value: Bool) in
    })

  }
  
}

extension JChatChattingViewController:UITableViewDelegate,UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.messageDataSource.allMessageIdArr.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if self.messageDataSource.noMoreHistoryMessage() != true {
      if (indexPath as NSIndexPath).row == 0 {
        return 25
      }
    }

    let model = self.messageDataSource.getMessageWithIndex((indexPath as NSIndexPath).row)
    
    if model is JChattimeModel {
      return 25
    } else {
      return (model as! JChatMessageModel).messageCellHeight
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    print("Action - cellForRowAtIndexPath")
    if self.messageDataSource.noMoreHistoryMessage() != true {
      if (indexPath as NSIndexPath).row == 0 {
        let cell:JChatLoadingMessageCell = JChatTableCellMaker.LoadingCellInTable(tableView)
        cell.startLoading()
        self.perform(#selector(self.flashToLoadMessage), with: nil, afterDelay: 1)
        return cell
      }
    }
  
    let model = self.messageDataSource.getMessageWithIndex((indexPath as NSIndexPath).row)
    
    if model is JChattimeModel {
      let cell:JChatShowTimeCell = JChatTableCellMaker.timeCellInTable(tableView)
      cell.layoutModel(model as! JChattimeModel)
      return cell
    } else {
      
      let message = (model as! JChatMessageModel).message
      
      if message?.contentType == .eventNotification {
        let cell:JChatShowTimeCell = JChatTableCellMaker.timeCellInTable(tableView)
        cell.layoutWithNotifcation(model as! JChatMessageModel)
        return cell
      }
      
      if (message?.isReceived)! {
        let cell:JChatLeftMessageCell = JChatTableCellMaker.leftMessageCellInTable(tableView)
        cell.setCellData((model as! JChatMessageModel), delegate: self)
        return cell
      } else {
        let cell:JChatRightMessageCell = JChatTableCellMaker.rightMessageCellInTable(tableView)
        cell.setCellData((model as! JChatMessageModel), delegate: self)
        return cell
      }
    }
  }
  
}


extension JChatChattingViewController:UIGestureRecognizerDelegate {
  func handleTap(_ recognizer: UITapGestureRecognizer) {
    hideKeyBoardAnimation()

    UIView.animate(withDuration: keyboardAnimationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
      self.messageInputView.moreView.snp.updateConstraints { (make) -> Void in
        make.height.equalTo(0)
      }
      self.view.layoutIfNeeded()
    }) 
  }
}


extension JChatChattingViewController:JChatInputDelegate {
  
  func showMoreView() {
    hideKeyBoardAnimation()
    UIView.animate(withDuration: 0.25) { () -> Void in
      self.messageInputView.moreView?.snp.updateConstraints({ (make) -> Void in
        make.bottom.equalTo(self.view.snp.bottom)
      })
    }
  }
  
  func appendMessage(_ model:JChatMessageModel) {
    self.messageDataSource.appendMessage(model)
    self.perform(#selector(JChatChattingViewController.appendMessageCell), with: nil, afterDelay: 0.01);
  }
  
  func appendMessageCell() {
    self.chatLayout.appendTableViewCellAtLastIndex(self.messageDataSource.messageCount())
  }
  
  func appendTimeDate(_ timeInterVal:TimeInterval) {
    self.appendTimeDate(timeInterVal)
    self.chatLayout.appendTableViewCellAtLastIndex(self.messageDataSource.messageCount())
  }
  
  func sendTextMessage(_ messageText: String) {
    let textContent:JMSGTextContent = JMSGTextContent(text: messageText)
    let textMessage:JMSGMessage = self.conversation.createMessage(with: textContent)!
    self.conversation.send(textMessage)
    let textModel:JChatMessageModel = JChatMessageModel()
    textModel.setChatModel(textMessage, conversation: self.conversation)
    self.appendMessage(textModel)
  }
  
  func SendMessageWithVoice(_ voicePath:String, durationTime:Double) {
    print("SendMessageWithVoice")
    let voiceContent:JMSGVoiceContent = JMSGVoiceContent(voiceData: try! Data(contentsOf: URL(fileURLWithPath: voicePath)), voiceDuration: NSNumber(integerLiteral: Int(durationTime)))
    let voiceMessage:JMSGMessage? = self.conversation.createMessage(with: voiceContent)
    self.conversation.send(voiceMessage!)
    let voicemodel:JChatMessageModel = JChatMessageModel()
    voicemodel.setChatModel(voiceMessage, conversation: self.conversation)
    self.appendMessage(voicemodel)
  }
  
  func prepareSendImageMessage(_ image:UIImage) {
    var message:JMSGMessage? = nil
    let imageContent = JMSGImageContent(imageData: UIImagePNGRepresentation(image)!)
    if imageContent != nil {
      message = self.conversation.createMessage(with: imageContent!)
      JChatSendImageManager.sharedInstance.addMessage(message!, withConversation: self.conversation)
      let model:JChatMessageModel = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.messageDataSource.appendMessage(model)
      self.messageTable.reloadData()
      self.chatLayout.messageTableScrollToBottom(false)
    }
  }
  
  func sendLocationMessage(location:CLLocation, placeholdImg:UIImage) {
    var message:JMSGMessage? = nil
    let scale = Double(UIScreen.main.scale)
    let locationContent = JMSGLocationContent(latitude: NSNumber(value: location.coordinate.latitude), longitude: NSNumber(value: location.coordinate.longitude) , scale: NSNumber(value: scale), address: "")
    if locationContent != nil {
      message = self.conversation.createMessage(with: locationContent)
      locationManager.locationImageName = message?.msgId
      JChatFileManage.sharedInstance.writeImage(name: "\((message?.msgId)!).png", image: placeholdImg)
      self.conversation.send(message!)
      let model:JChatMessageModel = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.messageDataSource.appendMessage(model)
      self.messageTable.reloadData()
      self.chatLayout.messageTableScrollToBottom(false)
    }
    
  }
  
  func relayoutTableCellWithMsgId(_ messageId:String) {
    if messageId == "" { return }
    
    let indexPath = self.messageDataSource.tableIndexPathWithMessageId(messageId)

    let messageCell = self.messageTable.cellForRow(at: indexPath) as? JChatMessageCell
    messageCell?.layoutAllViews()
  }
  
// TODO:
  func startRecordingVoice() {
    
  }

  func finishRecordingVoice(_ filePath:String, durationTime:Double) {
    self.SendMessageWithVoice(filePath, durationTime: durationTime)
  }
  
  func cancelRecordingVoice() {
    
  }

  // moreview delegate
  func photoClick() {
    let lib:ALAssetsLibrary = ALAssetsLibrary()
    lib.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group, stop) -> Void in
      let photoPickerVC = JMUIMultiSelectPhotosViewController()
      photoPickerVC.photoDelegate = self
      self.present(photoPickerVC, animated: true, completion: nil)
      
      }) { (error) -> Void in
        let alertView = UIAlertView(title: "没有相册权限", message: "请到设置页面获取相册权限", delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
  }
  
  func locationClick() {
    self.locationManager.getCurrentLocation()
  }
  
  func cameraClick() {
    
  }
}

extension JChatChattingViewController : JChatLocationDelegate {
  
  func currentLocationCallBack(location:CLLocation) {
    self.locationManager.getLocationImage(location: location, size: CGSize(width: 200, height: 100))
  }
  
  func locationImageCallBack(location:CLLocation, image:UIImage?) {
    //    发送消息
    self.sendLocationMessage(location: location, placeholdImg:image!)

    //    接收消息
  }
}
  
extension JChatChattingViewController : JMUIMultiSelectPhotosDelegate {

  func jmuiMultiSelectedPhotoArray(_ selected_photo_array: [Any]!) {
    for image in selected_photo_array {
      self.prepareSendImageMessage(image as! UIImage)
    }
  }
}


// TODO:
extension JChatChattingViewController : JChatMessageCellDelegate {

  func selectHeadView(_ model:JChatMessageModel) {
    if model.message.fromUser.isEqual(to: JMSGUser.myInfo()) {
      let myInfoVC = JChatUserInfoViewController()
      self.navigationController?.pushViewController(myInfoVC, animated: true)
    } else {
      let friendInfoVC = JChatFriendDetailViewController()
      friendInfoVC.user = model.message.fromUser
      if conversation.conversationType == .group {
        friendInfoVC.isGroupFlag = true
      } else {
        friendInfoVC.isGroupFlag = false
      }
      
      self.navigationController?.pushViewController(friendInfoVC, animated: true)
    }
  }
  
  //  picture
  func tapPicture(_ messageModel: JChatMessageModel, tableViewCell: UITableViewCell) {
    let browserImageVC = JChatImageBrowserViewController()
    let tmpImageArr = self.messageDataSource.imageMessageArr
    browserImageVC.imageArr = tmpImageArr
    print("\(tmpImageArr?.index(of: messageModel))")
    browserImageVC.imgCurrentIndex = (tmpImageArr?.index(of: messageModel))!
    
    self.present(browserImageVC, animated: true) {
    
    }
  }
  
  //  voice
  func getContinuePlay(_ cell:UITableViewCell) {
  
  }
  
  func successionalPlayVoice(_ cell:UITableViewCell) {
    
  }
}


extension JChatChattingViewController: JMessageDelegate {

  @nonobjc func onSendMessageResponse(_ message: JMSGMessage!, error: NSError!) {
    print("Event - sendMessageResponse")
    self.relayoutTableCellWithMsgId(message.msgId)
    
    if message != nil { print("发送的消息为 msgId 为 \(message.msgId)") }
    
    if error != nil {
      print("Send response error \(NSString.errorAlert(error))")
      self.conversation.clearUnreadCount()
      MBProgressHUD.showMessage(NSString.errorAlert(error), view: self.view)
    }
  }
  
  func onReceive(_ message: JMSGMessage!, error: NSError!) {
    self.conversation.clearUnreadCount()
    if message != nil {
      print("收到 message msgID 为 \(message.msgId)")
    } else {
      print("收到message 为 nil")
    }
    
    if error != nil {
      return
    }
    
    if !self.conversation.isMessage(forThisConversation: message) {
      return
    }
    
    if message.contentType == .custom { return }

    if messageDataSource.isContaintMessage(message.msgId) { print("该条消息已加载") }

    if message.contentType == .eventNotification {}
    
    if message.contentType == .location {
      let locationContent = message.content! as! JMSGLocationContent
      let location = CLLocation(latitude: CLLocationDegrees(locationContent.latitude), longitude: CLLocationDegrees(locationContent.longitude))
      let locationImgGetter = JChatLocationManager()
      
      locationImgGetter.getLocationImageCallBack(location: location, size: locationImageSizeDefault, callback: { (locationImage) in
        JChatFileManage.sharedInstance.writeImage(name: "\(message.msgId).png", image: locationImage)
        let model = JChatMessageModel()
        model.setChatModel(message, conversation: self.conversation)
        self.appendMessage(model)
      })
    } else {
      let model = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.appendMessage(model)
    }
    
  }

  func onReceiveMessageDownloadFailed(_ message: JMSGMessage!) {
    print("Event - receiveMessageNotification")
    
    if self.conversation.isMessage(forThisConversation: message) == false { return }
    
    if message == nil { print("get nil message") }
    
    if self.conversation.isMessage(forThisConversation: message) {
      let model = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.appendMessage(model)
    }
  }
}

func hideKeyBoardAnimation() {
  DispatchQueue.main.async { 
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  
}
