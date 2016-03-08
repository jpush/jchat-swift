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
    let backBtn = UIButton(type: .Custom)
    backBtn.frame = kNavigationLeftButtonRect
    backBtn.setBackgroundImage(UIImage(named: "goBack"), forState: .Normal)
    backBtn.contentMode = .Center
    backBtn.imageEdgeInsets = kGoBackBtnImageOffset
    backBtn .addTarget(self, action: Selector("doBack"), forControlEvents: .TouchUpInside)
    
    let backItem = UIBarButtonItem(customView: backBtn)
    self.navigationItem.leftBarButtonItem = backItem
    self.navigationController?.navigationBar.translucent = false
  }
  
  @objc func doBack() {
    self.navigationController?.popViewControllerAnimated(true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

}
