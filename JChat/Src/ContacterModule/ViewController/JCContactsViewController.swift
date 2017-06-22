//
//  JCContactsViewController.swift
//  JChat
//
//  Created by deng on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage
import YHPopupView

class JCContactsViewController: UIViewController {
    
    public required init() {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_updateBadge), name: NSNotification.Name(rawValue: kUpdateVerification), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _updateBadge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    fileprivate var contacterView: UITableView = UITableView(frame: .zero, style: .grouped)
    private lazy var searchController: JCSearchController = JCSearchController(searchResultsController: JCNavigationController(rootViewController: JCSearchResultViewController()))
    private lazy var searchView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 31))
    fileprivate var badgeCount = 0
    
    fileprivate lazy var tagArray = ["验证消息", "群组"]
    fileprivate lazy var users: [JMSGUser] = []
    
    fileprivate lazy var keys: [String] = []
    fileprivate lazy var data: Dictionary<String, [JMSGUser]> = Dictionary()
    
    //MARK: - private func
    private func _init() {
        self.title = "通讯录"
        self.view.backgroundColor = UIColor(netHex: 0xe8edf3)
        
        if #available(iOS 10.0, *) {
            navigationController?.tabBarItem.badgeColor = UIColor(netHex: 0xEB424C)
        }
        
        let nav = searchController.searchResultsController as! JCNavigationController
        let vc = nav.topViewController as! JCSearchResultViewController
        searchController.delegate = self
        searchController.searchResultsUpdater = vc
        
        searchView.addSubview(searchController.searchBar)
        contacterView.tableHeaderView = searchView
        contacterView.delegate = self
        contacterView.dataSource = self
        contacterView.separatorStyle = .none
        contacterView.sectionIndexColor = UIColor(netHex: 0x2dd0cf)
        contacterView.sectionIndexBackgroundColor = .clear
        contacterView.register(JCContacterCell.self, forCellReuseIdentifier: "JCContacterCell")
        contacterView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        view.addSubview(contacterView)
        
        _setupNavigation()
        _getFriends()
        _updateBadge()
        
        NotificationCenter.default.addObserver(self, selector: #selector(_updateUserInfo), name: NSNotification.Name(rawValue: kUpdateFriendInfo), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_getFriends), name: NSNotification.Name(rawValue: kUpdateFriendList), object: nil)
    }
    
    private func _setupNavigation() {
        addButton.addTarget(self, action: #selector(_clickNavRightButton(_:)), for: .touchUpInside)
        addButton.setImage(UIImage.loadImage("com_icon_friend_add"), for: .normal)
        let item = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem =  item
    }
    
    func _updateUserInfo() {
        let users = self.users
        _classify(users)
        self.contacterView.reloadData()
    }
    
    func _classify(_ users: [JMSGUser]) {
        self.users.removeAll()
        self.keys.removeAll()
        self.data.removeAll()
        for item in users {
            self.users.append(item)
            var key = item.displayName().firstCharacter()
            let value = UnicodeScalar(key)?.value
            if value! < 65 || value! > 90 {
                key = "#"
            }
            var array = self.data[key]
            if array == nil {
                array = [item]
            } else {
                array?.append(item)
            }
            if !self.keys.contains(key) {
                self.keys.append(key)
            }
            
            self.data[key] = array
        }
        self.keys = self.keys.sorted(by: { (str1, str2) -> Bool in
            return str1 < str2
        })
        if self.keys.count > 1 {
            let first = self.keys.first
            if first == "#" {
                self.keys.removeFirst()
                self.keys.append(first!)
            }
        }
    }
    
    func _getFriends() {
        JMSGFriendManager.getFriendList { (result, error) in
            if error == nil {
                self.users.removeAll()
                self.keys.removeAll()
                self.data.removeAll()
                self._classify(result as! [JMSGUser])
                self.contacterView.reloadData()
            }
        }
    }
        
    //MARK: - click func
    func _clickNavRightButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(JCSearchFriendViewController(), animated: true)
    }
    
    func _updateBadge() {
        if UserDefaults.standard.object(forKey: kUnreadInvitationCount) != nil {
            badgeCount = UserDefaults.standard.object(forKey: kUnreadInvitationCount) as! Int
            if badgeCount > 99 {
                navigationController?.tabBarItem.badgeValue = "99+"
            } else {
                navigationController?.tabBarItem.badgeValue = badgeCount == 0 ? nil : "\(badgeCount)"
            }
        } else {
            badgeCount = 0
            navigationController?.tabBarItem.badgeValue = nil
        }
        contacterView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
}

//Mark: -
extension JCContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if users.count > 0 {
            return keys.count + 1
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tagArray.count
        }
        return self.data[keys[section - 1]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        return keys[section - 1]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.keys
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 10
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "JCContacterCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? JCContacterCell else {
            return
        }
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.title = "验证消息"
                cell.icon = UIImage.loadImage("com_icon_friend_tip")
                cell.isShowBadge = badgeCount > 0 ? true : false
            case 1:
                cell.title = "群组"
                cell.icon = UIImage.loadImage("com_icon_group_36")
                cell.isShowBadge = false
            default:
                break
            }
            return 
        }
        let user = self.data[keys[indexPath.section - 1]]?[indexPath.row]
        cell.isShowBadge = false
        cell.bindDate(user!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(JCIdentityVerificationViewController(), animated: true)
            case 1:
                self.navigationController?.pushViewController(JCGroupListViewController(), animated: true)
            default:
                break
            }
            return
        }
        let vc = JCUserInfoViewController()
        let user = self.data[keys[indexPath.section - 1]]?[indexPath.row]
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension JCContactsViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        self.contacterView.isHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        self.contacterView.isHidden = false
        let nav = searchController.searchResultsController as! JCNavigationController
        nav.isNavigationBarHidden = true
        nav.popToRootViewController(animated: false)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
}

