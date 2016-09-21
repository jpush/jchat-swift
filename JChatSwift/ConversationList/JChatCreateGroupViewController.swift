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
    self.navigationController?.navigationBar.isTranslucent = false
    
    let rightBtn = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(self.clickToFinish))
    rightBtn.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem = rightBtn
    
    let leftBtn = UIButton(type: .custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.backClick), for: .touchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
  }
  
  func clickToFinish() {
    
  }
  
  func backClick() {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

extension JChatCreateGroupViewController: UIGestureRecognizerDelegate {

}
