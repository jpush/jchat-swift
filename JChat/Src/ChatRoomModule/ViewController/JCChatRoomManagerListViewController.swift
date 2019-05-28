//
//  JCChatRoomManagerListViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/25.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomManagerListViewController: UIViewController {
    open var chatRoom: JMSGChatRoom?
    open var isOwner: Bool?
    var tableView: UITableView!
    var dataArray: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理员"
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        self.dataArray = NSMutableArray.init()
        if(self.isOwner == true){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "添加", style: UIBarButtonItem.Style.plain, target: self, action: #selector(managerClick))
        }
        self.tableView = UITableView.init()
        self.view.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make) in
            make?.right.left()?.bottom().equalTo()(self.view)
            if #available(iOS 11.0, *) {
                make?.top.equalTo()(self.view.mas_safeAreaLayoutGuideTop)
            } else {
                make?.top.equalTo()
            }
        }
        self.tableView.delegate = self as UITableViewDelegate
        self.tableView.dataSource = self as UITableViewDataSource
        self.tableView.register(JCChatRoomManagerListCell.self, forCellReuseIdentifier: "managerList")
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.requestData()
    }
    
    func requestData()  {
        self.chatRoom?.chatRoomAdminList({ (result, error) in
            if let managers = result as? [JMSGUser]{
                DispatchQueue.main.async {
                    self.dataArray?.removeAllObjects()
                    self.dataArray?.addObjects(from: managers)
                    if(self.dataArray?.count == 0 ){
                        MBProgressHUD_JChat.show(text: "未设置管理员", view: self.view)
                    }else{
                        self.tableView.reloadData()
                    }
                }
            }
            if (error != nil) {
                let err = error! as NSError
                MBProgressHUD_JChat.show(text: err.localizedDescription, view: self.view)
            }
        })
    }
    
    @objc func managerClick(){
        let vc = JCChatRoomAddManagerViewController.init()
        vc.chatRoom = self.chatRoom
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteClick(deletBtn:UIButton) {
        let user = self.dataArray?[deletBtn.tag] as! JMSGUser
        self.chatRoom?.deleteAdmin(withUsernames: [user.username], appKey: nil, handler: { (result, error) in
            if error == nil{
                self.dataArray?.remove(user)
                self.tableView.reloadData()
            }else{
                let erro = error! as NSError
                MBProgressHUD_JChat.show(text: erro.localizedDescription, view: self.view)
                printLog("移除失败：\(erro.description)")
            }
        })
    }

}

extension JCChatRoomManagerListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerList", for: indexPath)
        if let userCell = cell as? JCChatRoomManagerListCell {
            let user = self.dataArray?[indexPath.row]
            userCell.bindDate(user! as! JMSGUser)
            if self.isOwner != true {
                userCell.deletBtn.isHidden = true
            }else{
                userCell.deletBtn.tag = indexPath.row
                userCell.deletBtn.addTarget(self, action: #selector(self.deleteClick(deletBtn:)), for:.touchUpInside)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = JCUserInfoViewController()
        let user = self.dataArray![indexPath.row]
        vc.user = user as? JMSGUser
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
