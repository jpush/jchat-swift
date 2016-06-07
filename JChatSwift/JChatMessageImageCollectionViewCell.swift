//
//  JChatMessageImageCollectionViewCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/6/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatMessageImageCollectionViewCell)
class JChatMessageImageCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var messageImageContent: UIScrollView!
  var messageImage:UIImageView!
  weak var messageModel:JChatMessageModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    messageImage = UIImageView()
    messageImage.contentMode = .ScaleAspectFit
    messageImage.backgroundColor = UIColor.whiteColor()
    messageImage.image = UIImage(named: "talking_icon_group")
    messageImage.frame = messageImageContent.bounds
    messageImageContent.addSubview(messageImage)
  }
  
  internal func setImage(model:JChatMessageModel) {
    
    
        (model.message.content as! JMSGImageContent).thumbImageData { (data, msgId, error) in
          self.messageImage.image = UIImage(data: data)!;
          (model.message.content as! JMSGImageContent).largeImageDataWithProgress({ (percent, msgId) in
    
            }, completionHandler: { (data, msgId, error) in
              if error == nil {
                self.messageImage.image = UIImage(data: data)
              } else {
                print("get larget image fail \(NSString.errorAlert(error))")
              }
          })
    
          if error != nil {
            print("get thumb image fail")
          }
        }
  }
}
