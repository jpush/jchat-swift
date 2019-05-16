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
    override func viewDidLoad() {
        self.addChatRoomManger = true
        super.viewDidLoad()
        self.title = "添加管理员"
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        addButton.setTitle("添加", for: .normal)
        addButton.addTarget(self, action: #selector(_addRoomManager), for: .touchUpInside)
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
