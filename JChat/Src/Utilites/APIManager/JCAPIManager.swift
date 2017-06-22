//
//  JCAPIManager.swift
//  JChat
//
//  Created by deng on 2017/6/12.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCAPIManager: NSObject {

    static func searchUser(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(kAuthorization, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            completionHandler(data, response, error)
        }
        dataTask.resume()
    }
    
}
