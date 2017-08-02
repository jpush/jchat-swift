//
//  JCConversationListViewController.swift
//  JChat
//
//  Created by deng on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage
import YHPopupView

class JCConversationListViewController: UIViewController {
    
    var datas: [JMSGConversation] = []

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isConnecting {
            titleTips.text = "连接中"
            titleTips.isHidden = false
        } else {
            titleTips.isHidden = true
        }
        _getConversations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        titleTips.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate var isConnecting = false
    
    private lazy var addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    private lazy var searchController: JCSearchController = JCSearchController(searchResultsController: JCNavigationController(rootViewController: JCSearchResultViewController()))
    private lazy var searchView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 36))
    fileprivate lazy var tableview: UITableView = {
        var tableview = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor(netHex: 0xe8edf3)
        tableview.register(JCConversationCell.self, forCellReuseIdentifier: "JCConversationCell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorStyle = .none
        return tableview
    }()
    fileprivate lazy var errorTips: JCNetworkTipsCell = JCNetworkTipsCell()
    fileprivate var showNetworkTips = false
    fileprivate lazy var emptyView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 64 + 36, width: self.view.width, height: self.view.height - 64 - 36))
        view.isHidden = true
        view.backgroundColor = .white
        let tips = UILabel()
        tips.text = "暂无会话"
        tips.textColor = UIColor(netHex: 0x999999)
        tips.sizeToFit()
        tips.center = CGPoint(x: view.centerX, y: view.height / 2 - 60)
        view.addSubview(tips)
        return view
    }()
    
    fileprivate lazy var titleTips: UILabel = {
        var tips = UILabel(frame: CGRect(x: self.view.width / 2 - 50, y: 20, width: 100, height: 44))
        tips.font = UIFont.systemFont(ofSize: 18)
        tips.textColor = UIColor.white
        tips.textAlignment = .center
        tips.backgroundColor = UIColor(netHex: 0x5AD4D3)
        tips.isHidden = true
        return tips
    }()
    
    //Mark: - private func
    private func _init() {
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        if #available(iOS 10.0, *) {
            navigationController?.tabBarItem.badgeColor = UIColor(netHex: 0xEB424C)
        }
        
        let appDelegate = UIApplication.shared.delegate
        let window = appDelegate?.window!
        window?.addSubview(titleTips)
        
        _setupNavigation()
        JMessage.add(self, with: nil)
        let nav = searchController.searchResultsController as! JCNavigationController
        let vc = nav.topViewController as! JCSearchResultViewController
        searchController.delegate = self
        searchController.searchResultsUpdater = vc
        searchView.addSubview(searchController.searchBar)
        searchView.backgroundColor = UIColor(netHex: 0xe8edf3)
        tableview.tableHeaderView = searchView
        view.addSubview(tableview)
        view.addSubview(emptyView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"), object: nil)

        _getConversations()
        NotificationCenter.default.addObserver(self, selector: #selector(_getConversations), name: NSNotification.Name(rawValue: kUpdateConversation), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectClose), name: NSNotification.Name.jmsgNetworkDidClose, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectSucceed), name: NSNotification.Name.jmsgNetworkDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connecting), name: NSNotification.Name.jmsgNetworkIsConnecting, object: nil)
    }
    
    func reachabilityChanged(note: NSNotification) {
        if let curReach = note.object as? Reachability {
            let status = curReach.currentReachabilityStatus()
            switch status {
            case NotReachable:
                notReachable()
            default :
                reachable()
            }
        }
    }
    
    private func _setupNavigation() {
        addButton.addTarget(self, action: #selector(_clickNavRightButton(_:)), for: .touchUpInside)
        addButton.setImage(UIImage.loadImage("com_icon_add"), for: .normal)
        let item = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem =  item
    }
    
    func _updateBadge() {
        let count = getAllConversation(datas)
        if count > 99 {
            navigationController?.tabBarItem.badgeValue = "99+"
        } else {
            navigationController?.tabBarItem.badgeValue = count == 0 ? nil : "\(count)"
        }
    }
    
    func _getConversations() {
        JMSGConversation.allConversations { (result, error) in
            guard let conversatios = result else {
                return
            }
            self.datas = conversatios as! [JMSGConversation]
            self.tableview.reloadData()
            if self.datas.count == 0 {
                self.emptyView.isHidden = false
            } else {
                self.emptyView.isHidden = true
            }
            self._updateBadge()
        }
    }
    
    //MARK: - click func
    func _clickNavRightButton(_ sender: UIButton) {
        _setupPopView()
    }
    
    func _addFriend() {
        dismissPopupView()
        navigationController?.pushViewController(JCSearchFriendViewController(), animated: true)
    }
    
    func _addSingle() {
        dismissPopupView()
        let vc = JCSearchFriendViewController()
        vc.isSearchUser = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func _addGroup() {
        dismissPopupView()
        let vc = JCUpdateMemberViewController()
        vc.isAddMember = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func _setupPopView() {
        presentPopupView(selectView)
    }
    
    fileprivate lazy var selectView: YHPopupView = {
        let popupView = YHPopupView(frame: CGRect(x: self.view.width - 145, y: 65, width: 140, height: 137.5))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 137.5))
        imageView.image = UIImage.loadImage("com_icon _selectList")
        popupView?.addSubview(imageView)
        popupView?.backgroundViewColor = .clear
        popupView?.clickBlankSpaceDismiss = true
        
        let height = (137.5 - 5) / 3
        let width = 140.0
        
        let image = UIImage.createImage(color: UIColor(netHex: 0x02BDBC), size: CGSize(width: 140, height: height))
        
        let addFriend = UIButton(frame: CGRect(x: 0.0, y: 5 + height * 2, width: width, height: height))
        addFriend.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addFriend.addTarget(self, action: #selector(_addFriend), for: .touchUpInside)
        addFriend.setImage(UIImage.loadImage("com_icon_friend_add"), for: .normal)
        addFriend.setImage(UIImage.loadImage("com_icon_friend_add"), for: .highlighted)
        addFriend.setBackgroundImage(image, for: .highlighted)
        
        let addGroup = UIButton(frame: CGRect(x: 0.0, y: 5 + height, width: width, height: height))
        addGroup.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addGroup.addTarget(self, action: #selector(_addGroup), for: .touchUpInside)
        addGroup.setImage(UIImage.loadImage("com_icon_conv_group"), for: .normal)
        addGroup.setImage(UIImage.loadImage("com_icon_conv_group"), for: .highlighted)
        addGroup.setBackgroundImage(image, for: .highlighted)
        
        let addSingle = UIButton(frame: CGRect(x: 0.0, y: 5, width: width, height: height))
        addSingle.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addSingle.addTarget(self, action: #selector(_addSingle), for: .touchUpInside)
        addSingle.setImage(UIImage.loadImage("com_icon_conv_single"), for: .normal)
        addSingle.setImage(UIImage.loadImage("com_icon_conv_single"), for: .highlighted)
        addSingle.setBackgroundImage(image, for: .highlighted)
        
        addFriend.setTitle("  添加朋友", for: .normal)
        addSingle.setTitle("  发起单聊", for: .normal)
        addGroup.setTitle("  发起群聊", for: .normal)
        popupView?.addSubview(addSingle)
        popupView?.addSubview(addGroup)
        popupView?.addSubview(addFriend)
        return popupView!
    }()
}

extension JCConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showNetworkTips ? datas.count + 1 : datas.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showNetworkTips && indexPath.row == 0 {
            errorTips.selectionStyle = .none
            return errorTips
        }
        return tableView.dequeueReusableCell(withIdentifier: "JCConversationCell", for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? JCConversationCell else {
            return
        }
        cell.bindConversation(datas[showNetworkTips ? indexPath.row - 1 : indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showNetworkTips && indexPath.row == 0 {
            return 40
        }
        return 65
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if showNetworkTips && indexPath.row == 0 {
            return 
        }
        let conversation = datas[showNetworkTips ? indexPath.row - 1 : indexPath.row]
        conversation.clearUnreadCount()
        guard let cell = tableView.cellForRow(at: indexPath) as? JCConversationCell else {
            return
        }
        cell.bindConversation(conversation)
        let vc = JCChatViewController(conversation: conversation)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            self._delete(indexPath)
        }
//        let action2 = UITableViewRowAction(style: .normal, title: "顶置") { (action, indexPath) in
//
//        }
        return [action1]
    }

    private func _delete(_ indexPath: IndexPath) {
        let conversation = datas[indexPath.row]
        let tager = conversation.target
        JCDraft.update(text: nil, conversation: conversation)
        if conversation.isGroup {
            guard let group = tager as? JMSGGroup else {
                return
            }
            JMSGConversation.deleteGroupConversation(withGroupId: group.gid)
        } else {
            guard let user = tager as? JMSGUser else {
                return
            }
            JMSGConversation.deleteSingleConversation(withUsername: user.username, appKey: user.appKey!)
        }
        datas.remove(at: indexPath.row)
        if datas.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        tableview.reloadData()
    }
    
}

extension JCConversationListViewController: JMessageDelegate {
    
    func onReceive(_ message: JMSGMessage!, error: Error!) {
        _getConversations()
    }
    
    func onConversationChanged(_ conversation: JMSGConversation!) {
        _getConversations()
    }
    
    func onGroupInfoChanged(_ group: JMSGGroup!) {
        _getConversations()
    }
    
    func onSyncRoamingMessageConversation(_ conversation: JMSGConversation!) {
        _getConversations()
    }
    
    func onSyncOfflineMessageConversation(_ conversation: JMSGConversation!, offlineMessages: [JMSGMessage]!) {
        _getConversations()
    }
    
    func onReceive(_ retractEvent: JMSGMessageRetractEvent!) {
        _getConversations()
    }
    
}

extension JCConversationListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        tableview.isHidden = true
        emptyView.isHidden = true
        UIView.animate(withDuration: 0.35, animations: { 
            self.emptyView.frame = CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height - 64)
        }) { (_) in
            self.navigationController?.tabBarController?.tabBar.isHidden = true
        }
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.35) {
            self.emptyView.frame = CGRect(x: 0, y: 64 + 36, width: self.view.width, height: self.view.height - 64 - 36)
        }
        tableview.isHidden = false
        if datas.count == 0 {
            emptyView.isHidden = false
        }
        let nav = searchController.searchResultsController as! JCNavigationController
        nav.isNavigationBarHidden = true
        nav.popToRootViewController(animated: false)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - network tips
extension JCConversationListViewController {
    
    func reachable() {
        if !showNetworkTips {
            return
        }
        showNetworkTips = false
        tableview.reloadData()
    }
    
    func notReachable() {
        if showNetworkTips {
            return
        }
        showNetworkTips = true
        if datas.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableview.beginUpdates()
            tableview.insertRows(at: [indexPath], with: .automatic)
            tableview.endUpdates()
        } else {
            tableview.reloadData()
        }
    }
    
    func connectClose() {
        isConnecting = false
        titleTips.isHidden = true
    }
    
    func connectSucceed() {
        isConnecting = false
        titleTips.isHidden = true
    }
    
    func connecting() {
        _connectingSate()
    }
    
    func _connectingSate() {
        let window = UIApplication.shared.delegate?.window
        if let window = window {
            guard let rootViewController = window?.rootViewController as? JCMainTabBarController else {
                return
            }
            guard let nav = rootViewController.selectedViewController as? JCNavigationController else {
                return
            }
            guard let currentVC = nav.topViewController else {
                return
            }
            if currentVC.isKind(of: JCConversationListViewController.self) {
                isConnecting = true
                titleTips.text = "连接中"
                titleTips.isHidden = false
            }
        }
    }
}

@inline(__always)
internal func getAllConversation(_ conversations: [JMSGConversation]) -> Int {
    var count = 0
    for item in conversations {
        if let group = item.target as? JMSGGroup {
            // TODO: isNoDisturb 这个接口存在性能问题，如果大量离线会卡死
            if group.isNoDisturb {
                continue
            }
        }
        if let user = item.target as? JMSGUser {
            if user.isNoDisturb {
                continue
            }
        }
        count += item.unreadCount?.intValue ?? 0
    }
    return count
}


