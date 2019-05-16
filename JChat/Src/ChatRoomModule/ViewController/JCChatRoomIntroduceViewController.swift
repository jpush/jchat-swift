//
//  JCChatRoomIntroduceViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/25.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomIntroduceViewController: UIViewController {
    
    open var introduceText: String?
    @IBOutlet weak var introduceInfo: UITextView!
    open var roomIntroduceInfo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "聊天室介绍"
        self.introduceInfo.text = self.introduceText
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
    }


}
