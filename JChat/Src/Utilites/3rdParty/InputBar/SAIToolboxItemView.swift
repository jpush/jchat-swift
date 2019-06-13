//
//  SAIToolboxItemView.swift
//  SAC
//
//  Created by SAGESSE on 9/15/16.
//  Copyright © 2016-2017 SAGESSE. All rights reserved.
//

import UIKit

internal class SAIToolboxItemView: UICollectionViewCell {
    
    var item: SAIToolboxItem? {
        didSet {
            _titleLabel.text = item?.name
            _iconView.image = item?.image
            _iconView.highlightedImage = item?.highlightedImage
        }
    }
    
    weak var handler: AnyObject?
    
    private func _init() {
        
        _titleLabel.font = UIFont.systemFont(ofSize: 12)
        _titleLabel.textColor = .gray
        _titleLabel.textAlignment = .center
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        _iconView.contentMode = .scaleAspectFit
        _iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.layer.cornerRadius = 4
        selectedBackgroundView = view
        
        contentView.addSubview(_iconView)
        contentView.addSubview(_titleLabel)

        _iconView.mas_makeConstraints({ (make) in
            make?.centerX.equalTo()(_titleLabel.mas_centerX)
            make?.top.equalTo()(self.mas_top)?.offset()(8)
            make?.width.equalTo()(43)
            make?.height.equalTo()(43)
        })
        _titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(_iconView.mas_bottom)?.offset()(5)
            make?.left.and()?.right().equalTo()
            make?.height.equalTo()(20)
        }
    }
    
    private lazy var _iconView: UIImageView = UIImageView()
    private lazy var _titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
}

