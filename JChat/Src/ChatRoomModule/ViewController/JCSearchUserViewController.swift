//
//  JCSearchUserViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/26.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCSearchUserViewController: UIViewController {

    open var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar = self.searchController.searchBar
        // Do any additional setup after loading the view.
    }
    
    fileprivate lazy var searchController: UISearchController = {
        let rootVC = JCCRSearchResultViewController()
        let resultNav = JCNavigationController(rootViewController:rootVC)
        var searchVC = UISearchController(searchResultsController:resultNav)
        searchVC.delegate = self
        searchVC.searchResultsUpdater = rootVC
        // 设置开始搜索时导航条是否隐藏
        searchVC.hidesNavigationBarDuringPresentation = true
        // 设置开始搜索时背景是否显示
        searchVC.dimsBackgroundDuringPresentation = false
        let searchBar = searchVC.searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "请输入用户ID"
        searchVC.searchBar.returnKeyType = .search
        searchBar.setSearchFieldBackgroundImage(UIImage.createImage(color: .white, size: CGSize(width: UIScreen.main.bounds.size.width, height: 31)), for: .normal)
        
        return searchVC
    } ()


}


extension JCSearchUserViewController: UISearchControllerDelegate,UISearchBarDelegate{
    
    
}
