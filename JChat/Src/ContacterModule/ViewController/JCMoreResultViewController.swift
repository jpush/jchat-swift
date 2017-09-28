//
//  JCMoreResultViewController.swift
//  JChat
//
//  Created by deng on 2017/5/8.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCMoreResultViewController: UIViewController {
    
    var searchResultView: JCSearchResultViewController!
    var searchController: UISearchController!
    
    var users: [JMSGUser] = []
    var groups: [JMSGGroup] = []

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if searchController != nil {
            searchController.searchBar.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        self.searchResultView.removeObserver(self, forKeyPath: "filteredUsersArray")
        self.searchResultView.removeObserver(self, forKeyPath: "filteredGroupsArray")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "filteredUsersArray" {
            self.users = searchResultView.filteredUsersArray
        }
        if keyPath == "filteredGroupsArray" {
            self.groups = searchResultView.filteredGroupsArray
        }
        self.tableView.reloadData()
    }
    
    fileprivate lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height - 64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(JCContacterCell.self, forCellReuseIdentifier: "JCContacterCell")
        return tableView
    }()

    //MARK: - private func
    private func _init() {
        self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(netHex: 0xe8edf3)
        view.addSubview(tableView)
        searchResultView.addObserver(self, forKeyPath: "filteredUsersArray", options: .new, context: nil)
        searchResultView.addObserver(self, forKeyPath: "filteredGroupsArray", options: .new, context: nil)
    }
   
}

//Mark: -
extension JCMoreResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0 {
            return users.count
        }
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "JCContacterCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? JCContacterCell else {
            return
        }
        if users.count > 0 {
            cell.bindDate(users[indexPath.row])
        } else {
            cell.bindDateWithGroup(group: groups[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if users.count > 0 {
            let vc = JCMyInfoViewController()
            if self.searchController != nil {
                self.searchController.searchBar.resignFirstResponder()
                self.searchController.searchBar.isHidden = true
            }
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let group = groups[indexPath.row]
            JMSGConversation.createGroupConversation(withGroupId: group.gid) { (result, error) in
                let conv = result as! JMSGConversation
                let vc = JCChatViewController(conversation: conv)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateConversation), object: nil, userInfo: nil)
                if self.searchController != nil {
                    self.searchController.searchBar.resignFirstResponder()
                    self.searchController.searchBar.isHidden = true
                }
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
