//
//  JCMessageTimeLineContentView.swift
//  JChat
//
//  Created by deng on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

open class JCMessageTimeLineContentView: UILabel, JCMessageContentViewType {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    open func apply(_ message: JCMessageType, _ indexPath: IndexPath?) {
        guard let content = message.content as? JCMessageTimeLineContent else {
            return
        }
        text = content.text
    }
    
    private func _commonInit() {
        self.layer.cornerRadius = 2.5
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(netHex: 0xD7DCE2).cgColor
        self.layer.masksToBounds = true
        font = UIFont.systemFont(ofSize: 12)
        backgroundColor = UIColor(netHex: 0xD7DCE2)
        textColor = .white
        textAlignment = .center
    }
}
