//
//  JCUpdateMemberViewController.swift
//  JChat
//
//  Created by deng on 2017/5/11.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCUpdateMemberViewController: UIViewController {
    
    var isAddMember = true
    var group: JMSGGroup?
    var currentUser: JMSGUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectUsers.count == 0 {
            confirm.alpha = 0.5
            navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate lazy var toolView: UIView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.width, height: 55))
    fileprivate var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    fileprivate var collectionView: UICollectionView!
    fileprivate lazy var searchView: UISearchBar = UISearchBar()
    fileprivate lazy var confirm = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 28))
    
    fileprivate lazy var users: [JMSGUser] = []
    fileprivate lazy var keys: [String] = []
    fileprivate lazy var data: Dictionary<String, [JMSGUser]> = Dictionary()
    
    fileprivate lazy var filteredUsersArray: [JMSGUser] = []
    fileprivate lazy var selectUsers: [JMSGUser] = []
    fileprivate var searchUser: JMSGUser?
    fileprivate var members: [JMSGUser]?
    
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
        self.view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        if isAddMember {
            self.title = "添加成员"
            members = group?.memberArray()
        } else {
            self.title = "发起群聊"
        }
        
        view.addSubview(toolView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionIndexColor = UIColor(netHex: 0x2dd0cf)
        tableView.sectionIndexBackgroundColor = .clear
        tableView.register(JCSelectMemberCell.self, forCellReuseIdentifier: "JCSelectMemberCell")
        tableView.frame = CGRect(x: 0, y: 31 + 64, width: view.width, height: view.height - 31 - 64)
        view.addSubview(tableView)
        
        view.addSubview(tipsView)
        
        _classify([], isFrist: true)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(JCUpdateMemberCell.self, forCellWithReuseIdentifier: "JCUpdateMemberCell")
        
        searchView.frame = CGRect(x: 15, y: 0, width: toolView.width - 30, height: 31)
        searchView.barStyle = .default
        searchView.backgroundColor = .white
        searchView.barTintColor = .white
        searchView.delegate = self
        searchView.autocapitalizationType = .none
        searchView.placeholder = "可搜索非好友"
        searchView.layer.borderColor = UIColor.white.cgColor
        searchView.layer.borderWidth = 1
        searchView.layer.masksToBounds = true
        
        
        toolView.addSubview(searchView)
        toolView.addSubview(collectionView)
        
        _setupNavigation()
    }
    
    private func _setupNavigation() {
        confirm.addTarget(self, action: #selector(_clickNavRightButton(_:)), for: .touchUpInside)
        confirm.setTitle("确定", for: .normal)
        confirm.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirm.contentHorizontalAlignment = .right
        let item = UIBarButtonItem(customView: confirm)
        navigationItem.rightBarButtonItem =  item
    }
    
    fileprivate func _classify(_ users: [JMSGUser], isFrist: Bool = false) {
        
        if users.count > 0 {
            self.tipsView.isHidden = true
        }
        
        if isFrist {
            JMSGFriendManager.getFriendList { (result, error) in
                if error == nil {
                    self.users.removeAll()
                    self.keys.removeAll()
                    self.data.removeAll()
                    for item in result as! [JMSGUser] {
                        if self.currentUser != nil {
                            if item.username == (self.currentUser?.username)! {
                                continue
                            }
                        }
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
                    self.collectionView.reloadData()
                }
            }
        } else {
            filteredUsersArray = users
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
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func _removeUser(_ user: JMSGUser) {
        var index = -1
        for ind in 0..<selectUsers.count {
            let item = selectUsers[ind]
            if item.username == user.username && item.appKey == user.appKey {
                index = ind
                break
            }
        }
        if index != -1 {
            selectUsers.remove(at: index)
        }
    }
    
    fileprivate func _reloadCollectionView() {
        if selectUsers.count > 0 {
            confirm.alpha = 1.0
            confirm.setTitle("确定(\(selectUsers.count))", for: .normal)
            navigationController?.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            confirm.alpha = 0.5
            confirm.setTitle("确定", for: .normal)
            navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        switch selectUsers.count {
        case 0:
            collectionView.frame = .zero
            searchView.frame = CGRect(x: 15, y: 0, width: toolView.width - 30, height: 31)
            toolView.frame = CGRect(x: 0, y: 64, width: toolView.width, height: 31)
            tableView.frame = CGRect(x: tableView.x, y: 64 + 31, width: tableView.width, height: view.height - 64 - 31)
            tipsView.frame = CGRect(x: 0, y: 64 + 31 + 5, width: self.view.width, height: self.view.height - 31 - 64 - 5)
        case 1:
            collectionView.frame = CGRect(x: 10, y: 0, width: 46, height: 55)
            searchView.frame = CGRect(x: 5 + 46, y: 0, width: toolView.width - 5 - 46, height: 55)
            toolView.frame = CGRect(x: 0, y: 64, width: toolView.width, height: 55)
            tableView.frame = CGRect(x: tableView.x, y: 64 + 55, width: tableView.width, height: view.height - 64 - 55)
            tipsView.frame = CGRect(x: 0, y: 64 + 31 + 5 + 24, width: self.view.width, height: self.view.height - 31 - 40 - 5)
        case 2:
            collectionView.frame = CGRect(x: 10, y: 0, width: 92, height: 55)
            searchView.frame = CGRect(x: 5 + 46 * 2, y: 0, width: toolView.width - 5 - 46 * 2, height: 55)
        case 3:
            collectionView.frame = CGRect(x: 10, y: 0, width: 138, height: 55)
            searchView.frame = CGRect(x: 5 + 46 * 3, y: 0, width: toolView.width - 5 - 46 * 3, height: 55)
        case 4:
            collectionView.frame = CGRect(x: 10, y: 0, width: 184, height: 55)
            searchView.frame = CGRect(x: 5 + 46 * 4, y: 0, width: toolView.width - 5 - 46 * 4, height: 55)
        default:
            collectionView.frame = CGRect(x: 10, y: 0, width: 230, height: 55)
            searchView.frame = CGRect(x: 5 + 46 * 5, y: 0, width: toolView.width - 5 - 46 * 5, height: 55)
        }
        self.collectionView.reloadData()
    }
    
    func _clickNavRightButton(_ sender: UIButton) {
        if selectUsers.count == 0 {
            return
        }
        var userNames: [String] = []
        for item in selectUsers {
            userNames.append(item.username)
        }
        if isAddMember {
            MBProgressHUD_JChat.showMessage(message: "添加中...", toView: self.view)
            group?.addMembers(withUsernameArray: userNames, completionHandler: { (result, error) in
                MBProgressHUD_JChat.hide(forView: self.view, animated: true)
                if error == nil {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateGroupInfo), object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    MBProgressHUD_JChat.show(text: "添加失败，请重试", view: self.view)
                }
            })
        
        } else {
            if currentUser != nil {
                userNames.insert((currentUser?.username)!, at: 0)
            }
            MBProgressHUD_JChat.showMessage(message: "创建中...", toView: self.view)
            JMSGGroup.createGroup(withName: nil, desc: nil, memberArray: userNames, completionHandler: { (result, error) in
                MBProgressHUD_JChat.hide(forView: self.view, animated: true)
                if error == nil {
                    for vc in (self.navigationController?.viewControllers)! {
                        if vc is JCConversationListViewController {
                            self.navigationController?.popToViewController(vc, animated: true)
                            let group = result as! JMSGGroup
                            JMSGConversation.createGroupConversation(withGroupId: group.gid, completionHandler: { (result, error) in
                                let conv = JMSGConversation.groupConversation(withGroupId: group.gid)
                                let chatVC = JCChatViewController(conversation: conv!)
                                vc.navigationController?.pushViewController(chatVC, animated: true)
                            })
                        }
                    }
                    
                } else {
                    MBProgressHUD_JChat.show(text: "创建失败，请重试", view: self.view)
                }
            })
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
extension JCUpdateMemberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if filteredUsersArray.count > 0 {
            return keys.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[keys[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.keys
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
        return tableView.dequeueReusableCell(withIdentifier: "JCSelectMemberCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? JCSelectMemberCell else {
            return
        }
        let user = self.data[keys[indexPath.section]]?[indexPath.row]
        cell.bindDate(user!)
        if let members = members {
            if members.contains(where: { (u) -> Bool in
                return u.username == user?.username && u.appKey == user?.appKey
            }) {
                cell.selectIcon = UIImage.loadImage("com_icon_isSelect")
                return
            }
        }
        if selectUsers.contains(where: { (u) -> Bool in
            return u.username == user?.username && u.appKey == user?.appKey
        })  {
            cell.selectIcon = UIImage.loadImage("com_icon_select")
        } else {
            cell.selectIcon = UIImage.loadImage("com_icon_unselect")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? JCSelectMemberCell else {
            return
        }
        let user = self.data[keys[indexPath.section]]?[indexPath.row]
        if members != nil {
            if (members?.contains(where: { (u) -> Bool in
                return u.username == user?.username && u.appKey == user?.appKey
            }))! {
                return
            }
        }
        if selectUsers.contains(where: { (u) -> Bool in
            return u.username == user?.username && u.appKey == user?.appKey
        })  {
            // remove
            cell.selectIcon = UIImage.loadImage("com_icon_unselect")
            self._removeUser(user!)
            _reloadCollectionView()
        } else {
            selectUsers.append(user!)
            cell.selectIcon = UIImage.loadImage("com_icon_select")
            _reloadCollectionView()
        }
        if selectUsers.count > 0 {
            self.collectionView.scrollToItem(at: IndexPath(row: selectUsers.count - 1, section: 0), at: .right, animated: false)
        }
    }
}

extension JCUpdateMemberViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 46, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "JCUpdateMemberCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? JCUpdateMemberCell else {
            return
        }
        
        cell.backgroundColor = .white
        cell.bindDate(user: selectUsers[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectUsers.remove(at: indexPath.row)
        self.tableView.reloadData()
        _reloadCollectionView()
    }
}

extension JCUpdateMemberViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 搜索非好友
        let searchText = searchBar.text!
        JMSGUser.userInfoArray(withUsernameArray: [searchText]) { (result, error) in
            if error == nil {
                let users = result as! [JMSGUser]
                self.searchUser = users.first
                self._classify([self.searchUser!])
                self.tipsView.isHidden = true
            } else {
                // 未查询到该用户的信息
                self.tipsView.isHidden = false
            }
        }
    }
}


