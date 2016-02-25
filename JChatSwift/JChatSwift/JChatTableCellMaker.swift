//
//  JChatTableCellMaker.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/18.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

internal var identify = ""

class JChatTableCellMaker: NSObject {

  class func rightMessageCellInTable(tableview:UITableView) -> JChatRightMessageCell {
    identify = "JChatRightMessageCell"
    var cell:JChatRightMessageCell? = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatRightMessageCell
    if cell == nil {
      tableview.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatRightMessageCell
    }
    return cell!
  }
  
  class func leftMessageCellInTable(tableview:UITableView) -> JChatLeftMessageCell {
    identify = "JChatLeftMessageCell"
    var cell:JChatLeftMessageCell? = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatLeftMessageCell
    if cell == nil {
      tableview.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatLeftMessageCell
      cell = tableview.dequeueReusableCellWithIdentifier(identify) as? JChatLeftMessageCell
    }
    return cell!
  }
  

  class func LoadingCellInTable(tableView:UITableView) -> JChatLoadingMessageCell {
    identify = "JChatLoadingMessageCell"
    var cell:JChatLoadingMessageCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatLoadingMessageCell
    if cell == nil {
      tableView.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatLoadingMessageCell
      cell?.backgroundColor = UIColor.redColor()
    }
    return cell!
  }

  class func timeCellInTable(tableView:UITableView) -> JChatShowTimeCell {
    identify = "JChatShowTimeCell"
    var cell:JChatShowTimeCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatShowTimeCell
    if cell == nil {
      tableView.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatShowTimeCell
    }
    return cell!
  }
}
