//
//  JChatMessageImageCollectionViewCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/6/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import JMessage

@objc public protocol JCImageBrowserCellDelegate: NSObjectProtocol {
    @objc optional func singleTap()
}

@objc(JChatMessageImageCollectionViewCell)
class JChatMessageImageCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: JCImageBrowserCellDelegate?

  @IBOutlet weak var messageImageContent: UIScrollView!
  var messageImage:UIImageView!
  weak var messageModel:JChatMessageModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    messageImage = UIImageView()
    messageImage.contentMode = .scaleAspectFit
    messageImage.backgroundColor = UIColor.black
    messageImage.frame = UIScreen.main.bounds
    
    messageImageContent.addSubview(messageImage)
    messageImageContent.delegate = self
    messageImageContent.maximumZoomScale = 2.0
    messageImageContent.minimumZoomScale = 1.0
    messageImageContent.contentSize = messageImageContent.frame.size
    
    let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapImage(_:)))
    singleTapGesture.numberOfTapsRequired = 1
    self.addGestureRecognizer(singleTapGesture)
    
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapImage(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    self.addGestureRecognizer(doubleTapGesture)
    
    singleTapGesture.require(toFail: doubleTapGesture)
    
  }
    
    func singleTapImage(_ gestureRecognizer:UITapGestureRecognizer)  {
        delegate?.singleTap?()
    }
    func doubleTapImage(_ gestureRecognizer:UITapGestureRecognizer) {
        self.adjustImageScale()
    }
  
  func adjustImageScale() {
    if messageImageContent.zoomScale > 1.5 {
      messageImageContent.setZoomScale(1.0, animated: true)
    } else {
      messageImageContent.setZoomScale(2.0, animated: true)
      
    }
  }
    
    func setImage(image: UIImage) {
        self.messageImage.image = image
    }
  
  internal func setImage(_ model:JChatMessageModel) {
    messageModel = model
    (model.message.content as? JMSGImageContent)?.thumbImageData { (data, msgId, error) in
      if msgId == self.messageModel?.message.msgId {
        self.messageImage.image = UIImage(data: data!)!;
      }
      
      (model.message.content as! JMSGImageContent).largeImageData(progress: { (percent, msgId) in

        }, completionHandler: { (data, msgId, error) in
          if error == nil {
            
            if msgId != self.messageModel?.message.msgId {
              return
            }
            
            self.messageImage.image = UIImage(data: data!)
          } else {
          }
      })

      if error != nil {
        print("get thumb image fail")
      }
    }
  }
}

extension JChatMessageImageCollectionViewCell:UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return messageImage
  }
  }
