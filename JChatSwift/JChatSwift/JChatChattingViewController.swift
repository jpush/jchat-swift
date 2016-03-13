//
//  JChatChattingViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

internal let interval = 60
internal let messagePageNumber = 25
internal let messageFristPageNumber = 20


class JChatChattingViewController: UIViewController {
  
  var conversation:JMSGConversation!
  
  var messageTable:JChatMessageTable!
  var messageInputView:JChatInputView!
  var messageDataSource:JChatChattingDataSource!
  var chatLayout:JChatChattingLayout!
  var messageOffset = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Action - viewDidLoad")
    self.setupNavigation()
    self.setupAllViews()
    self.setupDataSource()
    self.addAllNotification()
    
    self.chatLayout = JChatChattingLayout(messageTable: self.messageTable, inputView: self.messageInputView)
    
    let gesture = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
    gesture.delegate = self
    self.messageTable.addGestureRecognizer(gesture)

  }
  
  override func viewDidLayoutSubviews() {
    self.chatLayout.messageTableScrollToBottom(false)
  }
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
    JMessage.removeDelegate(self, withConversation: self.conversation)
  }
  
  func setupNavigation() {
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.navigationBar.translucent = false
    self.title = "会话"
    let leftBtn = UIButton(type: .Custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: Selector("backClick"), forControlEvents: .TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)

    let rightBtn = UIButton(type: .Custom)
    rightBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
    rightBtn.addTarget(self, action: Selector("clickRightBtn"), forControlEvents: .TouchUpInside)
    rightBtn.setImage(UIImage(named: "createConversation"), forState: .Normal)
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15 * UIScreen.mainScreen().scale)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
  }
  
  func addAllNotification() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("cleanMessageCache"), name: kDeleteAllMessage, object: nil)
    
    JMessage.addDelegate(self, withConversation: self.conversation)
  }
  
  @objc func cleanMessageCache() {
    self.messageDataSource.cleanCache()
    self.messageTable.reloadData()
  }
  
  @objc func backClick() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @objc func clickRightBtn() {
    let detailCtl = JCHATGroupDetailViewController()
    detailCtl.conversation = self.conversation
    detailCtl.chattingVC = self
    self.navigationController?.pushViewController(detailCtl, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  override func viewWillAppear(animated: Bool) {
    print("Action - viewWillAppear")
    super.viewWillAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardFrameChanged:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
    self.messageTable.reloadData()
  }

  func setupAllViews() {
    self.view.backgroundColor = UIColor.whiteColor()
    
    self.messageInputView = JChatInputView(frame: CGRectZero)
    self.view.addSubview(messageInputView)
    self.messageInputView.inputDelegate = self
    self.messageInputView.snp_makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.view)
    }
    
    self.messageInputView.moreView.snp_makeConstraints { (make) -> Void in
      make.bottom.equalTo(self.view.snp_bottom)
    }
    //init messageTable
    self.messageTable = JChatMessageTable(frame: CGRectZero)
    self.messageTable.separatorStyle = .None
    self.messageTable.backgroundColor = kTableViewBackgroupColor
    self.messageTable.delegate = self
    self.messageTable.dataSource = self
    self.messageTable.keyboardDismissMode = .Interactive
    self.view.addSubview(messageTable)
    self.messageTable.snp_makeConstraints { (make) -> Void in
      make.top.left.right.equalTo(self.view)
      make.bottom.equalTo(self.messageInputView.snp_top)
    }
  }
  
  func setupDataSource() {
    self.messageDataSource = JChatChattingDataSource(conversation: self.conversation, showTimeInterval: 60 * 5, fristPageNumber: 20, limit: 11)
    self.messageDataSource.getPageMessage()
  }

  func flashToLoadMessage() {
    self.messageDataSource.getMoreMessage()
    self.chatLayout.loadMoreMessage()
  }
  
  @objc func keyboardFrameChanged(notification: NSNotification) {
    let dic = NSDictionary(dictionary: notification.userInfo!)
    let keyboardValue = dic.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
    let bottomDistance = UIScreen.mainScreen().bounds.size.height - keyboardValue.CGRectValue().origin.y
    let duration = Double(dic.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
    
    UIView.animateWithDuration(duration, animations: {
      self.messageInputView.moreView?.snp_updateConstraints(closure: { (make) -> Void in
        make.height.equalTo(bottomDistance)
      })
      self.view.layoutIfNeeded()
      }, completion: {
        (value: Bool) in
    })

  }
}

extension JChatChattingViewController:UITableViewDelegate,UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.messageDataSource.allMessageIdArr.count
  }
  
//  - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//  {
//  NSLog(@"Estimating height (row %d)", indexPath.row);
//  return _estimationBlock(indexPath.row);
//  }

//  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    let cell = tableView.cellForRowAtIndexPath(indexPath)
//    return (cell?.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height)!
//
//
//    
//  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if self.messageDataSource.noMoreHistoryMessage() != true {
      if indexPath.row == 0 {
        return 25
      }
    }

    let model = self.messageDataSource.getMessageWithIndex(indexPath.row)
    
    if model.isKindOfClass(JChattimeModel) {
      return 25
    } else {
      return (model as! JChatMessageModel).messageCellHeight
    }
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    print("Action - cellForRowAtIndexPath")
    if self.messageDataSource.noMoreHistoryMessage() != true {
      if indexPath.row == 0 {
        let cell:JChatLoadingMessageCell = JChatTableCellMaker.LoadingCellInTable(tableView)
        cell.startLoading()
        self.flashToLoadMessage()
        return cell
      }
    }
  
    let model = self.messageDataSource.getMessageWithIndex(indexPath.row)

    if model.isKindOfClass(JChattimeModel) {
      let cell:JChatShowTimeCell = JChatTableCellMaker.timeCellInTable(tableView)
      cell.layoutModel(model as! JChattimeModel)
      return cell
    } else {

      let message = (model as! JChatMessageModel).message
      if message.isReceived {
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
  func handleTap(recognizer: UITapGestureRecognizer) {
    hideKeyBoardAnimation()

    UIView.animateWithDuration(keyboardAnimationDuration) { () -> Void in
      self.view.layoutIfNeeded()
      self.messageInputView.moreView.snp_updateConstraints { (make) -> Void in
        make.height.equalTo(0)
      }
      self.view.layoutIfNeeded()
    }
  }
}


extension JChatChattingViewController:JChatInputViewDelegate {
  
  func showMoreView() {
    hideKeyBoardAnimation()
    UIView.animateWithDuration(0.25) { () -> Void in
      self.messageInputView.moreView?.snp_updateConstraints(closure: { (make) -> Void in
        make.bottom.equalTo(self.view.snp_bottom)
      })
    }
  }
  
  func appendMessage(model:JChatMessageModel) {
    self.messageDataSource.appendMessage(model)
    self.chatLayout.appendTableViewCellAtLastIndex(self.messageDataSource.messageCount())
  }

  func appendTimeDate(timeInterVal:NSTimeInterval) {
    self.appendTimeDate(timeInterVal)
    self.chatLayout.appendTableViewCellAtLastIndex(self.messageDataSource.messageCount())
  }
  
  func sendTextMessage(messageText: String) {
    let textContent:JMSGTextContent = JMSGTextContent(text: messageText)
    let textMessage:JMSGMessage = self.conversation.createMessageWithContent(textContent)!
    self.conversation.sendMessage(textMessage)
    let textModel:JChatMessageModel = JChatMessageModel()
    textModel.setChatModel(textMessage, conversation: self.conversation)
    self.appendMessage(textModel)
  }
  
  func SendMessageWithVoice(voicePath:String, durationTime:Double) {
    print("SendMessageWithVoice")
    let voiceContent:JMSGVoiceContent = JMSGVoiceContent(voiceData: NSData(contentsOfFile: voicePath)!, voiceDuration: Int(durationTime))
    let voiceMessage:JMSGMessage? = self.conversation.createMessageWithContent(voiceContent)
    self.conversation.sendMessage(voiceMessage!)
    let voicemodel:JChatMessageModel = JChatMessageModel()
    voicemodel.setChatModel(voiceMessage, conversation: self.conversation)
    self.appendMessage(voicemodel)
  }
  
  func prepareSendImageMessage(image:UIImage) {
    var message:JMSGMessage? = nil
    let imageContent = JMSGImageContent(imageData: UIImagePNGRepresentation(image)!)
    if imageContent != nil {
      message = self.conversation.createMessageWithContent(imageContent!)
      JChatSendImageManager.sharedInstance.addMessage(message!, withConversation: self.conversation)
      let model:JChatMessageModel = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.appendMessage(model)
    }
  }
  
  func relayoutTableCellWithMsgId(messageId:String) {
    if messageId == "" { return }
    
    let indexPath = self.messageDataSource.tableIndexPathWithMessageId(messageId)

    let messageCell = self.messageTable.cellForRowAtIndexPath(indexPath) as? JChatMessageCell
    messageCell?.layoutAllViews()
  }
  
// TODO:
  func startRecordingVoice() {
    
  }

  func finishRecordingVoice(filePath:String, durationTime:Double) {
    self.SendMessageWithVoice(filePath, durationTime: durationTime)
  }
  
  func cancelRecordingVoice() {
    
  }
  
  func photoClick() {
    let lib:ALAssetsLibrary = ALAssetsLibrary()
    lib.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group, stop) -> Void in
      let photoPickerVC = JMUIMultiSelectPhotosViewController()
      photoPickerVC.photoDelegate = self
      self.presentViewController(photoPickerVC, animated: true, completion: nil)
      
      }) { (error) -> Void in
        let alertView = UIAlertView(title: "没有相册权限", message: "请到设置页面获取相册权限", delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
  }
}

extension JChatChattingViewController : JMUIMultiSelectPhotosDelegate {

  func JMUIMultiSelectedPhotoArray(selected_photo_array: [AnyObject]!) {
    for image in selected_photo_array {
     self.prepareSendImageMessage(image as! UIImage)
    }

  }
}


// TODO:
extension JChatChattingViewController : JChatMessageCellDelegate {

  func selectHeadView(model:JChatMessageModel) {
    if model.message.fromUser.isEqualToUser(JMSGUser.myInfo()) {
      let myInfoVC = JChatUserInfoViewController()
      self.navigationController?.pushViewController(myInfoVC, animated: true)
    } else {
      let friendInfoVC = JChatFriendDetailViewController()
      friendInfoVC.user = model.message.fromUser
      self.navigationController?.pushViewController(friendInfoVC, animated: true)
    }
  }
  
  //  picture
  func tapPicture(index:Int, tapView:UIImageView, tableViewCell:UITableViewCell) {
  
  }
  
  //  voice
  func getContinuePlay(cell:UITableViewCell) {
  
  }
  
  func successionalPlayVoice(cell:UITableViewCell) {
    
  }
}


extension JChatChattingViewController: JMessageDelegate {

  func onSendMessageResponse(message: JMSGMessage!, error: NSError!) {
    print("Event - sendMessageResponse")
    self.relayoutTableCellWithMsgId(message.msgId)
    
    if message != nil { print("发送的消息为 msgId 为 \(message.msgId)") }
    
    if error != nil {
      print("Send response error \(NSString.errorAlert(error))")
      self.conversation.clearUnreadCount()
      MBProgressHUD.showMessage(NSString.errorAlert(error), view: self.view)
    }
  }

  func onReceiveMessage(message: JMSGMessage!, error: NSError!) {
    self.conversation.clearUnreadCount()
    if message != nil {
      print("收到 message msgID 为 \(message.msgId)")
    } else {
      print("收到message 为 nil")
    }
    
    if error != nil {
      return
    }
    
    if !self.conversation.isMessageForThisConversation(message) {
      return
    }
    
    if message.contentType == .Custom { return }

    if messageDataSource.isContaintMessage(message.msgId) { print("该条消息已加载") }

    if message.contentType == .EventNotification {}
    
    let model = JChatMessageModel()
    model.setChatModel(message, conversation: self.conversation)
    self.appendMessage(model)
  }

  func onReceiveMessageDownloadFailed(message: JMSGMessage!) {
    print("Event - receiveMessageNotification")
    
    if self.conversation.isMessageForThisConversation(message) == false { return }
    
    if message == nil { print("get nil message") }
    
    if self.conversation.isMessageForThisConversation(message) {
      let model = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.appendMessage(model)
    }
  }
}

func hideKeyBoardAnimation() {
  UIApplication.sharedApplication().sendAction(Selector("resignFirstResponder"), to: nil, from: nil, forEvent: nil)
}
