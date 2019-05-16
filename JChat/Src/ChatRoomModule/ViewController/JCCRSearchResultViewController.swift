//
//  JCCRSearchResultViewController.swift
//  JChat
//
//  Created by xudong.rao on 2019/4/19.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCCRSearchResultViewController: UIViewController {

    var searchController: UISearchController!
    fileprivate var searchString = ""
    var searchResultList: [JMSGChatRoom] = []
    
    fileprivate lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = .clear
        tableView.backgroundColor = UIColor(netHex: 0xe8edf3)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        return tableView
    }()
    
    private lazy var tipsLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.width, height: 22.5))
    private lazy var networkErrorView: UIView = {
        let tipsView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height))
        var tipsLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 100, width: tipsView.width, height: 22.5))
        tipsLabel.textColor = UIColor(netHex: 0x999999)
        tipsLabel.textAlignment = .center
        tipsLabel.font = UIFont.systemFont(ofSize: 16)
        tipsLabel.text = "无法连接网络"
        tipsView.addSubview(tipsLabel)
        tipsView.isHidden = true
        tipsView.backgroundColor = .white
        return tipsView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if searchController != nil {
            searchController.searchBar.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func _init() {
        view.backgroundColor = UIColor.gray //UIColor(netHex: 0xe8edf3)
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.automaticallyAdjustsScrollViewInsets = false
        
        tipsLabel.font = UIFont.systemFont(ofSize: 16)
        tipsLabel.textColor = UIColor(netHex: 0x999999)
        tipsLabel.textAlignment = .center
        view.addSubview(tipsLabel)
                
        view.addSubview(tableView)
        view.addSubview(networkErrorView)
        
        if JCNetworkManager.isNotReachable {
            networkErrorView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"), object: nil)
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        if let curReach = note.object as? Reachability {
            let status = curReach.currentReachabilityStatus()
            switch status {
            case NotReachable:
                networkErrorView.isHidden = false
            default :
                networkErrorView.isHidden = true
            }
        }
    }
    
    public func _searchChatRoom(_ roomID: String) {
        let roomIDs = [roomID]
        JMSGChatRoom.getChatRoomInfos(withRoomIds: roomIDs) { (result, error) in
            if let rooms = result as? [JMSGChatRoom] {
                if rooms.count > 0 {
                    self.searchResultList.removeAll()
                }
                for index in 0..<rooms.count {
                    let room = rooms[index]
                    self.searchResultList.append(room)
                }
            }
            if self.searchResultList.count > 0 {
                self.tableView.reloadData()
            }
        };
    }
    public func _clearHistoricalRecord() {
        self.searchResultList.removeAll()
        self.tableView.reloadData()
    }
}

extension JCCRSearchResultViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "JCChatRoomListTableViewCell"
        var cell: JCChatRoomListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? JCChatRoomListTableViewCell
        if cell == nil {
            cell = JCChatRoomListTableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        
        let room = self.searchResultList[indexPath.row]
        cell?.nameLabel.text = room.displayName()
        cell?.descLabel.text = room.desc
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = self.searchResultList[indexPath.row]
        
        let con = JMSGConversation.chatRoomConversation(withRoomId: room.roomID)
        if con == nil {
            MBProgressHUD_JChat.show(text: "loading···", view: self.view)
            JMSGChatRoom.enterChatRoom(withRoomId: room.roomID) { (result, error) in
                MBProgressHUD_JChat.hide(forView: self.view, animated: true)
                
                if let con1 = result as? JMSGConversation {
                    let vc = JCChatRoomChatViewController(conversation: con1, room: room)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            };
        }else{
            let vc = JCChatRoomChatViewController(conversation: con!, room: room)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.searchController.searchBar.isHidden = true
        self.searchController.searchBar.resignFirstResponder()
    }
}

extension JCCRSearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchController = searchController
        searchString = searchController.searchBar.text!
        print("chatroom search result :\(searchString)")
    }
}

