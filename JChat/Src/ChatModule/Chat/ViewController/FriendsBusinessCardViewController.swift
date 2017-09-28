//
//  FriendsBusinessCardViewController.swift
//  JChat
//
//  Created by 邓永豪 on 2017/9/21.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class FriendsBusinessCardViewController: UIViewController {

    var conversation: JMSGConversation!

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }

    fileprivate lazy var toolView: UIView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.width, height: 55))
    fileprivate var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    fileprivate lazy var searchView: UISearchBar = UISearchBar()

    fileprivate lazy var users: [JMSGUser] = []
    fileprivate lazy var keys: [String] = []
    fileprivate lazy var data: Dictionary<String, [JMSGUser]> = Dictionary()

    fileprivate lazy var filteredUsersArray: [JMSGUser] = []
    fileprivate var searchUser: JMSGUser?
    fileprivate var selectUser: JMSGUser!

    private lazy var navLeftButton: UIBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(_clickNavLeftButton))

    fileprivate lazy var tipsView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 64 + 31 + 5, width: self.view.width, height: self.view.height - 31 - 64 - 5))
        view.backgroundColor = .white
        let tips = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        tips.font = UIFont.systemFont(ofSize: 16)
        tips.textColor = UIColor(netHex: 0x999999)
        tips.textAlignment = .center
        tips.text = "未搜索到用户"
        view.addSubview(tips)
        view.isHidden = true
        return view
    }()

    private func _init() {
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        self.title = "发送名片"

        view.addSubview(toolView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionIndexColor = UIColor(netHex: 0x2dd0cf)
        tableView.sectionIndexBackgroundColor = .clear
        tableView.register(JCContacterCell.self, forCellReuseIdentifier: "JCContacterCell")
        tableView.frame = CGRect(x: 0, y: 31 + 64, width: view.width, height: view.height - 31 - 64)
        view.addSubview(tableView)

        view.addSubview(tipsView)

        _classify([], isFrist: true)

        searchView.frame = CGRect(x: 15, y: 0, width: toolView.width - 30, height: 31)
        searchView.barStyle = .default
        searchView.backgroundColor = .white
        searchView.barTintColor = .white
        searchView.delegate = self
        searchView.autocapitalizationType = .none
        searchView.placeholder = "搜索"
        searchView.layer.borderColor = UIColor.white.cgColor
        searchView.layer.borderWidth = 1
        searchView.layer.masksToBounds = true

        toolView.addSubview(searchView)

        _setupNavigation()
    }

    private func _setupNavigation() {
        navigationItem.leftBarButtonItem =  navLeftButton
    }

    func _clickNavLeftButton() {
        dismiss(animated: true, completion: nil)
    }


    fileprivate func _classify(_ users: [JMSGUser], isFrist: Bool = false) {

        if users.count > 0 {
            tipsView.isHidden = true
        }

        if isFrist {
            JMSGFriendManager.getFriendList { (result, error) in
                if error == nil {
                    self.users.removeAll()
                    self.keys.removeAll()
                    self.data.removeAll()
                    for item in result as! [JMSGUser] {
                        self.users.append(item)
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
                    self.filteredUsersArray = self.users
                    self.keys = _JCSortKeys(self.keys)
                    self.tableView.reloadData()
                }
            }
        } else {
            filteredUsersArray = users
            keys.removeAll()
            data.removeAll()
            for item in users {
                var key = item.displayName().firstCharacter()
                if !key.isLetterOrNum() {
                    key = "#"
                }
                var array = data[key]
                if array == nil {
                    array = [item]
                } else {
                    array?.append(item)
                }
                if !keys.contains(key) {
                    keys.append(key)
                }

                data[key] = array
            }
            keys = _JCSortKeys(keys)
            tableView.reloadData()
        }
    }

    fileprivate func filter(_ searchString: String) {
        if searchString.isEmpty || searchString == "" {
            _classify(users)
            return
        }
        let searchString = searchString.uppercased()
        filteredUsersArray = _JCFilterUsers(users: users, string: searchString)
        _classify(filteredUsersArray)
    }
}

//Mark: -
extension FriendsBusinessCardViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if filteredUsersArray.count > 0 {
            return keys.count
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[keys[section]]!.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
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
        let user = data[keys[indexPath.section]]?[indexPath.row]
        cell.bindDate(user!)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectUser = data[keys[indexPath.section]]?[indexPath.row]
        var displayName = ""
        if conversation.isGroup {
            let group = conversation.target as! JMSGGroup
            displayName = group.displayName()
        } else {
            displayName = conversation.title ?? ""
        }
        JCAlertView.bulid().setTitle("发送给：\(displayName)")
            .setMessage(selectUser.displayName() + "的名片")
            .setDelegate(self)
            .addCancelButton("取消")
            .addButton("确定")
            .show()
    }
}

extension FriendsBusinessCardViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != 1 {
            return
        }


        let message = JMSGMessage.createBusinessCardMessage(conversation, self.selectUser.username, self.selectUser.appKey ?? "")
        let optionalContent = JMSGOptionalContent()
        optionalContent.needReadReceipt = true
        JMSGMessage.send(message, optionalContent: optionalContent)
        MBProgressHUD_JChat.show(text: "已发送", view: view, 2)
        weak var weakSelf = self
        let time: TimeInterval = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kReloadAllMessage), object: nil)
            weakSelf?.dismiss(animated: true, completion: nil)
        }
    }
}

extension FriendsBusinessCardViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchText)
    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // 搜索非好友
//        let searchText = searchBar.text!
//        JMSGUser.userInfoArray(withUsernameArray: [searchText]) { (result, error) in
//            if error == nil {
//                let users = result as! [JMSGUser]
//                self.searchUser = users.first
//                self._classify([self.searchUser!])
//                self.tipsView.isHidden = true
//            } else {
//                // 未查询到该用户的信息
//                self.tipsView.isHidden = false
//            }
//        }
//    }
}
