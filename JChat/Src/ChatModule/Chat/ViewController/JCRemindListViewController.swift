//
//  JCRemindListViewController.swift
//  JChat
//
//  Created by deng on 2017/6/26.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCRemindListViewController: UIViewController {
    
    typealias handleFinish = (_ user: JMSGUser?, _ isAtll: Bool, _ length: Int) -> ()
    
    var finish: handleFinish!
    
    var group: JMSGGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private lazy var cancel = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 36))
    fileprivate lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionIndexColor = UIColor(netHex: 0x2dd0cf)
        tableView.sectionIndexBackgroundColor = .clear
        tableView.register(JCContacterCell.self, forCellReuseIdentifier: "JCContacterCell")
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        return tableView
    }()
    fileprivate lazy var searchView: UISearchBar = {
        let searchView = UISearchBar()
        searchView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 31)
        searchView.barStyle = .default
        searchView.backgroundColor = .white
        searchView.barTintColor = .white
        searchView.delegate = self
        searchView.autocapitalizationType = .none
        searchView.placeholder = "搜索"
        searchView.layer.borderColor = UIColor.white.cgColor
        searchView.layer.borderWidth = 1
        searchView.layer.masksToBounds = true
        return searchView
    }()
    
    fileprivate lazy var tagArray = ["所有成员"]
    fileprivate lazy var users: [JMSGUser] = []
    fileprivate lazy var keys: [String] = []
    fileprivate lazy var data: Dictionary<String, [JMSGUser]> = Dictionary()
    
    fileprivate lazy var defaultGroupIcon = UIImage.loadImage("com_icon_group_36")
    fileprivate var isSearching = false
    
    private func _init() {
        self.title = "选择提醒的人"
        self.view.backgroundColor = .white
        _setupNavigation()
        tableView.tableHeaderView = searchView
        users = group.memberArray()
        _classify(users)
        view.addSubview(tableView)
    }
    
    private func _setupNavigation() {
        cancel.addTarget(self, action: #selector(_clickNavRightButton), for: .touchUpInside)
        cancel.setTitle("取消", for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        let item = UIBarButtonItem(customView: cancel)
        self.navigationItem.leftBarButtonItem =  item
    }
    
    func _clickNavRightButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func _classify(_ users: [JMSGUser]) {
        self.keys.removeAll()
        self.data.removeAll()
        for item in users {
            if item.username == JMSGUser.myInfo().username {
                continue
            }
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
    
    fileprivate func filter(_ searchString: String) {
        if searchString.isEmpty || searchString == "" {
            isSearching = false
            _classify(users)
            tableView.reloadData()
            return
        }
        isSearching = true
        let filteredUsersArray = _JCFilterUsers(users: users, string: searchString)
        _classify(filteredUsersArray)
        tableView.reloadData()
    }
}

//Mark: -
extension JCRemindListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return keys.count
        }
        if users.count > 0 {
            return keys.count + 1
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !isSearching {
            return tagArray.count
        }
        return isSearching ? self.data[keys[section]]!.count : self.data[keys[section - 1]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return keys[section]
        }
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
            return 25
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
        if indexPath.section == 0 && !isSearching {
            switch indexPath.row {
            case 0:
                cell.title = tagArray[indexPath.row]
                cell.icon = defaultGroupIcon
            default:
                break
            }
            return
        }
        let user = isSearching ? self.data[keys[indexPath.section]]?[indexPath.row] : self.data[keys[indexPath.section - 1]]?[indexPath.row]
        cell.bindDate(user!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && !isSearching {
            finish(nil, true, 4)
            self.dismiss(animated: true, completion: nil)
            return
        }
        if let user = isSearching ? self.data[keys[indexPath.section]]?[indexPath.row] : self.data[keys[indexPath.section - 1]]?[indexPath.row]  {
            finish(user, false, user.displayName().length)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension JCRemindListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchText)
    }
}
