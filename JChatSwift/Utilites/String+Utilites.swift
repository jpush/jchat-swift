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
      let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
      let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound)
      
      return self[(startIndex ..< endIndex)]
    }
  }
  
  var utf8Array: [UInt8] {
    return Array(utf8)
  }
}
