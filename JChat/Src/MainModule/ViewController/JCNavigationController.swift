//
//  JCNavigationController.swift
//  JChat
//
//  Created by JIGUANG on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

protocol CustomNavigation { }

extension CustomNavigation {
    typealias Callback = (UIButton) -> Void

    func customLeftBarButton(delegate: UIGestureRecognizerDelegate, _ finish:  Callback? = nil) {
        guard let vc = delegate as? UIViewController else {
            return
        }
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 65 / 3))
        leftButton.setImage(UIImage.loadImage("com_icon_back"), for: .normal)
        leftButton.setImage(UIImage.loadImage("com_icon_back"), for: .highlighted)
        leftButton.addTarget(vc, action: #selector(vc.back(_:)), for: .touchUpInside)
        leftButton.setTitle("返回", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftButton.contentHorizontalAlignment = .left
        let item = UIBarButtonItem(customView: leftButton)

        vc.navigationItem.leftBarButtonItems =  [item]
        vc.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        vc.navigationController?.interactivePopGestureRecognizer?.delegate = delegate
        if let finish = finish {
            finish(leftButton)
        }
    }
}

final class JCNavigationController: UINavigationController {

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
    
    //MARK: - override func
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
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
        attrs[convertFromNSAttributedStringKey(NSAttributedString.Key.font)] = UIFont.systemFont(ofSize: 18)
        attrs[convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor)] = UIColor.white
        navBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(attrs)
        navBar.backIndicatorTransitionMaskImage = UIImage.loadImage("com_icon_back")
        navBar.backIndicatorImage = UIImage.loadImage("com_icon_back")
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
