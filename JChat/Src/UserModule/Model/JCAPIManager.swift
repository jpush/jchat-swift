//
//  JCAPIManager.swift
//  JChat
//
//  Created by deng on 2017/6/12.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class JCAPIManager: NSObject, JMessageAPI {
    
//    static let sharedAPI = JCAPIManager()
    
//    private init() {}
    
    var session: URLSession!
    
    static let sharedAPI = JCAPIManager()
    
    private override init() {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    let host = "https://api.im.jpush.cn/v1"
    let userPath = "/users/"
    
//    private let session = URLSession.shared
    private lazy var request: NSMutableURLRequest = {
        let request = NSMutableURLRequest()
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(kAuthorization, forHTTPHeaderField: "Authorization")
        return request
    }()
    

    func searchUser(_ userName: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let url = URL(string: host + userPath + userName)
        request.url = url
//        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            completionHandler(data, response, error)
        }
        dataTask.resume()
    }
    
    func userAvailable(_ username: String) -> Observable<ValidationResult> {
        let url = URL(string: host + userPath + username)
        request.url = url!
        return session.rx.data(request: request as URLRequest)
            .map({ (data) in
                let result = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                if result["username"] != nil {
                    return .failed(message: "用户名重复")
                } else {
                    return .ok
                }
            }).startWith(.validating)
            .catchErrorJustReturn(.failed(message: "校验失败，请重试"))
//        return URLSession.rx.response(request: request as URLRequest)
//            .map { (response, data) in
//                let result = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                if result["username"] != nil {
//                    return .failed(message: "用户名重复")
//                } else {
//                    return .ok
//                }
//            }
//            .catchErrorJustReturn(.failed(message: "校验失败，请重试"))
        
    }
    
//    func signup(_ username: String, password: String) -> Observable<ValidationResult> {
//        return ValidationResult
//    }
    
}

extension JCAPIManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(challenge.protectionSpace)
        // 如果是请求证书信任，我们再来处理，其他的不需要处理
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let cre = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cre)
        }
    }
}
