//
//  JCAlertView.swift
//  JChat
//
//  Created by deng on 2017/7/18.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCAlertView: NSObject {
    
    private var alertView: UIAlertView!
    
    private override init() {}
    
    static func bulid() -> JCAlertView {
        let alertView = UIAlertView()
        let alert = JCAlertView()
        alert.alertView = alertView
        return alert
    }
    
    public func setDelegate(_ delegate: AnyObject?) -> JCAlertView {
        alertView.delegate = delegate
        return self
    }
    
    public func setTitle(_ title: String) -> JCAlertView {
        alertView.title = title
        return self
    }
    
    public func setMessage(_ message: String) -> JCAlertView {
        alertView.message = message
        return self
    }
    
    public func setTag(_ tag: Int) -> JCAlertView {
        alertView.tag = tag
        return self
    }
    
    public func addButton(_ buttonTitle: String) -> JCAlertView {
        alertView.addButton(withTitle: buttonTitle)
        return self
    }
    
    public func addCancelButton(_ buttonTitle: String) -> JCAlertView {
        alertView.addButton(withTitle: buttonTitle)
        let count = alertView.numberOfButtons
        alertView.cancelButtonIndex = count - 1
        return self
    }
    
    public func  addImage(_ image: UIImage) -> JCAlertView {
        let imageView = UIImageView()
        let scale = 270 / image.size.width
        imageView.image = image.resizeImage(image: image, newSize: CGSize(width: image.size.width * scale, height: image.size.height * scale))
        alertView.setValue(imageView, forKey: "accessoryView")
        return self
    }
    
    public func show() {
        alertView.show()
    }

}
