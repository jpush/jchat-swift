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
  var friendsDic = NSMutableDictionary()
  var friendsLetterArr = NSMutableArray()
  var allFriendArr:NSArray!
  
//  var filterArr = NSMutableArray()
  
  func setupData(_ friends:NSArray) {
    NSLog("start")
    self.allFriendArr = friends
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
      print(fristChart)
      
    }
    
    var lettersArr:[String] = self.friendsDic.allKeys as! Array

    lettersArr = lettersArr.sorted(by: {$0 < $1})
    self.friendsLetterArr.add("{search}")
    self.friendsLetterArr.addObjects(from: lettersArr)
//    self.friendsLetterArr = (lettersArr as NSArray?)
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
  
  open func filterFriends(with string:String) -> [JMSGUser] {

    let arrArr = self.allFriendArr
    if arrArr == nil {
      return []
    }
    let inputStringPinyin = (self.convertToPinyin(string: string as NSString) as! String)
    let upInputString = inputStringPinyin.uppercased()
    let filterArr = arrArr?.filter { (friend) -> Bool in
      let namePinyin = self.getPinYinName(user: friend as! JMSGUser)
      return namePinyin.contains(upInputString)
      
    }
    return filterArr as! [JMSGUser]
  }
}
