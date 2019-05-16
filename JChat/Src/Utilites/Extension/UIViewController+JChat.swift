//
//  UIViewController+JChat.swift
//  JChat
//
//  Created by JIGUANG on 2017/10/8.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func back(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}
