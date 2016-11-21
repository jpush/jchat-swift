//
//  JChatMoreInputCell.swift
//  JChatSwift
//
//  Created by oshumini on 2016/11/20.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatMoreInputCell: UICollectionViewCell {

  @IBOutlet weak var moreviewItem: UIButton!
  private var itemType:JChatMoreItemType?
  weak var moreViewdelegate:JChatMoreViewDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }

  func setup(type:JChatMoreItemType ,delegate:JChatMoreViewDelegate) {
    self.itemType = type
    moreViewdelegate = delegate
    
    switch type {
    case .camera:
      moreviewItem.setImage(UIImage(named: "camera_35"), for: .normal)
      moreviewItem.setTitle("拍摄", for: .normal)
      
      break
    case .photo:
      moreviewItem.setImage(UIImage(named: "photo_24"), for: .normal)
      moreviewItem.setTitle("相册", for: .normal)
      break
    case .location:
      moreviewItem.setImage(UIImage(named: "location_icon"), for: .normal)
      moreviewItem.setImage(UIImage(named: "location_icon_pre"), for: .highlighted)
      moreviewItem.setTitle("位置", for: .normal)
      break
    
    }
  }
  
  @IBAction func clickMoreItem(_ sender: Any) {
    switch self.itemType! {
    case .camera:
      self.moreViewdelegate?.cameraClick()
      break
    case .photo:
      self.moreViewdelegate?.photoClick()
      break
    case .location:
      self.moreViewdelegate?.locationClick()
      break
    }
  }
  
}
