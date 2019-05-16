//
//  JCConstants.swift
//  JChat
//
//  Created by JIGUANG on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import Foundation

let kCurrentUserName = "kJCCurrentUserName"
let kCurrentUserPassword = "kCurrentUserPassword"
let kUpdateUserInfo = "kUpdateUserInfo"
let kUpdateConversation = "kUpdateConversation"
let kUpdateFriendInfo = "kUpdateFriendInfo"
let kUpdateGroupInfo = "kUpdateGroupInfo"
let kLastUserName = "kLastUserName"
let kLastUserAvator = "kLastUserAvator"
let kUpdateFriendList = "kUpdateFriendList"
let kUpdateVerification = "kUpdateVerification"
let kDeleteAllMessage = "kDeleteAllMessage"
let kReloadAllMessage = "kReloadAllMessage"
let kUnreadInvitationCount = "kUnreadInvitationCount"
let kUpdateFileMessage = "kUpdateFileMessage"


extension UIDevice {
    func isAboveiPhoneX() ->Bool {
        let screenHeight = UIScreen.main.nativeBounds.size.height;
        if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
            return true
        }
        return false
    }
}
