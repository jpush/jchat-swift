//
//  JCSearchView.swift
//  JChat
//
//  Created by deng on 2017/3/22.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

@objc public protocol JCSearchControllerDelegate: NSObjectProtocol {
    @objc optional func didEndEditing(_ searchBar: UISearchBar)
    
}

class JCSearchController: UISearchController {
    
    weak var searchControllerDelegate: JCSearchControllerDelegate?
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _init()
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        var frame = self.searchBar.frame
        frame.size.height = 31
        self.searchBar.frame = frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchBar.layer.borderColor = UIColor.white.cgColor
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.masksToBounds = true
        
        var frame = self.searchBar.frame
        frame.size.height = 31
        self.searchBar.frame = frame
    }
    
    
    private func _init() {
        self.dimsBackgroundDuringPresentation = false
        self.hidesNavigationBarDuringPresentation = true
        self.searchBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 31)
        self.searchBar.barStyle = .default
        self.searchBar.backgroundColor = .white
        self.searchBar.barTintColor = .white
        self.searchBar.delegate = self
        //取消首字母大写
        self.searchBar.autocapitalizationType = .none
//        self.searchBar.autocorrectionType = .no
        self.searchBar.placeholder = "搜索"
        self.searchBar.layer.borderColor = UIColor.white.cgColor
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.masksToBounds = true
    }

}

extension JCSearchController: UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchControllerDelegate?.didEndEditing?(searchBar)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        for view in (searchBar.subviews.first?.subviews)! {
            if view is UIButton {
                let cancelButton = view as! UIButton
                cancelButton.setTitleColor(UIColor(netHex: 0x2dd0cf), for: .normal)
                break
            }
        }
    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        var frame = self.searchBar.frame
//        frame.size.height = 31
//        self.searchBar.frame = frame
//    }
}
