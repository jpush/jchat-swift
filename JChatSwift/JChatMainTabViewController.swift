//
//  JChatMainTabViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/28.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

internal let TabbarItemVC = "TabbarItemClassName"
internal let TabbarItemTittle = "TabbarItemTittle"
internal let TabbarItemImage = "TabbarItemImage"
internal let TabbarItemSelectedImage = "TabbarItemSelectedImage"

class JChatMainTabViewController: UITabBarController {

  class var sharedInstance: JChatMainTabViewController {
    struct Static {
      static var onceToken: dispatch_once_t = 0
      static var instance: JChatMainTabViewController? = nil
    }
    dispatch_once(&Static.onceToken) {
      Static.instance = JChatMainTabViewController()
    }
    return Static.instance!
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hidesBottomBarWhenPushed = false
    self.setupItemVC()

  }

  func setupItemVC() {
    let tabControllerArr = NSMutableArray()
    for itemInfoDic in self.tabBarArrs() {
      let className = (itemInfoDic as! NSDictionary).objectForKey(TabbarItemVC) as! String
      let tittle = (itemInfoDic as! NSDictionary).objectForKey(TabbarItemTittle) as! String
      let imageName = (itemInfoDic as! NSDictionary).objectForKey(TabbarItemImage) as! String
      let selectedImageName = (itemInfoDic as! NSDictionary).objectForKey(TabbarItemSelectedImage) as! String
      let theClass = NSClassFromString(className) as! NSObject.Type
      
      let vc = theClass.init() as! UIViewController
      vc.hidesBottomBarWhenPushed = false

      let nv:UINavigationController = UINavigationController(rootViewController: vc)
      nv.tabBarItem = UITabBarItem(title: tittle, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
      
      tabControllerArr.addObject(nv)
    }
    self.viewControllers = tabControllerArr as! Array<UIViewController>
  }
  
  func tabBarArrs() -> NSArray {
    let tabBarVCArray = [
      [
        TabbarItemVC: "JChatConversationListViewController",
        TabbarItemTittle: "会话",
        TabbarItemImage: "menu_25",
        TabbarItemSelectedImage: "menu_23"
      ],
      [
        TabbarItemVC: "JChatContactsViewController",
        TabbarItemTittle: "通讯录",
        TabbarItemImage: "menu_16",
        TabbarItemSelectedImage: "menu_16"
      ],
      [
        TabbarItemVC: "JChatAboutMeViewController",
        TabbarItemTittle: "我",
        TabbarItemImage: "menu_13",
        TabbarItemSelectedImage: "menu_12"
      ],
    ]
    
    return tabBarVCArray
  }
  
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()

    }

}

extension JChatMainTabViewController : UINavigationControllerDelegate {

}