//
//  JCMessageImageCollectionViewCell.swift
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

@objc(JCMessageImageCollectionViewCell)
class JCMessageImageCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: JCImageBrowserCellDelegate?
    
    @IBOutlet weak var messageImageContent: UIScrollView!
    var messageImage:UIImageView!
    
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
    
    func setMessage(_ message: JMSGMessage) {
        guard let content = message.content as? JMSGImageContent else {
            return
        }
        content.thumbImageData { (data, msgId, error) in
            if msgId == message.msgId {
                self.messageImage.image = UIImage(data: data!)
            }
            
            content.largeImageData(progress: { (percent, msgId) in
                
            }, completionHandler: { (data, msgId, error) in
                if error == nil {
                    if msgId != message.msgId {
                        return
                    }
                    self.messageImage.image = UIImage(data: data!)
                }
            })
        }
    }
}

extension JCMessageImageCollectionViewCell:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return messageImage
    }
}
