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
        searchBar.frame = frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.masksToBounds = true
        
        var frame = self.searchBar.frame
        frame.size.height = 31
        searchBar.frame = frame
    }
    
    private func _init() {
        dimsBackgroundDuringPresentation = false
        hidesNavigationBarDuringPresentation = true
        searchBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 31)
        searchBar.barStyle = .default
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "搜索"
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.masksToBounds = true
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
}
