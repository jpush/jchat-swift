//
//  JCSetChatRoomOwnerViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/25.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomChangeOwnerViewController: JCSearchFriendViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置房主"
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        addButton.setTitle("设置房主", for: .normal)
        addButton.addTarget(self, action: #selector(_setRoomOwner), for: .touchUpInside)
    
    }
    
    @objc func _setRoomOwner(){
        
    }
}
