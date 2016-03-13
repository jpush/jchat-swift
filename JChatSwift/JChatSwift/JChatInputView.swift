//
//  JChatInputView.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

let keyboardAnimationDuration = 0.25

protocol JChatInputViewDelegate:NSObjectProtocol {
  // sendText
  func sendTextMessage(messageText:String)
  
  // recordVoice
  func startRecordingVoice()
  func finishRecordingVoice(filePath:String,  durationTime:Double)
  func cancelRecordingVoice()

  // photo
  func showMoreView()
  func photoClick()
}

class JChatInputView: UIView {
  var inputWrapView:UIView!
  var switchBtn:UIButton!
  var inputTextView:UITextView!
  var recordVoiceBtn:UIButton!
  var showMoreBtn:UIButton!
  var isTextInput:Bool!
  
  var moreView:UIView!
  var showPhotoBtn:UIButton!
  
  var recordingHub:JChatRecordingView!
  var recordHelper:JChatRecordVoiceHelper!
  
  weak var inputDelegate:JChatInputViewDelegate!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupAllViews()

    self.recordHelper = JChatRecordVoiceHelper()
  }
  
  func setupAllViews() {
    self.isTextInput = true
    
    // 更多功能展示
    self.moreView = UIView()
    self.addSubview(self.moreView!)
    self.moreView.backgroundColor = UIColor.lightGrayColor()
    
    self.inputWrapView = UIView()
    self.inputWrapView.backgroundColor = UIColor.grayColor()
    self.addSubview(inputWrapView)
    
    moreView?.snp_makeConstraints(closure: { (make) -> Void in
      make.left.right.equalTo(self)
      make.height.equalTo(0)
      make.bottom.equalTo(self.snp_bottom)
      make.top.equalTo(self.inputWrapView.snp_bottom)
    })
    
    self.showPhotoBtn = UIButton()
    self.moreView.addSubview(self.showPhotoBtn)
    self.showPhotoBtn.setBackgroundImage(UIImage(named: "photo_24"), forState: .Normal)
    self.showPhotoBtn.addTarget(self, action: Selector("clickShowPhotoBtn"), forControlEvents: .TouchUpInside)
    self.showPhotoBtn.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.moreView).offset(10)
      make.left.equalTo(self.moreView).offset(10)
      make.size.equalTo(CGSize(width: 50, height: 50))
    }
    
    // 输入框的view
    self.inputWrapView.snp_makeConstraints { (make) -> Void in
      make.left.right.top.equalTo(self)
      make.bottom.equalTo(inputWrapView.snp_top)
      make.height.equalTo(35)
    }
    
    // 切换  录音 和 文本输入
    self.switchBtn = UIButton()
    self.switchBtn.setBackgroundImage(UIImage(named: "voice_toolbar"), forState: .Normal)
    self.switchBtn.setBackgroundImage(UIImage(named: "keyboard_toolbar"), forState: .Selected)
    self.switchBtn.contentMode = .ScaleAspectFit
    self.switchBtn.addTarget(self, action: Selector("changeInputMode"), forControlEvents: .TouchUpInside)
    self.addSubview(self.switchBtn!)
    switchBtn?.snp_makeConstraints(closure: { (make) -> Void in
      make.left.equalTo(inputWrapView).offset(4)
      make.bottom.equalTo(inputWrapView).offset(-4)
      make.size.equalTo(CGSize(width: 27, height: 27))
    })
    
    // 其他功能展示
    self.showMoreBtn = UIButton()
    self.showMoreBtn.setBackgroundImage(UIImage(named: "add01"), forState: .Normal)
    self.showMoreBtn.setBackgroundImage(UIImage(named: "add01_pre"), forState: .Highlighted)
    self.showMoreBtn.addTarget(self, action: Selector("changeMoreViewStatus"), forControlEvents: .TouchUpInside)
    self.addSubview(self.showMoreBtn)
    showMoreBtn?.snp_makeConstraints(closure: { (make) -> Void in
      make.right.equalTo(inputWrapView).offset(-4)
      make.bottom.equalTo(inputWrapView).offset(-4)
      make.size.equalTo(CGSize(width: 27, height: 27))
    })
    
    // 输入宽的大小
    self.inputTextView = UITextView()
    self.inputTextView.layer.borderWidth = 0.5
    self.inputTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.inputTextView.layer.cornerRadius = 2
    self.inputTextView.returnKeyType = .Send
    self.inputTextView.delegate = self
    self.inputTextView.enablesReturnKeyAutomatically = true
    self.addSubview(self.inputTextView!)
    inputTextView?.snp_makeConstraints(closure: { (make) -> Void in
      make.right.equalTo(self.showMoreBtn.snp_left).offset(-5)
      make.left.equalTo(self.switchBtn.snp_right).offset(5)
      make.top.equalTo(inputWrapView).offset(5)
      make.bottom.equalTo(inputWrapView).offset(-5)
      make.height.greaterThanOrEqualTo(20)
    })
    self.updateInputTextViewHeight(self.inputTextView)
    
    // 录音按钮
    self.recordVoiceBtn = UIButton()
    self.addSubview(self.recordVoiceBtn)
    
    self.recordVoiceBtn.backgroundColor = UIColor.blueColor()
    self.recordVoiceBtn.hidden = true
    self.recordVoiceBtn.setTitle("按住 说话", forState: .Normal)
    self.recordVoiceBtn.setTitle("松开 结束", forState: .Highlighted)
    self.recordVoiceBtn.addTarget(self, action: Selector("holdDownButtonTouchDown"), forControlEvents: .TouchDown)
    self.recordVoiceBtn.addTarget(self, action: Selector("holdDownButtonTouchUpInside"), forControlEvents: .TouchUpInside)
    self.recordVoiceBtn.addTarget(self, action: Selector("holdDownButtonTouchUpOutside"), forControlEvents: .TouchUpOutside)
    self.recordVoiceBtn.addTarget(self, action: Selector("holdDownDragOutside"), forControlEvents: .TouchDragExit)
    self.recordVoiceBtn.addTarget(self, action: Selector("holdDownDragInside"), forControlEvents: .TouchDragEnter)
    self.recordVoiceBtn.snp_makeConstraints { (make) -> Void in
      make.right.equalTo(self.showMoreBtn.snp_left).offset(-5)
      make.left.equalTo(self.switchBtn.snp_right).offset(5)
      make.top.equalTo(inputWrapView).offset(5).priorityRequired()
      make.bottom.equalTo(inputWrapView).offset(-5)
      make.height.equalTo(35).priorityLow()
    }
    
  }
  
  func clickShowPhotoBtn() {
    self.inputDelegate.photoClick()
  }
  
  func holdDownButtonTouchDown() {
    self.inputDelegate.startRecordingVoice()
    if self.recordingHub == nil {
      self.recordingHub = JChatRecordingView(frame: CGRectZero)
      self.recordHelper.updateMeterDelegate = self.recordingHub
    }
//    self.superview?.addSubview(self.recordingHub)
    self.recordingHub.startRecordingHUDAtView(self.superview!)
    self.recordingHub.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.superview!)
      make.size.equalTo(CGSize(width: 140, height: 140))
    }
    self.recordHelper.startRecordingWithPath(self.getRecorderPath()) { () -> Void in
      
    }
  }
  
  func holdDownButtonTouchUpInside() {
    self.recordHelper.finishRecordingCompletion()
    self.recordingHub.removeFromSuperview()
    if (self.recordHelper.recordDuration as! NSString).floatValue < 1 {
      MBProgressHUD.showMessage("录音时长小于 1s", view: UIApplication.sharedApplication().keyWindow!)
      return
    }
    self.inputDelegate.finishRecordingVoice(self.recordHelper.recordPath!, durationTime: Double(self.recordHelper.recordDuration!)!)
  }
  
  func holdDownButtonTouchUpOutside() {
    self.recordHelper.cancelledDeleteWithCompletion()
    self.recordingHub.removeFromSuperview()

  }
  
  func holdDownDragOutside() {
    self.recordingHub.resaueRecord()
    
  }
  
  func holdDownDragInside() {
    self.recordingHub.pauseRecord()
    
  }
  
  func changeInputMode() {
    self.isTextInput = !self.isTextInput
    if self.isTextInput == true {
      self.recordVoiceBtn.hidden = true
      self.inputTextView.hidden = false
      self.updateInputTextViewHeight(self.inputTextView)
      self.inputTextView.becomeFirstResponder()
    } else {
      self.recordVoiceBtn.hidden = false
      self.inputTextView.hidden = true
      self.inputTextView.resignFirstResponder()
      self.inputTextView.snp_updateConstraints(closure: { (make) -> Void in
        make.height.equalTo(35)
      })
    }
  }
  
  func changeMoreViewStatus() {
    CATransaction.begin()
    hideKeyBoardAnimation()
    self.superview!.layoutIfNeeded()
    self.moreView.snp_updateConstraints { (make) -> Void in
      make.height.equalTo(150)
    }
    UIView.animateWithDuration(keyboardAnimationDuration) { () -> Void in

      self.superview!.layoutIfNeeded()
    }
    CATransaction.commit()
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func getRecorderPath() -> String {
    var recorderPath:String? = nil
    let now:NSDate = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yy-MMMM-dd"
    recorderPath = "\(NSHomeDirectory())/Documents/"
    
    dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
    recorderPath?.appendContentsOf("\(dateFormatter.stringFromDate(now))-MySound.ilbc")
    return recorderPath!
  }
}


extension JChatInputView:UITextViewDelegate {
  func textViewDidChange(textView: UITextView) {
    self.updateInputTextViewHeight(textView)
  }
  
  func updateInputTextViewHeight(textView: UITextView) {
    let textContentH = textView.contentSize.height
    print("output：\(textContentH)")
    let textHeight = textContentH > 35 ? (textContentH<100 ? textContentH:100):30
    UIView.animateWithDuration(0.2) { () -> Void in
      self.inputTextView.snp_updateConstraints(closure: { (make) -> Void in
        make.height.equalTo(textHeight)
      })
    }
    
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      self.inputDelegate.sendTextMessage(self.inputTextView.text)
      self.inputTextView.text = ""
      return false
    }
    return true
  }
}
