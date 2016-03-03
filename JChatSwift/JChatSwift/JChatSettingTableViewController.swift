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
    self.tableView.separatorStyle = .None
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }


  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(tableview: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    identify = "JChatSettingCell"
    var cell:JChatSettingCell? = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatSettingCell
    if cell == nil {
      tableview.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatSettingCell
      cell = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatSettingCell
    }
    if indexPath.row == 0 {
      cell?.setCellData("修改密码")
    } else {
      cell?.setCellData("关于")
    }
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.selected = false
    
//    if (indexPath.row==0) {
//      JCHATUpdatePasswordCtl *updateWordCtl =[[JCHATUpdatePasswordCtl alloc] init];
//      [self.navigationController pushViewController:updateWordCtl animated:YES];
//    }
//    
//    if (indexPath.row == 1) {
//      JCHATAboutViewController *about = [[JCHATAboutViewController alloc]initWithNibName:@"JCHATAboutViewController" bundle:nil];
//      [self.navigationController pushViewController:about animated:YES];
//      
//    }
    
    if indexPath.row == 0 {
      
    } else {
      
    }
  }
}

class JChatSettingCell: UITableViewCell {
  var titleLable:UILabel!
  var arrowImg:UIImageView!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.titleLable = UILabel()
    self.contentView.addSubview(self.titleLable)
    self.titleLable.font = UIFont.systemFontOfSize(17)
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
      make.right.equalTo(self.contentView).offset(8)
      make.centerY.equalTo(self.contentView)
    }
    
    let baseLine = UIView()
    self.contentView.addSubview(baseLine)
    self.contentView.backgroundColor = UIColor(netHex: 0xcccccc)
    baseLine.snp_makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.contentView)
      make.height.equalTo(0.5)
      make.bottom.equalTo(self.contentView)
    }
  }

  func setCellData(title:String) {
    self.titleLable.text = title
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
