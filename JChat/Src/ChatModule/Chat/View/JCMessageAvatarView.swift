//
//  JCMessageAvatarView.swift
//  JChat
//
//  Created by deng on 10/04/2017.
//  Copyright © 2017 HXHG. All rights reserved.
//

import UIKit

open class JCMessageAvatarView: UIImageView, JCMessageContentViewType {
    
    weak var delegate: JCMessageDelegate?
    
    public override init(image: UIImage?) {
        super.init(image: image)
        _commonInit()
    }
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        _commonInit()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    open func apply(_ message: JCMessageType, _ indexPath: IndexPath?) {
        self.message = message
        if message.senderAvator != nil {
            self.image = message.senderAvator
            return
        }
        self.image = userDefaultIcon
        weak var weakSelf = self
        message.sender?.thumbAvatarData({ (data, id, error) in
            if data != nil {
                weakSelf?.image = UIImage(data: data!)
            }
        })
    }
    
    private var message: JCMessageType!
    private lazy var userDefaultIcon = UIImage.loadImage("com_icon_user_36")
    
    private func _commonInit() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(_tapHandler))
        self.addGestureRecognizer(tapGR)
        self.isUserInteractionEnabled = true
        layer.masksToBounds = true
    }
    
    func _tapHandler(sender:UITapGestureRecognizer) {
        delegate?.tapAvatarView?(message: message)
    }
}
