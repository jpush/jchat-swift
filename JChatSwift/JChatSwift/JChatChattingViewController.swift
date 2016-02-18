//
//  JChatChattingViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

internal let interval = 60
internal let messagePageNumber = 25
internal let messageFristPageNumber = 20

class JChatChattingViewController: UIViewController {
  var messageTable:UITableView!
  var messageInputView:JChatInputView!
  var messageDataSource:JChatChattingDataSource!
  var chatLayout:JChatChattingLayout!
  
  var messageOffset = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.whiteColor()
    
    self.messageInputView = JChatInputView(frame: CGRectZero)
    self.view.addSubview(messageInputView)
    self.messageInputView.snp_makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.view)
      make.top.equalTo(self.view.snp_bottom).offset(-45)
      make.height.equalTo(295)
    }
    
    self.messageTable = UITableView(frame: CGRectZero)
    self.messageTable.backgroundColor = UIColor.yellowColor()
    self.messageTable.delegate = self
    self.messageTable.dataSource = self
    self.view.addSubview(messageTable)
    self.messageTable.snp_makeConstraints { (make) -> Void in
      make.top.left.right.equalTo(self.view)
      make.bottom.equalTo(self.messageInputView.snp_top)
    }
    
    self.messageDataSource = JChatChattingDataSource()
    self.chatLayout = JChatChattingLayout()
    
    let gesture = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
    gesture.delegate = self
    self.messageTable.addGestureRecognizer(gesture)

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JChatChattingViewController:UITableViewDelegate,UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    return cell
  }
}

extension JChatChattingViewController:UIGestureRecognizerDelegate {
  func handleTap(recognizer: UITapGestureRecognizer) {
    UIApplication.sharedApplication().sendAction(Selector("resignFirstResponder"), to: nil, from: nil, forEvent: nil)
  }
}
