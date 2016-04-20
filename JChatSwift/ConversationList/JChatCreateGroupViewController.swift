//
//  JChatCreateGroupViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/3.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatCreateGroupViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  func setupNavigation() {
    self.title = "创建群聊"
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.navigationBar.translucent = false
    
    let rightBtn = UIBarButtonItem(title: "确定", style: .Plain, target: self, action: #selector(JChatCreateGroupViewController.clickToFinish))
    rightBtn.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = rightBtn
    
    let leftBtn = UIButton(type: .Custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(JChatCreateGroupViewController.backClick), forControlEvents: .TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
  }
  
  @objc func clickToFinish() {
    
  }
  
  @objc func backClick() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

extension JChatCreateGroupViewController: UIGestureRecognizerDelegate {

}