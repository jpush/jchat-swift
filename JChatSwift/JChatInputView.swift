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
  func sendTextMessage(_ messageText:String)
  
  // recordVoice
  func startRecordingVoice()
  func finishRecordingVoice(_ filePath:String,  durationTime:Double)
  func cancelRecordingVoice()

  // photo
  func showMoreView()
  func photoClick()
}

protocol JChatInputDelegate:JChatMoreViewDelegate,JChatInputViewDelegate {
  
}

class JChatInputView: UIView {
  var inputWrapView:UIView!
  var switchBtn:UIButton!
  var inputTextView:JChatMessageInputView!
  var recordVoiceBtn:UIButton!
  var showMoreBtn:UIButton!
  var isTextInput:Bool!
  
  var moreView:UICollectionView!
  var moreViewManager:JChatMoreViewManager!
  var showPhotoBtn:UIButton!
  
  var recordingHub:JChatRecordingView!
  var recordHelper:JChatRecordVoiceHelper!
  
  weak var inputDelegate:JChatInputDelegate!
  
  init(delegate: JChatInputDelegate!) {
    
    super.init(frame: CGRect.zero)
    self.inputDelegate = delegate
    self.setupAllViews()

    self.recordHelper = JChatRecordVoiceHelper()
  }
  
  func setupAllViews() {
    self.isTextInput = true
    
    // 更多功能展示
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
//    flowLayout.sectionInset = UIEdgeInsets(top: 23, left: 20, bottom: 35, right: 20)
    flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    self.moreView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    self.moreViewManager = JChatMoreViewManager(moreView: self.moreView, delegate:self.inputDelegate)
    

    self.addSubview(self.moreView!)
    self.moreView.backgroundColor = UIColor(netHex: 0xececec)
    self.moreViewManager.moreViewdelegate = self.inputDelegate as! JChatMoreViewDelegate!
    
    self.inputWrapView = UIView()
    self.inputWrapView.backgroundColor = UIColor(netHex: 0xdfdfdf)
    self.addSubview(inputWrapView)
    
    moreView?.snp.makeConstraints({ (make) -> Void in
      make.left.right.equalTo(self)
      make.height.equalTo(0)
      make.bottom.equalTo(self.snp.bottom)
      make.top.equalTo(self.inputWrapView.snp.bottom)
    })
    
    // 输入框的view
    self.inputWrapView.snp.makeConstraints { (make) -> Void in
      make.left.right.top.equalTo(self)
      make.bottom.equalTo(inputWrapView.snp.top)
      make.height.equalTo(35)
    }
    
    // 切换  录音 和 文本输入
    self.switchBtn = UIButton()
    self.switchBtn.setImage(UIImage(named: "voice_toolbar"), for: UIControlState())
    self.switchBtn.setImage(UIImage(named: "keyboard_toolbar"), for: .selected)
    
    self.switchBtn.addTarget(self, action: #selector(JChatInputView.changeInputMode), for: .touchUpInside)
    self.addSubview(self.switchBtn!)
    switchBtn?.snp.makeConstraints({ (make) -> Void in
      make.left.equalTo(inputWrapView).offset(4)
      make.bottom.equalTo(inputWrapView).offset(-4)
      make.size.equalTo(CGSize(width: 27, height: 27))
    })
    
    // 其他功能展示
    self.showMoreBtn = UIButton()
    self.showMoreBtn.setBackgroundImage(UIImage(named: "add01"), for: UIControlState())
    self.showMoreBtn.setBackgroundImage(UIImage(named: "add01_pre"), for: .highlighted)
    self.showMoreBtn.addTarget(self, action: #selector(JChatInputView.changeMoreViewStatus), for: .touchUpInside)
    self.addSubview(self.showMoreBtn)
    showMoreBtn?.snp.makeConstraints({ (make) -> Void in
      make.right.equalTo(inputWrapView).offset(-4)
      make.bottom.equalTo(inputWrapView).offset(-4)
      make.size.equalTo(CGSize(width: 27, height: 27))
    })
    
    // 输入框的大小
    self.inputTextView = JChatMessageInputView()
    self.inputTextView.layer.borderWidth = 0.5
    self.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
    self.inputTextView.layer.cornerRadius = 2
    self.inputTextView.returnKeyType = .send
    self.inputTextView.delegate = self
    self.inputTextView.enablesReturnKeyAutomatically = true
    self.addSubview(self.inputTextView!)
    inputTextView?.snp.makeConstraints({ (make) -> Void in
      make.right.equalTo(self.showMoreBtn.snp.left).offset(-5)
      make.left.equalTo(self.switchBtn.snp.right).offset(5)
      make.top.equalTo(self.inputWrapView).offset(5)
      make.bottom.equalTo(self.inputWrapView).offset(-5)
      make.height.greaterThanOrEqualTo(30)
      make.height.lessThanOrEqualTo(100)
      make.height.equalTo(35)
    })
    self.updateInputTextViewHeight(self.inputTextView)
    
    // 录音按钮
    self.recordVoiceBtn = UIButton()
    self.addSubview(self.recordVoiceBtn)
    
    self.recordVoiceBtn.backgroundColor = UIColor(netHex: 0x3f80dc)
    self.recordVoiceBtn.isHidden = true
    self.recordVoiceBtn.setTitle("按住 说话", for: UIControlState())
    self.recordVoiceBtn.setTitle("松开 结束", for: .highlighted)
    self.recordVoiceBtn.addTarget(self, action: #selector(JChatInputView.holdDownButtonTouchDown), for: .touchDown)
    self.recordVoiceBtn.addTarget(self, action: #selector(JChatInputView.holdDownButtonTouchUpInside), for: .touchUpInside)
    self.recordVoiceBtn.addTarget(self, action: #selector(JChatInputView.holdDownButtonTouchUpOutside), for: .touchUpOutside)
    self.recordVoiceBtn.addTarget(self, action: #selector(JChatInputView.holdDownDragOutside), for: .touchDragExit)
    self.recordVoiceBtn.addTarget(self, action: #selector(JChatInputView.holdDownDragInside), for: .touchDragEnter)
    self.recordVoiceBtn.snp.makeConstraints { (make) -> Void in
      make.right.equalTo(self.showMoreBtn.snp.left).offset(-5)
      make.left.equalTo(self.switchBtn.snp.right).offset(5)
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
      self.recordingHub = JChatRecordingView(frame: CGRect.zero)
      self.recordHelper.updateMeterDelegate = self.recordingHub
    }

    self.recordingHub.startRecordingHUDAtView(self.superview!)
    self.recordingHub.snp.makeConstraints { (make) -> Void in
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
      MBProgressHUD.showMessage("录音时长小于 1s", view: UIApplication.shared.keyWindow!)
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
      self.recordVoiceBtn.isHidden = true
      self.inputTextView.isHidden = false
      self.updateInputTextViewHeight(self.inputTextView)
      self.inputTextView.becomeFirstResponder()
    } else {
      self.recordVoiceBtn.isHidden = false
      self.inputTextView.isHidden = true
      self.inputTextView.resignFirstResponder()
      self.inputTextView.snp.updateConstraints({ (make) -> Void in
//        make.height.equalTo(35)
      })
    }
    self.switchBtn.isSelected = !self.switchBtn.isSelected;
  }
  
  func changeMoreViewStatus() {
    CATransaction.begin()
    hideKeyBoardAnimation()
    self.superview!.layoutIfNeeded()
    self.moreView.snp.updateConstraints { (make) -> Void in
      make.height.equalTo(150)
    }
    UIView.animate(withDuration: keyboardAnimationDuration, animations: { () -> Void in

      self.superview!.layoutIfNeeded()
    })
    CATransaction.commit()
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func getRecorderPath() -> String {
    var recorderPath:String? = nil
    let now:Date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yy-MMMM-dd"
    recorderPath = "\(NSHomeDirectory())/Documents/"
    
    dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
    recorderPath?.append("\(dateFormatter.string(from: now))-MySound.ilbc")
    return recorderPath!
  }
}


extension JChatInputView:UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.updateInputTextViewHeight(textView)
  }
  
  func updateInputTextViewHeight(_ textView: UITextView) {
    let textContentH = textView.contentSize.height
    print("output：\(textContentH)")
    let textHeight = textContentH > 35 ? (textContentH<100 ? textContentH:100):31
    

    UIView.animate(withDuration: 0.2) { () -> Void in
      self.inputTextView.snp.updateConstraints({ (make) -> Void in
        make.right.equalTo(self.showMoreBtn.snp.left).offset(-5)
        make.left.equalTo(self.switchBtn.snp.right).offset(5)
        make.top.equalTo(self.inputWrapView).offset(5)
        make.bottom.equalTo(self.inputWrapView).offset(-5)
        make.height.greaterThanOrEqualTo(30)
        make.height.lessThanOrEqualTo(100)
        make.height.equalTo(textHeight)
      })
    }
    
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      self.inputDelegate.sendTextMessage(self.inputTextView.text)
      self.inputTextView.text = ""
      return false
    }
    return true
  }
}
