//
//  JMessageAPI.swift
//  JChat
//
//  Created by deng on 2017/7/28.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol JMessageAPI: NSObjectProtocol {
    
    func searchUser(_ userName: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ())
    func userAvailable(_ username: String) -> Observable<ValidationResult>
//    func signup(_ username: String, password: String) -> Observable<ValidationResult>
}
