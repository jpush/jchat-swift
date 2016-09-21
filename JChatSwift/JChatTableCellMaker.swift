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

  class func rightMessageCellInTable(_ tableview:UITableView) -> JChatRightMessageCell {
    identify = "JChatRightMessageCell"
    var cell:JChatRightMessageCell? = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatRightMessageCell
    if cell == nil {
      tableview.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatRightMessageCell
    }
    return cell!
  }
  
  class func leftMessageCellInTable(_ tableview:UITableView) -> JChatLeftMessageCell {
    identify = "JChatLeftMessageCell"
    var cell:JChatLeftMessageCell? = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatLeftMessageCell
    if cell == nil {
      tableview.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatLeftMessageCell
      cell = tableview.dequeueReusableCell(withIdentifier: identify) as? JChatLeftMessageCell
    }
    return cell!
  }
  

  class func LoadingCellInTable(_ tableView:UITableView) -> JChatLoadingMessageCell {
    identify = "JChatLoadingMessageCell"
    var cell:JChatLoadingMessageCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatLoadingMessageCell
    if cell == nil {
      tableView.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatLoadingMessageCell
    }
    return cell!
  }

  class func timeCellInTable(_ tableView:UITableView) -> JChatShowTimeCell {
    identify = "JChatShowTimeCell"
    var cell:JChatShowTimeCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatShowTimeCell
    if cell == nil {
      tableView.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatShowTimeCell
    }
    return cell!
  }
}
