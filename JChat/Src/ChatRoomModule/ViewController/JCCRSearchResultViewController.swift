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
    var selectChatRoom: JMSGChatRoom!
    fileprivate var searchString = ""
    var searchResultList: [JMSGChatRoom] = []
    
    fileprivate lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = .clear
        tableView.backgroundColor = UIColor.init(red: 232, green: 237, blue: 243)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.automaticallyAdjustsScrollViewInsets = false
        
        tipsLabel.font = UIFont.systemFont(ofSize: 16)
        tipsLabel.textColor = UIColor(netHex: 0x999999)
        tipsLabel.textAlignment = .center
        view.addSubview(tableView)
        view.addSubview(networkErrorView)
        view.addSubview(tipsLabel)
        
        tableView.mas_makeConstraints({ (make) in
            if UIDevice.current.isAboveiPhoneX() {
                make?.top.equalTo()(self.view.mas_top)?.offset()(100)
            }else{
                make?.top.equalTo()(self.view.mas_top)?.offset()(64)
            }
            make?.left.equalTo()(self.view)
            make?.right.equalTo()(self.view)
            make?.bottom.equalTo()(self.view)
        })
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
                self.tipsLabel.isHidden = true
                self.tipsLabel.attributedText = nil
                self.tableView.reloadData()
            }else{
                self.tipsLabel.isHidden = false
                let attr = NSMutableAttributedString(string: "没有搜到聊天室 ")
                let attrSearchString = NSAttributedString(string: roomID, attributes: self.convertToOptionalNSAttributedStringKeyDictionary([ self.convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor(netHex: 0x2dd0cf), self.convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.boldSystemFont(ofSize: 16.0)]))
                attr.append(attrSearchString)
                attr.append(NSAttributedString(string:  " 相关的信息"))
                self.tipsLabel.attributedText = attr
                print("没有搜索到聊天室")
            }
        };
    }
    public func _clearHistoricalRecord() {
        self.searchResultList.removeAll()
        self.tableView.reloadData()
        self.tipsLabel.attributedText = nil;
        self.tipsLabel.isHidden = true
    }
    
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
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
        selectChatRoom = self.searchResultList[indexPath.row]
        _clearHistoricalRecord()
        self.searchController.isActive = false
        
    }
}

extension JCCRSearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchController = searchController
        searchString = searchController.searchBar.text!
        self.tipsLabel.attributedText = nil
        if self.searchResultList.count > 0 && searchString.length == 0 {
            self.searchResultList.removeAll()
            self.tableView.reloadData()
        }
        print("chatroom search result :\(searchString)")
    }
}

