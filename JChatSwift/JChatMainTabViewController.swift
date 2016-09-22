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
  
  static let sharedInstance = JChatMainTabViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hidesBottomBarWhenPushed = false
    self.setupItemVC()

  }

  func setupItemVC() {
    let tabControllerArr = NSMutableArray()
    for itemInfoDic in self.tabBarArrs() {
      let className = (itemInfoDic as! NSDictionary).object(forKey: TabbarItemVC) as! String
      let tittle = (itemInfoDic as! NSDictionary).object(forKey: TabbarItemTittle) as! String
      let imageName = (itemInfoDic as! NSDictionary).object(forKey: TabbarItemImage) as! String
      let selectedImageName = (itemInfoDic as! NSDictionary).object(forKey: TabbarItemSelectedImage) as! String
      let theClass = NSClassFromString(className) as! NSObject.Type
      
      let vc = theClass.init() as! UIViewController
      vc.hidesBottomBarWhenPushed = false

      let nv:UINavigationController = UINavigationController(rootViewController: vc)
      nv.tabBarItem = UITabBarItem(title: tittle, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
      
      tabControllerArr.add(nv)
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
    
    return tabBarVCArray as NSArray
  }
  
  override var shouldAutorotate : Bool {
    return false
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return .portrait
  }
  
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()

    }

}

extension JChatMainTabViewController : UINavigationControllerDelegate {

}
