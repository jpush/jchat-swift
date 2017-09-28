//
//  JCGroupListViewController.swift
//  JChat
//
//  Created by deng on 2017/3/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCGroupListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }

    var groupList: [JMSGGroup] = []
    private lazy var defaultImage: UIImage = UIImage.loadImage("com_icon_group_36")
    
    // MARK: - private func
    private func _init() {
        self.title = "群组"
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(JCTableViewCell.self, forCellReuseIdentifier: "JCGroupListCell")
        _getGroupList()
    }
    
    private func _getGroupList() {
        MBProgressHUD_JChat.showMessage(message: "加载中...", toView: tableView)
        JMSGGroup.myGroupArray { (result, error) in
            if error == nil {
                self.groupList.removeAll()
                let gids = result as! [NSNumber]
                if gids.count == 0 {
                    MBProgressHUD_JChat.hide(forView: self.tableView, animated: true)
                    return
                }
                for gid in gids {
                    JMSGGroup.groupInfo(withGroupId: "\(gid)", completionHandler: { (result, error) in
                        guard let group = result as? JMSGGroup else {
                            return
                        } 
                        self.groupList.append(group)
                        if self.groupList.count == gids.count {
                            MBProgressHUD_JChat.hide(forView: self.tableView, animated: true)
                            self.groupList = self.groupList.sorted(by: { (g1, g2) -> Bool in
                                return g1.displayName().firstCharacter() < g2.displayName().firstCharacter()
                            })
                            self.tableView.reloadData()
                        }
                    })
                }
            } else {
                MBProgressHUD_JChat.hide(forView: self.tableView, animated: true)
                MBProgressHUD_JChat.show(text: "加载失败", view: self.view)
            }
        }
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "JCGroupListCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let group = groupList[indexPath.row]
        cell.textLabel?.text = group.displayName()
        cell.imageView?.image = defaultImage
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let group = groupList[indexPath.row]
        JMSGConversation.createGroupConversation(withGroupId: group.gid) { (result, error) in
            if let conv = result as? JMSGConversation {
                let vc = JCChatViewController(conversation: conv)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateConversation), object: nil, userInfo: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
