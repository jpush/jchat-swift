//
//  JCMessageTipsView.swift
//  JChat
//
//  Created by deng on 2017/4/26.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

open class JCMessageTipsView: UIView, JCMessageContentViewType {
    
    weak var delegate: JCMessageDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    open func apply(_ message: JCMessageType) {
        self.message = message
        switch message.options.state {
        case .sending:
            errorInfoView.isHidden = true
            activityView.startAnimating()
        case .sendSucceed:
            errorInfoView.isHidden = true
            activityView.stopAnimating()
        case .sendError:
            activityView.stopAnimating()
            errorInfoView.isHidden = false
        default:
            activityView.stopAnimating()
        }
        if message.content is JCMessageImageContent {
            activityView.stopAnimating()
            activityView.isHidden = true
        }
    }
    
    private var activityView: UIActivityIndicatorView!
    private var errorInfoView: UIImageView!
    private var indexPath: IndexPath?
    private var message: JCMessageType!
    
    private func _commonInit() {
        
        activityView = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 10, height: 10))
        activityView.activityIndicatorViewStyle = .gray
        activityView.isUserInteractionEnabled = false
        addSubview(activityView)
        
        let image = UIImage.loadImage("com_icon_send_error")
        errorInfoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        errorInfoView.isUserInteractionEnabled = true
        errorInfoView.image = image
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(_tapHandler))
        errorInfoView.addGestureRecognizer(tapGR)
        
        errorInfoView.isHidden = true
        addSubview(errorInfoView)
    }
    
    func _tapHandler(sender: UITapGestureRecognizer) {
        delegate?.clickTips?(message: self.message)
    }
}
