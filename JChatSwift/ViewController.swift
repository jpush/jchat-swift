//
//  ViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/15.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import SnapKit

let loginedUserName = "loginedUserName"

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let loginBtn:UIButton = UIButton()
    loginBtn.setTitle("Login", for: UIControlState())
    loginBtn.setTitleColor(UIColor.purple, for: UIControlState())
    loginBtn.layer.cornerRadius = 5
    loginBtn.layer.borderWidth = 2
    loginBtn.layer.borderColor = UIColor.purple.cgColor
    loginBtn.addTarget(self, action: #selector(self.clickLogin), for: .touchUpInside)
    self.view.addSubview(loginBtn)
    loginBtn.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.view)
      make.size.equalTo(CGSize(width: 60, height: 30))
    }

  }

  func clickLogin() {
//test
    let nextVC = JChatMainTabViewController.sharedInstance
    let nextNV = UINavigationController(rootViewController: nextVC)
    self.present(nextNV, animated: true, completion: nil)
    return
    
    //
    if UserDefaults.standard.object(forKey: loginedUserName) == nil {
      JMSGUser.login(withUsername: "uikit1", password: "111111") { (resultObj, error) -> Void in
        if error == nil {
          self.getSingleConversation()
        } else {
          
        }
      }
    } else {
      self.getSingleConversation()
    }

  }
  
  func getSingleConversation() {
    let conversation:JMSGConversation? = JMSGConversation.singleConversation(withUsername: "5558")
    print("\(conversation)")
    if conversation == nil {
      JMSGConversation.createSingleConversation(withUsername: "5558", completionHandler: { (resultObj, error) -> Void in
        if error != nil {
          print("创建 conversatiion 失败")
          return
        }
        let conversation:JMSGConversation = resultObj as! JMSGConversation
        let ChatController = JChatChattingViewController()
        ChatController.conversation = conversation
        self.navigationController?.pushViewController(ChatController, animated: true)
      })
    } else {
      let ChatController = JChatChattingViewController()
      ChatController.conversation = conversation
      self.present(ChatController, animated: true, completion: nil)
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

