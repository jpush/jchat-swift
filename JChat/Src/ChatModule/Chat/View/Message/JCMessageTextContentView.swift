//
//  JCMessageTextContentView.swift
//  JChat
//
//  Created by deng on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

open class JCMessageTextContentView: UILabel, JCMessageContentViewType {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return super.canPerformAction(action, withSender: sender)
    }
    
    open func apply(_ message: JCMessageType, _ indexPath: IndexPath?) {
        guard let content = message.content as? JCMessageTextContent else {
            return
        }
        self.attributedText = content.text
        textColor = UIColor(netHex: 0x0B1816)
    }
    
    private func _commonInit() {
        self.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(_tapHandler))
        self.addGestureRecognizer(tapGR)
        numberOfLines = 0
    }
    
    func _tapHandler(sender:UITapGestureRecognizer) {
        
    }
}
