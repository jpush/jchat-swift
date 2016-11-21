//
//  JChatFileManage.swift
//  JChatSwift
//
//  Created by oshumini on 2016/11/21.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import Foundation

class JChatFileManage: NSObject {

  var documentPath:String
  var mapImagePath:String
  var fileMng:FileManager!
  
  static let sharedInstance = JChatFileManage()
  
  override init() {
    documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    print("the document path \(documentPath)")
    mapImagePath = documentPath.appending("/mapImage/")
    print("thr mapimagepath \(mapImagePath)")
    
    fileMng = FileManager.default
    
    if fileMng.fileExists(atPath: mapImagePath) != true {
      do {
        try fileMng.createDirectory(at: NSURL(fileURLWithPath:mapImagePath) as URL, withIntermediateDirectories: false, attributes: nil)
        
      } catch {
        print("create director fail")
      }
      
    }
    super.init()

  }
  
  func writeImage(name:String, image:UIImage) {
    let imagePath = mapImagePath.appending(name)
    
    if self.exitImage(name: name) {
      return
    }
    
    let url = NSURL(fileURLWithPath: imagePath)
    do {
      try UIImagePNGRepresentation(image)?.write(to: url as URL)
    } catch {
      print("write image fail")
    }
  }
  
  func exitImage(name:String) -> Bool {
    let imagePathString = self.mapImagePath.appending(name)
    let imagePath = NSURL(fileURLWithPath: imagePathString)
    print("\(imagePath.path!)")
    if self.fileMng.fileExists(atPath: imagePath.path!) {
      return true
    } else {
      return false
    }
  }
  
  func getImage(name:String) -> UIImage? {
    if self.exitImage(name: name) {
      let path = mapImagePath.appending(name)
      let url = NSURL(fileURLWithPath: path)
      print("\(mapImagePath)")
//      let imgData = NSData(contentsOf: url as URL)
//      let img = UIImage(data: imgData as! Data)
      let img = UIImage.init(contentsOfFile: path)
      return img
    } else {
      return nil
    }
  }
  
}
