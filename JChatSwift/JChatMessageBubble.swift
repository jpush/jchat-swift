//
//  JChatMessageBubble.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/25.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatMessageBubble)
class JChatMessageBubble: UIImageView {
  var maskBackgroupImage:UIImage?
  var maskBackgroupView:UIImageView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    maskBackgroupView = UIImageView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  init(maskImage:UIImage) {
//    super.init(frame: CGRectZero)
//    self.maskBackgroupImage = maskImage
//    self.maskBackgroupImage = self.maskBackgroupImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 28, 20))
//  }
  
  
//  override func layoutIfNeeded() {
//    super.layoutIfNeeded()
////    let maskBackgroupView = UIImageView()
//    self.maskBackgroupView!.image = self.maskBackgroupImage
//    self.maskBackgroupView!.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
//    self.layer.mask = self.maskBackgroupView!.layer
//  }
  override func layoutSubviews() {
    super.layoutSubviews()
    self.maskBackgroupView!.image = self.maskBackgroupImage
    self.maskBackgroupView!.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
    self.layer.mask = self.maskBackgroupView!.layer
  }
}
