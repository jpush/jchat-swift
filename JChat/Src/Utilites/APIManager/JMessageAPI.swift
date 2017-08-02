//
//  JMessageAPI.swift
//  JChat
//
//  Created by deng on 2017/7/28.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

protocol JMessageAPI {
    
    func searchUser(_ userName: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ())

}
