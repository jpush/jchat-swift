//
//  String+Utilites.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/2.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import Foundation

extension String {
  subscript (r: Range<Int>) -> String {
    get {
      let startIndex = self.startIndex.advancedBy(r.startIndex)
      let endIndex = self.startIndex.advancedBy(r.endIndex)
      
      return self[Range(start: startIndex, end: endIndex)]
    }
  }
  
  var utf8Array: [UInt8] {
    return Array(utf8)
  }
}