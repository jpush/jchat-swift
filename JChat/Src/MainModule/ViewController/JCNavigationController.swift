//
//  JCNavigationController.swift
//  JChat
//
//  Created by deng on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCNavigationController: UINavigationController {

    //MARK: - life cycle
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        _init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - override func
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - private func
    private func _init() {
        let navBar = UINavigationBar.appearance()
//        self.navigationBar.isTranslucent = false
        navBar.barTintColor = UIColor(netHex: 0x2dd0cf)
        navBar.tintColor = .white
        var attrs = [String : AnyObject]()
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 18)
        attrs[NSForegroundColorAttributeName] = UIColor.white
        navBar.titleTextAttributes = attrs
        navBar.backIndicatorTransitionMaskImage = UIImage.loadImage("com_icon_back")
        navBar.backIndicatorImage = UIImage.loadImage("com_icon_back")
//        navBar.backItem?.leftBarButtonItem?.customView?.backgroundColor = .red
//        imageView.image = UIImage.loadImage("com_icon_back")
//        navBar.backItem?.leftBarButtonItem?.customView = imageView
    }

}
