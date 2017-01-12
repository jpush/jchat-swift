//
//  JChatContatctsDataSource.swift
//  JChatSwift
//
//  Created by oshumini on 2016/12/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
//import PinYin4Objc

class JChatContatctsDataSource: NSObject {
  
  static var sharedInstance = JChatContatctsDataSource()
  
  var friendsDic = NSMutableDictionary() //  Dictionary< Arr<JChatFriendModel> >
  var friendsLetterArr = NSMutableArray()
  var allFriendArr:NSMutableArray!
  var selectedContact = NSMutableArray()
  
  
  override init() {
    super.init()
    
    JChatDataBaseManager.sharedInstance.setupTable(username: JMSGUser.myInfo().username)
    let usernameArr = JChatDataBaseManager.sharedInstance.selectAllContact(currentUser: JMSGUser.myInfo().username)
    
    let queue = DispatchQueue(label: "com.jiguang.jchat")
    
    if usernameArr.count == 0 {
      JMSGFriendManager.getFriendList { (friendList, error) in
        if error == nil {
          queue.async {
            JChatContatctsDataSource.sharedInstance.setupData(friendList as! NSArray)
            JChatDataBaseManager.sharedInstance.addContactList(currentUser: JMSGUser.myInfo().username, contactUsernameArr: friendList as! Array<JMSGUser>)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kContactDataReadyNotification), object: nil)
          }
        }
      }
    } else {
      JMSGUser.userInfoArray(withUsernameArray: usernameArr, completionHandler: { (contactArr, error) in
        if error != nil { return }
        queue.async {
          JChatContatctsDataSource.sharedInstance.setupData(contactArr as! NSArray)
          NotificationCenter.default.post(name: Notification.Name(rawValue: kContactDataReadyNotification), object: nil)
        }
      })
    }
    
    
  }
  
  func changeAccount() {
    JChatContatctsDataSource.sharedInstance = JChatContatctsDataSource()
  }
  
  func setupData(_ friends:NSArray) {
    NSLog("start")
    self.allFriendArr = NSMutableArray(array: friends)
    
    for friend in friends as! [JMSGUser] {
      let friendModel = JChatFriendModel()
      friendModel.setData(friend)
      var pinyinName = self.getPinYinName(user: friend)
      pinyinName = pinyinName.uppercased as NSString
      let fristChart = pinyinName.character(at: 1)
      
      // 大写字母
      if ((fristChart > 64) && (fristChart < 91)) {
        let nameLetter = pinyinName.substring(to: 1)
        if self.friendsDic[nameLetter] != nil {
          let letterArr = self.friendsDic[nameLetter] as! NSMutableArray
          letterArr.add(friendModel)
        } else {
          let letterArr = NSMutableArray()
          self.friendsDic[nameLetter] = letterArr
          letterArr.add(friendModel)
        }
      } else {
        if self.friendsDic["#"] != nil {
          let letterArr = self.friendsDic["#"] as! NSMutableArray
          letterArr.add(friendModel)
        } else {
          self.friendsDic["#"] = NSMutableArray()
        }
      }
//      let fristChart = pinyinName.substring(to:1)
//      let bytes = fristChart.characterAt
//      self.friendsArr.add(friendModel)
      
    }
    
    var lettersArr:[String] = self.friendsDic.allKeys as! Array

    lettersArr = lettersArr.sorted(by: {$0 < $1})
    self.friendsLetterArr.add("{search}")
    self.friendsLetterArr.addObjects(from: lettersArr)
  }
  
  func resetSelected() {
    for selectedFriend in self.selectedContact {
      (selectedFriend as! JChatFriendModel).isSelected = false
    }
    self.selectedContact.removeAllObjects()
  }
  
  func addSelectedUser(with username: JChatFriendModel!) {
    self.selectedContact.add(username)
  }
  
  func removeSelectedUser(with username: JChatFriendModel!) {
    self.selectedContact.remove(username)
  }
  
  func seletedCount() -> Int {
    return self.selectedContact.count
  }
  
  func getPinYinName(user:JMSGUser) -> NSString {
    let pinyinString = self.convertToPinyin(string: user.displayName() as NSString)
    return pinyinString!
  }
  
  func convertToPinyin(string:NSString) -> NSString? {
// TODO : 使用拼音库无法转换，暂缓
    //    let outputFormat = HanyuPinyinOutputFormat()
//    outputFormat?.toneType = ToneTypeWithoutTone
//    outputFormat?.vCharType = VCharTypeWithV
//    outputFormat?.caseType = CaseTypeLowercase
//    let outputString = PinyinHelper.toHanyuPinyinString(with: string as String!, with:outputFormat, with:"")
//    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    let outputString = NSMutableString(string: string)
    CFStringTransform(outputString, nil, kCFStringTransformMandarinLatin, false)
    CFStringTransform(outputString, nil, kCFStringTransformStripDiacritics, false)
    print("\(outputString)")
    return outputString as NSString?
  }
  
  open func filterFriends(with string:String, callBack:@escaping CompletionBlock) {

    let arrArr = self.allFriendArr
    if arrArr == nil {
      DispatchQueue.main.async {
        callBack([])
      }
      
    }
    let queue = DispatchQueue(label: "com.jiguang.jchat")
    
    queue.async {
      let inputStringPinyin = (self.convertToPinyin(string: string as NSString) as! String)
      let upInputString = inputStringPinyin.uppercased()
      let filterArr = arrArr?.filter { (friend) -> Bool in
        var namePinyin = self.getPinYinName(user: friend as! JMSGUser)
        namePinyin = namePinyin.uppercased as NSString
        return namePinyin.contains(upInputString)
      }
      DispatchQueue.main.async {
        callBack(filterArr as! [JMSGUser])
      }
      
    }

  }
  
  open func addUser(with username:String) {
    self.allFriendArr.add(username)
    JMSGUser.userInfoArray(withUsernameArray: [username], completionHandler: { (userArr, error) in
      if error != nil {
        return
      }
      
      let user = (userArr as! NSArray)[0] as! JMSGUser
      let userModel = JChatFriendModel()
      userModel.setData(user)
      
      var pinyinName = self.convertToPinyin(string: username as NSString)
      pinyinName = pinyinName?.uppercased as! NSString
      let fristChart = pinyinName!.character(at: 1)
      
      // 大写字母
      var nameLetter = ""
      if ((fristChart > 64) && (fristChart < 91)) {
        nameLetter = (pinyinName?.substring(to: 1))!
      } else {
        nameLetter = "#"
      }
      
      var letterArr = self.friendsDic[nameLetter] as? NSMutableArray
      
      if letterArr == nil {
        letterArr = NSMutableArray()
        self.friendsDic[nameLetter] = letterArr
      }
      
      letterArr?.add(userModel)
    })
  }
  
  open func deleteUser(with username:String) {
    self.allFriendArr.remove(username)
    
    var pinyinName = self.convertToPinyin(string: username as NSString)
    pinyinName = pinyinName?.uppercased as! NSString
    let nameLetter = pinyinName?.substring(to: 1)
    let letterArr = self.friendsDic[nameLetter] as! NSMutableArray
    for userModel in letterArr {
      if (userModel as! JChatFriendModel).user?.username == username {
        letterArr.remove(userModel)
      }
    }
  }
  
  func usernameArr(with userArr:[JChatFriendModel]) -> [String] {
    let usernameArr = NSMutableArray()
    for user in userArr {
      usernameArr.add(user.user?.username)
    }
    return usernameArr as NSArray as! [String]
  }
}
