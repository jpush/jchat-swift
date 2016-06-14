//
//  JChatVersionViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/3.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatVersionViewController: UIViewController {

  @IBOutlet weak var jchatVersionLB: UILabel!

  @IBOutlet weak var jchatBuildNumber: UILabel!
  
  @IBOutlet weak var jmessageVersion: UILabel!
  
  @IBOutlet weak var jmessagebuildNumber: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupNavigation()

    let infoDic = NSBundle.mainBundle().infoDictionary as! NSDictionary
    self.jchatVersionLB.text = infoDic.objectForKey("CFBundleShortVersionString") as! String
    self.jchatBuildNumber.text = infoDic.objectForKey("CFBundleVersion") as! String
    
    jmessageVersion.text = JMESSAGE_VERSION
    jmessagebuildNumber.text = "\(JMESSAGE_BUILD)"
  }
  
  func setupNavigation() {
    self.title = "版本"

    let leftBtn = UIButton(type: .Custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.doBack), forControlEvents: .TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    self.navigationController?.navigationBar.translucent = false
  }
  
  func doBack() {
    self.navigationController?.popViewControllerAnimated(true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
