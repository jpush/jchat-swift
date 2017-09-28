//
//  SHomeHeader.swift
//
//  Created by wangjie on 16/5/4.
//  Copyright © 2016年 wangjie. All rights reserved.
//

import UIKit

class ImageFileHeader: UICollectionReusableView {
    
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    func initView(){
        titleLabel = UILabel(frame: CGRect(x: 16.5, y: 0, width: self.width, height: self.height))
        titleLabel.textColor = UIColor(netHex: 0x808080)
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(titleLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
