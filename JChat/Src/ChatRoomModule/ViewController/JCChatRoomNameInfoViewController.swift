//
//  JCChatRoomNameInfoViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/25.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomNameInfoViewController: UIViewController {
    @IBOutlet weak var nameInfo: UITextView!
    
    open var roomName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "聊天室名称"
        self.nameInfo.text = self.roomName
        view.backgroundColor = UIColor(netHex: 0xe8edf3)

    }
    
}
