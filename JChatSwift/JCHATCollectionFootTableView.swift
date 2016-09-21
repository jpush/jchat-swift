//
//  JCHATCollectionFootTableView.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/4.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JCHATCollectionFootTableView)
class JCHATCollectionFootTableView: UICollectionReusableView {

  @IBOutlet weak var footTable: UITableView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.footTable.tableFooterView = UIView()
    self.footTable.separatorStyle = .none
    self.footTable.isScrollEnabled = false
  }
}


