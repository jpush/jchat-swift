//
//  JCChatRoomAddManagerViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/25.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomAddManagerViewController: JCSearchFriendViewController {
    open var chatRoom: JMSGChatRoom?
    var dataArray: NSMutableArray! = NSMutableArray.init()
    override func viewDidLoad() {
        self.addChatRoomManger = true
        super.viewDidLoad()
        self.title = "添加管理员"
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        requestData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleResult), name: NSNotification.Name(rawValue: "SearchChatRoomManagerResult"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func requestData()  {
        self.chatRoom?.chatRoomAdminList({ (result, error) in
            if let managers = result as? [JMSGUser]{
                self.dataArray.removeAllObjects()
                self.dataArray?.addObjects(from: managers)
            }
        })
    }
    @objc func handleResult(){
        var isManager: Bool = false
        if  self.dataArray.count != 0 {
            for i in 0..<self.dataArray.count{
                let user = self.dataArray[i] as! JMSGUser
                if user.uid == self.user?.uid{
                    isManager = true
                    break
                }
            }
        }else{
            requestData()
        }
        if isManager {
            addButton.setTitle("已添加", for: .normal)
        }else{
            addButton.setTitle("添加", for: .normal)
            addButton.addTarget(self, action: #selector(_addRoomManager), for: .touchUpInside)
        }
    }
    @objc func _addRoomManager(){
        self.chatRoom?.addAdmin(withUsernames:[self.user!.username] , appKey: nil, handler: { (result, error) in
            if(error == nil){
              self.navigationController?.popViewController(animated: false)
            }else{
                //:hub提示错误信息
                let erro = error! as NSError
                MBProgressHUD_JChat.show(text: erro.localizedDescription, view: self.view)
                printLog("添加管理员失败：\(erro.localizedDescription)")
            }
        })
    }

}
