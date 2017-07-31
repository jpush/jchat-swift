//
//  JCForwardViewController.swift
//  JChat
//
//  Created by deng on 2017/7/17.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCForwardViewController: UIViewController {
    
    var message: JMSGMessage?

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private lazy var cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    
    fileprivate var contacterView: UITableView = UITableView(frame: .zero, style: .grouped)
    private lazy var searchController: JCSearchController = JCSearchController(searchResultsController: JCNavigationController(rootViewController: JCSearchResultViewController()))
    private lazy var searchView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 31))
    fileprivate var badgeCount = 0
    
    fileprivate lazy var tagArray = ["群组"]
    fileprivate lazy var users: [JMSGUser] = []
    
    fileprivate lazy var keys: [String] = []
    fileprivate lazy var data: Dictionary<String, [JMSGUser]> = Dictionary()
    
    fileprivate var selectUser: JMSGUser!

    private func _init() {
        self.title = "转发"
        self.view.backgroundColor = UIColor(netHex: 0xe8edf3)
        _setupNavigation()
        
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
        
        _getFriends()
    }
    
    private func _setupNavigation() {
        cancelButton.addTarget(self, action: #selector(_clickNavleftButton), for: .touchUpInside)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        let item = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = item
    }
    
    func _clickNavleftButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func _updateUserInfo() {
        let users = self.users
        _classify(users)
        self.contacterView.reloadData()
    }
    
    func _classify(_ users: [JMSGUser]) {
        self.users = users
        self.keys.removeAll()
        self.data.removeAll()
        for item in users {
            var key = item.displayName().firstCharacter()
            if !key.isLetterOrNum() {
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
        self.keys = _JCSortKeys(self.keys)
    }
    
    func _getFriends() {
        JMSGFriendManager.getFriendList { (result, error) in
            if let users = result as? [JMSGUser] {
                self._classify(users)
                self.contacterView.reloadData()
            }
        }
    }

}

//Mark: -
extension JCForwardViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            self.navigationController?.pushViewController(JCGroupListViewController(), animated: true)
            return
        }
        selectUser = self.data[keys[indexPath.section - 1]]?[indexPath.row]
        forwardMessage(message!)
    }
    
    func forwardMessage(_ message: JMSGMessage) {
        switch(message.contentType) {
        case .text:
            let content = message.content as! JMSGTextContent
            JCAlertView.bulid().setTitle("发送给：\(selectUser.displayName())")
                .setMessage(content.text)
                .setDelegate(self)
                .addCancelButton("取消")
                .addButton("确定")
                .setTag(10001)
                .show()

        case .image:
            let content = message.content as! JMSGImageContent
            guard let image = UIImage(contentsOfFile: content.originMediaLocalPath) else {
                return
            }
            JCAlertView.bulid().setTitle("发送给：\(selectUser.displayName())")
                .setDelegate(self)
                .addCancelButton("取消")
                .addButton("确定")
                .setTag(10002)
                .addImage(image)
                .show()
        case .file:
            break
        default :
            break
        }
    }
}

extension JCForwardViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        self.contacterView.isHidden = true
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        self.contacterView.isHidden = false
        let nav = searchController.searchResultsController as! JCNavigationController
        nav.isNavigationBarHidden = true
        nav.popToRootViewController(animated: false)
    }
}

extension JCForwardViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != 1 {
            return
        }
        switch alertView.tag {
        case 10001:
            let content = message?.content as! JMSGTextContent
            JMSGMessage.sendSingleTextMessage(content.text, toUser: selectUser.username)
//        case 10002:
//            let content = message?.content as! JMSGImageContent
//            guard let image = UIImage(contentsOfFile: content.originMediaLocalPath) else {
//                return
//            }
        default:
            break
        }
        MBProgressHUD_JChat.show(text: "已经发送", view: view, 2)
        weak var weakSelf = self
        let time: TimeInterval = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            weakSelf?.dismiss(animated: true, completion: nil)
        }
    }
}
