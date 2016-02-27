//
//  NSString+Utilites.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/25.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

extension NSString {
  class func getTodayYesterdayString(theDate:NSDate) -> String {
    let formatter = NSDateFormatter()
    let locale:NSLocale = NSLocale(localeIdentifier: "zh")
    formatter.locale = locale
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .NoStyle
    formatter.doesRelativeDateFormatting = true
    return formatter.stringFromDate(theDate)
  }
  
  class func getPastDateString(theDate:NSDate) -> String {
    let formatter = NSDateFormatter()
    let locale:NSLocale = NSLocale(localeIdentifier: "zh")
    formatter.locale = locale
    formatter.dateStyle = .LongStyle
    formatter.timeStyle = .NoStyle
    formatter.doesRelativeDateFormatting = true
    return formatter.stringFromDate(theDate)
  }

  class func getFriendlyDateString(timeInterval:NSTimeInterval, forConversation isShort:Bool) -> String {
    let theDate:NSDate = NSDate(timeIntervalSince1970: timeInterval)
    var output = ""
    let theDiff = theDate.timeIntervalSinceNow
    switch theDiff {
    case theDiff where theDiff < 60.0:
      output = "刚刚"
      break
    case theDiff where theDiff < 60 * 60:
      let minute:Int = Int(theDiff/60)
      output = "\(minute)分钟前"
      break
    default:
      let formatter:NSDateFormatter = NSDateFormatter()
      let locale:NSLocale = NSLocale(localeIdentifier: "zh")
      formatter.locale = locale
      var isTodayYesterday = false
      var isPastLong = false
      
      if theDate.isToday() {
        formatter.dateFormat = FORMAT_TODAY
      } else if theDate.isYesterday() {
        formatter.dateFormat = FORMAT_YESTERDAY
        isTodayYesterday = true
      } else if theDate.isThisWeek() {
        if isShort {
          formatter.dateFormat = FORMAT_THIS_WEEK_SHORT
        } else {
          formatter.dateFormat = FORMAT_THIS_WEEK
        }
      } else {
        if isShort {
          formatter.dateFormat = FORMAT_PAST_SHORT
        } else {
          formatter.dateFormat = FORMAT_PAST_TIME
          isPastLong = true
        }
      }
      
      if isTodayYesterday {
        let todayYesterday = NSString.getTodayYesterdayString(theDate)
        if isShort {
          output = todayYesterday
        } else {
          output = formatter.stringFromDate(theDate)
          output = "\(todayYesterday) \(output)"
        }
      } else {
        output = formatter.stringFromDate(theDate)
        if isPastLong {
          let thePastDate = NSString.getPastDateString(theDate)
          output = "\(thePastDate) \(output)"
        }
      }
      
      break
    }
    return output
  }
  
  class func conversationIdWithConversation(conversation:JMSGConversation) -> String {
    var conversationId = ""
    if conversation.conversationType == .Single {
      let user = conversation.target as! JMSGUser
      conversationId = "\(user.username)_0"
    } else {
      let group = conversation.target as! JMSGGroup
      conversationId = "\(group.gid)_1"
    }
    return conversationId
  }
}
