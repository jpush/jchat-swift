//
//  NSDate+Utilites.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/24.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

let FORMAT_PAST_SHORT:String = "yyyy/MM/dd"
let FORMAT_PAST_TIME:String = "ahh:mm"
let FORMAT_THIS_WEEK:String = "eee ahh:mm"
let FORMAT_THIS_WEEK_SHORT:String = "eee"
let FORMAT_YESTERDAY:String = "ahh:mm"
let FORMAT_TODAY:String = "ahh:mm"

let D_MINUTE = 60.0
let D_HOUR = 3600.0
let D_DAY = 86400.0
let D_WEEK = 604800.0
let D_YEAR = 31556926.0

internal let componentFlags:NSCalendarUnit = [.Year, .Month, .Day, .Weekday, .Hour, .Minute, .Second, .WeekdayOrdinal]

extension NSDate {
  class func currentCalendar() -> NSCalendar{
    let calendar = NSCalendar.autoupdatingCurrentCalendar()
    return calendar
  }

  func isEqualToDateIgnoringTime(date:NSDate) -> Bool{
    let components1:NSDateComponents = NSDate.currentCalendar().components(componentFlags, fromDate: self)
    let components2:NSDateComponents = NSDate.currentCalendar().components(componentFlags, fromDate: date)
    return (components1.year == components2.year) && (components1.month == components2.month) && (components1.date == components2.day)

  }

  func dateByAddingDays(days:Int) -> NSDate {
    let dateComponents = NSDateComponents()
    dateComponents.day = days
    let newDate:NSDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options:NSCalendarOptions(rawValue: 0))!
    return newDate
  }
  
  func dateBySubtractingDays(days:Int) -> NSDate {
     return self.dateByAddingDays(days * -1)
  }
  
  class func dateWithDaysFromNow(days:Int) -> NSDate {
    return NSDate().dateByAddingDays(days)
  }

  class func dateWithDaysBeforeNow(days:Int) -> NSDate {
    return NSDate().dateBySubtractingDays(days)
  }

  class func dateTomorrow() -> NSDate{
    return NSDate.dateWithDaysFromNow(1)
  }
  
  class func dateYesterday() -> NSDate {

    return NSDate.dateWithDaysBeforeNow(1)
  }
  
  func isToday() -> Bool {
    return self.isEqualToDateIgnoringTime(NSDate())
  }

  func isTomorrow() -> Bool {
    return self.isEqualToDateIgnoringTime(NSDate.dateTomorrow())
  }

  func isYesterday() -> Bool {
    return self.isEqualToDateIgnoringTime(NSDate.dateYesterday())
  }

  func isSameWeekAsDate(date:NSDate) -> Bool {
    let components1:NSDateComponents = NSDate.currentCalendar().components(componentFlags, fromDate: self)
    let components2:NSDateComponents = NSDate.currentCalendar().components(componentFlags, fromDate: date)
    if components1.weekOfYear != components2.weekOfYear { return false }
    return (fabs(self.timeIntervalSinceDate(date)) < D_WEEK)
  }
  
  func isThisWeek() -> Bool {
    return self.isSameWeekAsDate(NSDate())
  }
}
