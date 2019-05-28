//
//  JCChatRoomListViewController.swift
//  JChat
//
//  Created by xudong.rao on 2019/4/16.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit
import MJRefresh


class JCChatRoomListViewController: UIViewController {

    fileprivate var index = 0
    fileprivate var pageCount = 20
    fileprivate lazy var chatRoomList: [JMSGChatRoom] = []
    fileprivate lazy var listTableView: UITableView = {
        var contacterView = UITableView(frame: .zero, style: .plain)
        contacterView.delegate = self
        contacterView.dataSource = self
        contacterView.separatorStyle = .none
        contacterView.sectionIndexColor = UIColor(netHex: 0x2dd0cf)
        contacterView.sectionIndexBackgroundColor = .clear
        return contacterView
    }()
    
    // 搜索控制器
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
        searchBar.placeholder = "请输入 roomID"
        searchVC.searchBar.returnKeyType = .search
        searchBar.setSearchFieldBackgroundImage(UIImage.createImage(color: .white, size: CGSize(width: UIScreen.main.bounds.size.width, height: 31)), for: .normal)
        
        return searchVC
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "聊天室"
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        
        if #available(iOS 10.0, *) {
            navigationController?.tabBarItem.badgeColor = UIColor(netHex: 0xEB424C)
        }
        listTableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        listTableView.backgroundColor = UIColor(netHex: 0xe8edf3)
        view.addSubview(listTableView)
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        listTableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        listTableView.mj_footer = footer
        listTableView.mj_footer.isHidden = true
        
        listTableView.mj_header.beginRefreshing();
    }
    
    // 顶部刷新
    @objc func headerRefresh() {
        index = 0
        let time: TimeInterval = 0.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self._getChatRoomList(complete: { (isSuccess) in
                //
            });
        }
    }
    // 底部加载
    @objc func footerRefresh() {
        print("上拉刷新 index = \(index)")
        index += pageCount
        
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self._getChatRoomList(complete: { (isSuccess) in
                DispatchQueue.main.async {
                    if !isSuccess {
                        self.index -= self.pageCount
                    }
                }
            });
        }
    }
    typealias DataComplete = (Bool) -> Void
    // SDK 接口获取数据
    func _getChatRoomList(complete: @escaping DataComplete) {
        JMSGChatRoom.getListWithAppKey(nil, start: index, count: pageCount) { (result, error) in
            if error != nil {
                self.index -= 1
                self.listTableView.mj_footer.endRefreshing();
                complete(false)
                return
            }
            DispatchQueue.main.async {
                if self.index == 0 {
                    self.chatRoomList.removeAll()
                }
                if let rooms = result as? [JMSGChatRoom] {
                    let count = self.chatRoomList.count
                    var indexPaths: [IndexPath] = []
                    for index in 0..<rooms.count {
                        let room = rooms[index]
                        self.chatRoomList.append(room)
                        let row = count + index
                        let indexPath = IndexPath(row: row, section: 0)
                        indexPaths.append(indexPath)
                    }
                    
                    if self.index != 0 {
                        self.listTableView.insertRows(at: indexPaths, with: .bottom)
                    }else{
                        self.listTableView.reloadData()
                        if self.chatRoomList.count > 0 {
                            self.listTableView.tableHeaderView = self.searchController.searchBar
                            self.listTableView.mj_footer.isHidden = false
                        }
                    }
                    if rooms.count == 0 {
                        self.listTableView.mj_footer.isHidden = true
                        complete(false)
                    }else{
                        complete(true)
                    }
                }else{
                    complete(false)
                }
                self.listTableView.mj_footer.endRefreshing();
                self.listTableView.mj_header.endRefreshing();
            }
        }
    }
}

extension JCChatRoomListViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomList.count
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
        
        let room = chatRoomList[indexPath.row]
        cell?.nameLabel.text = room.displayName()
        cell?.descLabel.text = room.desc
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = chatRoomList[indexPath.row]
        MBProgressHUD_JChat.show(text: "loading···", view: self.view)
        JMSGChatRoom.leaveChatRoom(withRoomId: room.roomID) { (result, error) in
            printLog("leave the chat room，error:\(String(describing: error))")
            let con = JMSGConversation.chatRoomConversation(withRoomId: room.roomID)
            if con == nil {
                printLog("enter the chat room first")
                JMSGChatRoom.enterChatRoom(withRoomId: room.roomID) { (result, error) in
                    MBProgressHUD_JChat.hide(forView: self.view, animated: true)
                    if let con1 = result as? JMSGConversation {
                        let vc = JCChatRoomChatViewController(conversation: con1, room: room)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        printLog("\(String(describing: error))")
                        if let error = error as NSError? {
                            if error.code == 851003 {//member has in the chatroom
                                JMSGConversation.createChatRoomConversation(withRoomId: room.roomID) { (result, error) in
                                    if let con = result as? JMSGConversation {
                                        let vc = JCChatRoomChatViewController(conversation: con, room: room)
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                printLog("go straight to the chat room session")
                let vc = JCChatRoomChatViewController(conversation: con!, room: room)
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
    }
}

// 搜索控制器代理
extension JCChatRoomListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        listTableView.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        listTableView.isHidden = false
        let nav = searchController.searchResultsController as! JCNavigationController
        nav.isNavigationBarHidden = true
        nav.popToRootViewController(animated: false)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func didDismissSearchController(_ searchController: UISearchController){
        let nav = searchController.searchResultsController as! JCNavigationController
        let searchResultVC =  nav.viewControllers.first as! JCCRSearchResultViewController
        if searchResultVC.selectChatRoom != nil {
            let vc = JCChatRoomInfoTableViewController.init(nibName: "JCChatRoomInfoTableViewController", bundle: nil)
            vc.chatRoom = searchResultVC.selectChatRoom
            vc.isFromSearch = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

// searBar delegate
extension JCChatRoomListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("\(String(describing: searchBar.text))")
        
        let nav = searchController.searchResultsController as! JCNavigationController
        let vc = nav.topViewController as! JCCRSearchResultViewController
        vc._searchChatRoom(searchBar.text ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search bar cancel")
        let nav = searchController.searchResultsController as! JCNavigationController
        let vc = nav.topViewController as! JCCRSearchResultViewController
        vc._clearHistoricalRecord()
        vc.selectChatRoom = nil
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        for view in (searchBar.subviews.first?.subviews)! {
            if view is UIButton {
                let cancelButton = view as! UIButton
                cancelButton.setTitleColor(UIColor(netHex: 0x2dd0cf), for: .normal)
                break
            }
        }
    }

}

