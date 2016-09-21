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

    let infoDic = Bundle.main.infoDictionary as! NSDictionary
    self.jchatVersionLB.text = infoDic.object(forKey: "CFBundleShortVersionString") as! String
    self.jchatBuildNumber.text = infoDic.object(forKey: "CFBundleVersion") as! String
    
    jmessageVersion.text = JMESSAGE_VERSION
    jmessagebuildNumber.text = "\(JMESSAGE_BUILD)"
  }
  
  func setupNavigation() {
    self.title = "版本"

    let leftBtn = UIButton(type: .custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.doBack), for: .touchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  func doBack() {
    _ = self.navigationController?.popViewController(animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
