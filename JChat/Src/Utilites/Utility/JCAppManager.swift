//
//  JCAppManager.swift
//  JChat
//
//  Created by deng on 2017/6/23.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCAppManager: NSObject {
    
    static func openAppSetter() {
        let url = URL(string: UIApplicationOpenSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        }
    }

}
