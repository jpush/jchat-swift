//
//  MBProgressHUB+add.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
  class func show(_ text: String, icon: String, view: UIView) {
    let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    hud.labelText = text
    hud.customView = UIImageView(image: UIImage(named: icon))
    hud.mode = .customView
    hud.removeFromSuperViewOnHide = true
    hud.hide(true, afterDelay: 1.5)
    
  }

  class func showError(_ error: String, toView view: UIView) {
    self.show(error ,icon: "error", view: view)
  }

  class func showSuccess(_ success: String, toView view: UIView) {
    self.show(success, icon: "success", view: view)
  }

  class func showMessage(_ text: String, view: UIView) {
    let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    hud.labelText = text
    hud.mode = .customView
    hud.removeFromSuperViewOnHide = true
    hud.hide(true, afterDelay: 1.5)
  }

  class func showMessage(_ message: String, toView view:UIView) -> MBProgressHUD {
    let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    hud.labelText = message
    hud.mode = .customView
    hud.removeFromSuperViewOnHide = true
    return hud
  }
}

