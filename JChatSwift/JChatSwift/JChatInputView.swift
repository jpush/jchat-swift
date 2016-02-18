//
//  JChatInputView.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatInputView: UIView {
  var inputWrapView:UIView!
  var switchBtn:UIButton!
  var inputTextView:UITextView!
  var showMoreBtn:UIButton!
  var moreView:UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    // 更多功能展示
    self.moreView = UIView()
    self.addSubview(self.moreView!)
    self.moreView.backgroundColor = UIColor.lightGrayColor()
    
    moreView?.snp_makeConstraints(closure: { (make) -> Void in
      make.left.right.equalTo(self)
      make.height.equalTo(250)
    })
    
    // 输入框的view
    self.inputWrapView = UIView()
    self.inputWrapView.backgroundColor = UIColor.grayColor()
    self.addSubview(inputWrapView)
    self.inputWrapView.snp_makeConstraints { (make) -> Void in
      make.left.right.top.equalTo(self)
      make.bottom.equalTo(inputWrapView)
      make.height.equalTo(45)
    }
    
    // 切换  录音 和 文本输入
    self.switchBtn = UIButton()
    self.switchBtn.setBackgroundImage(UIImage(named: "voice_toolbar"), forState: .Normal)
    self.switchBtn.setBackgroundImage(UIImage(named: "keyboard_toolbar"), forState: .Selected)
    self.addSubview(self.switchBtn!)
    switchBtn?.snp_makeConstraints(closure: { (make) -> Void in
      make.left.equalTo(inputWrapView).offset(4)
      make.top.equalTo(inputWrapView).offset(4)
      make.size.equalTo(CGSize(width: 27, height: 27))
    })
    
    // 其他功能展示
    self.showMoreBtn = UIButton()
    self.showMoreBtn.setBackgroundImage(UIImage(named: "add01"), forState: .Normal)
    self.showMoreBtn.setBackgroundImage(UIImage(named: "add01_pre"), forState: .Highlighted)
    self.addSubview(self.showMoreBtn)
    showMoreBtn?.snp_makeConstraints(closure: { (make) -> Void in
      make.right.equalTo(inputWrapView).offset(-4)
      make.top.equalTo(inputWrapView).offset(4)
      make.size.equalTo(CGSize(width: 27, height: 27))
    })
    
    // 输入宽的大小
    self.inputTextView = UITextView()
    self.inputTextView.layer.borderWidth = 0.5
    self.inputTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.inputTextView.layer.cornerRadius = 2
    self.inputTextView.returnKeyType = .Send

    self.addSubview(self.inputTextView!)
    inputTextView?.snp_makeConstraints(closure: { (make) -> Void in
      make.right.equalTo(self.showMoreBtn.snp_left).offset(-5)
      make.left.equalTo(self.switchBtn.snp_right).offset(5)
      make.top.equalTo(inputWrapView).offset(5)
      make.bottom.equalTo(inputWrapView).offset(-5)
    })


  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
