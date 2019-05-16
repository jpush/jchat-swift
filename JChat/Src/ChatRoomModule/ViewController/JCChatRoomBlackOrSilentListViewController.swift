//
//  JCChatRoomBlackOrSilentListViewController.swift
//  JChat
//
//  Created by Allan on 2019/4/25.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomBlackOrSilentListViewController: UIViewController {
    open var isBlack: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(netHex: 0xe8edf3)

        if(self.isBlack){
            self.title = "黑名单"
        }else{
            self.title = "禁言列表"
        }
    }
    

}
