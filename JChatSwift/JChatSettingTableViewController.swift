//
//  JChatSettingTableViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/3.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatSettingTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.separatorStyle = .none
    self.setupNavigation()
  }


  func setupNavigation() {
    self.title = "设置"
    
    let leftBtn = UIButton(type: .custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.backClick), for: .touchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
  }
  
  func backClick() {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    identify = "JChatSettingCell"
    var cell:JChatSettingCell? = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatSettingCell
    if cell == nil {
      tableview.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatSettingCell
      cell = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatSettingCell
    }
    if (indexPath as NSIndexPath).row == 0 {
      cell?.setCellData("修改密码")
    } else {
      cell?.setCellData("关于")
    }
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    
    if (indexPath as NSIndexPath).row == 0 {
      let updatepasswordVC = JChatUpdatePasswordViewController()
      self.navigationController?.pushViewController(updatepasswordVC, animated: true)
    } else {
      let versionVC = JChatVersionViewController()
      self.navigationController?.pushViewController(versionVC, animated: true)
    }
  }
}

@objc(JChatSettingCell)
class JChatSettingCell: UITableViewCell {
  var titleLable:UILabel!
  var arrowImg:UIImageView!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.titleLable = UILabel()
    self.contentView.addSubview(self.titleLable)
    self.titleLable.font = UIFont.systemFont(ofSize: 17)
    self.titleLable.snp_makeConstraints { (make) -> Void in
      make.height.equalTo(21)
      make.left.equalTo(self.contentView).offset(10)
      make.top.equalTo(self.contentView).offset(10)
      make.width.equalTo(100)
      make.bottom.equalTo(self.contentView).offset(10)
    }
    
    self.arrowImg = UIImageView()
    self.arrowImg.image = UIImage(named: "jiantou")
    self.contentView.addSubview(self.arrowImg)
    self.arrowImg.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 8, height: 15))
      make.right.equalTo(self.contentView).offset(-8)
      make.centerY.equalTo(self.contentView)
    }
    
    let baseLine = UIView()
    self.contentView.addSubview(baseLine)
    baseLine.backgroundColor = UIColor(netHex: 0xcccccc)
    baseLine.snp_makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.contentView)
      make.height.equalTo(0.5)
      make.bottom.equalTo(self.contentView)
    }
  }

  func setCellData(_ title:String) {
    self.titleLable.text = title
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
