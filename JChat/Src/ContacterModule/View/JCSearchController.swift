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

    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.setValue(searchBar, forKey: "searchBarTextField.frame")
//        let searchBarTextField = searchBar.value(forKey: "_searchField") as! UITextField
//        searchBarTextField.frame = searchBar.frame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let frame = self.searchBar.frame
        if frame.origin.y > 0 && frame.origin.y < 20  {
            searchBar.frame = CGRect(x: frame.origin.x, y: 20, width: frame.size.width, height: 31)
        } else {
            searchBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 31)
        }
//        searchBar.setValue(searchBar, forKey: "searchBarTextField")
//        let searchBarTextField = searchBar.value(forKey: "_searchField") as! UITextField
//        searchBarTextField.frame = searchBar.frame
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        searchBar.setValue(searchBar.frame, forKey: "_searchField.frame")

//        for view in (searchBar.subviews.first?.subviews)! {
//
//            if view.self is NSClassFromString("_UISearchBarSearchFieldBackgroundView") {
//                let textField = view as! UITextField
//                textField.frame = searchBar.frame
//            }
//        }
//        NSClassFromString("_UISearchBarSearchFieldBackgroundView")?.setValue(searchBar.frame, forKey: "frame")

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.masksToBounds = true
        
        let frame = self.searchBar.frame
        if frame.origin.y > 0 && frame.origin.y < 20  {
            searchBar.frame = CGRect(x: frame.origin.x, y: 20, width: frame.size.width, height: 31)
        } else {
            searchBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 31)
        }

//        searchBar.setValue(searchBar.frame, forKey: "_searchField.frame")
//        let searchBarTextField = searchBar.value(forKey: "_searchField") as! UITextField
//        searchBarTextField.frame = searchBar.frame

    }

    private func _init() {
        self.automaticallyAdjustsScrollViewInsets = false
        dimsBackgroundDuringPresentation = false
        hidesNavigationBarDuringPresentation = true
        searchBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 31)

        if #available(iOS 11.0, *) {
            searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 3), for: .search)
            searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 3)
        }

        searchBar.barStyle = .default
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "搜索"
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.masksToBounds = true
        searchBar.setSearchFieldBackgroundImage(UIImage.createImage(color: .white, size: CGSize(width: UIScreen.main.bounds.size.width, height: 31)), for: .normal)
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
                if #available(iOS 11.0, *) {
                    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0)
                }
                break
            }
        }
    }
}
