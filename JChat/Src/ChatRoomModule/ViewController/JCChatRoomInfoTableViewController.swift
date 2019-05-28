//
//  JCChatRoomInfoTableViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/23.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomInfoTableViewController: UITableViewController {
    open var chatRoom: JMSGChatRoom?
    open var isFromSearch: Bool = false
    var isOwner: Bool?
    var chatRoomOwner: JMSGUser?
    var isManager: Bool?
    var managerList: [JMSGUser]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "聊天室信息"
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        self.tableView.register(JCChatRoomInfoCell.self, forCellReuseIdentifier: "ChatRoomInfoCell")
        self.tableView.register(JCButtonCell.self, forCellReuseIdentifier: "JCButtonCell")
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Request
    func requestData()  {
        //获取房主信息
        self.chatRoom?.getOwnerInfo({ (result, error) in
            if let user = result as? JMSGUser {
                self.chatRoomOwner = user
                if user.uid == JMSGUser.myInfo().uid {
                    self.isOwner = true;
                }else{
                    self.isOwner = false;
                }
                self.tableView.reloadData()
            }else{
                print("获取房主信息失败")
            }
        })
        //获取管理员列表
        self.chatRoom?.chatRoomAdminList({ (result, error) in
            if let users = result as? [JMSGUser]{
                self.managerList = users
                for user in users {
                    if (user.uid == JMSGUser.myInfo().uid){
                        self.isManager = true
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if error != nil{
                let err = error! as NSError
                printLog("error:\(err.localizedDescription)")
            }
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 1
        }
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell2 =  tableView.dequeueReusableCell(withIdentifier: "JCButtonCell", for: indexPath)
            if let btnCell = cell2 as? JCButtonCell {
                btnCell.delegate = self
                if isFromSearch{
                    btnCell.button.setTitle("进入聊天室", for: .normal)
                }else{
                    btnCell.button.setTitle("退出聊天室", for: .normal)
                }
            }
            return cell2;
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomInfoCell", for: indexPath)

        let section0Title = ["聊天室名称","聊天室介绍"]
        let section1Title = ["房主","管理员"]
//        let section2Title = ["黑名单","禁言"]
        
        if(indexPath.section == 0){
            cell.textLabel?.text = section0Title[indexPath.row]
            if(indexPath.row == 0){
                cell.detailTextLabel?.text = self.chatRoom?.name
            }else{
                cell.detailTextLabel?.text = self.chatRoom?.desc
            }
        }else if(indexPath.section == 1 ){
            cell.textLabel?.text = section1Title[indexPath.row]
            if(indexPath.row == 0){
                cell.detailTextLabel?.text = self.chatRoomOwner?.displayName()
            }else{
                // 管理员头像展示，最多5个
                if let infoCell = cell as? JCChatRoomInfoCell {
                    infoCell.bindImages(users: self.managerList)
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            do {
                if(indexPath.row == 0){
                    let nameVC = JCChatRoomNameInfoViewController.init(nibName: "JCChatRoomNameInfoViewController", bundle: nil)
                    nameVC.roomName = self.chatRoom?.name
                    self.navigationController?.pushViewController(nameVC, animated: true)
                }else{
                    let introduceVC = JCChatRoomIntroduceViewController.init(nibName: "JCChatRoomIntroduceViewController", bundle: nil)
                        introduceVC.introduceText = self.chatRoom?.desc
                    self.navigationController?.pushViewController(introduceVC, animated: true)
                }
            }
            break;
        case 1:
            do {
                if(indexPath.row == 0 ){
                    //：权限房主是否存在
                    if(self.chatRoomOwner == nil){
                        MBProgressHUD_JChat.show(text: "获取房主信息失败", view: self.view)
                        print("获取房主信息失败")
                    }else{
                        let vc = JCUserInfoViewController()
                        vc.user = self.chatRoomOwner
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    let roomMangerList = JCChatRoomManagerListViewController.init()
                    roomMangerList.chatRoom = self.chatRoom?.copy() as? JMSGChatRoom
                    roomMangerList.isOwner = self.isOwner
                    self.navigationController?.pushViewController(roomMangerList, animated: true)
                }
            }
            break;
        default:
            break;
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0 {
            return 0
        }
        return 10
    }
    
    func logoutChatRoom(){
        let alert = UIAlertController.init(title: "退出聊天室", message: "是否确认退出该聊天室？", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default) { (UIAlertAction) in
            JMSGChatRoom.leaveChatRoom(withRoomId: self.chatRoom!.roomID, completionHandler: { (result, error) in
                if error == nil {
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    let err = error! as NSError
                    MBProgressHUD_JChat.show(text: err.localizedDescription, view: self.view)
                    printLog("退出聊天室失败,\(err.localizedDescription)")
                }
            }  )
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func enterChatRoom() {
        MBProgressHUD_JChat.show(text: "loading···", view: self.view)
        let con = JMSGConversation.chatRoomConversation(withRoomId: self.chatRoom!.roomID)
        if con == nil {
            //获取聊天室
            let room = self.chatRoom!
            JMSGChatRoom.enterChatRoom(withRoomId: self.chatRoom!.roomID) { (result, error) in
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
            };
        }else{
            let vc = JCChatRoomChatViewController(conversation: con!, room: self.chatRoom!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension JCChatRoomInfoTableViewController: JCButtonCellDelegate {
    
    func buttonCell(clickButton button: UIButton) {
        if isFromSearch{
            self.enterChatRoom()
        }else{
            self.logoutChatRoom()
        }
    }
}
