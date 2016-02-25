//
//  JChatChattingViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

internal let interval = 60
internal let messagePageNumber = 25
internal let messageFristPageNumber = 20


class JChatChattingViewController: UIViewController {
  var conversation:JMSGConversation!
  
  var messageTable:UITableView!
  var messageInputView:JChatInputView!
  var messageDataSource:JChatChattingDataSource!
  var chatLayout:JChatChattingLayout!
  
  var messageOffset = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Action - viewDidLoad")
    self.setupAllViews()
    self.setupDataSource()
    
    self.chatLayout = JChatChattingLayout(messageTable: self.messageTable, inputView: self.messageInputView)
    
    
    let gesture = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
    gesture.delegate = self
    self.messageTable.addGestureRecognizer(gesture)

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
    self.messageTable = UITableView(frame: CGRectZero)
    self.messageTable.backgroundColor = UIColor.yellowColor()
    self.messageTable.delegate = self
    self.messageTable.dataSource = self
    self.messageTable.keyboardDismissMode = .Interactive
    self.messageTable.estimatedRowHeight = 60
    self.messageTable.rowHeight = UITableViewAutomaticDimension
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JChatChattingViewController:UITableViewDelegate,UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.messageDataSource.allMessageIdArr.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    print("Action - cellForRowAtIndexPath")
    if self.messageDataSource.noMoreHistoryMessage() != false {
      if indexPath.row == 0 {
        let cell:JChatLoadingMessageCell = JChatTableCellMaker.LoadingCellInTable(tableView)
        cell.startLoading()
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
  
  func relayoutTableCellWithMsgId(messageId:String) {
    if messageId == "" { return }
    
    let indexPath = self.messageDataSource.tableIndexPathWithMessageId(messageId)
    let messageCell:JChatMessageCell = self.messageTable.cellForRowAtIndexPath(indexPath) as! JChatMessageCell
    messageCell.layoutAllViews()
  }
  
  func startRecordingVoice() {
    
  }
  
  func finishRecordingVoice(filePath:String) {
    
  }
  
  func cancelRecordingVoice() {
    
  }
}


extension JChatChattingViewController : JChatMessageCellDelegate {
  func tapPicture(index:Int, tapView:UIImageView, tableViewCell:UITableViewCell) {
  
  }
  
  func selectHeadView(model:JChatMessageModel) {
    
  }
}

func hideKeyBoardAnimation() {
  UIApplication.sharedApplication().sendAction(Selector("resignFirstResponder"), to: nil, from: nil, forEvent: nil)
}
