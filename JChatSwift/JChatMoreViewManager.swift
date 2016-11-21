//
//  JChatMoreViewManager.swift
//  JChatSwift
//
//  Created by oshumini on 2016/11/20.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

public enum JChatMoreItemType : Int {
  // 相机
  case camera
  // 相册
  case photo
  // 位置
  case location
}

protocol JChatMoreViewDelegate:NSObjectProtocol {
  
  func photoClick()
  
  func locationClick()
  
  func cameraClick()
}

private var CellIdentifier = ""

class JChatMoreViewManager: NSObject {
  
  weak var moreviewGrip:UICollectionView!
  weak var moreViewdelegate:JChatMoreViewDelegate!
  
  var moreItemArr:Array<JChatMoreItemType>!
  
  init(moreView: UICollectionView!, delegate:JChatMoreViewDelegate!) {
    super.init()
    moreViewdelegate = delegate
    moreItemArr = [.camera, .photo, .location]
    moreviewGrip = moreView
    moreviewGrip.delegate = self
    moreviewGrip.dataSource = self
    moreviewGrip.register(
      UINib(nibName: "JChatMoreInputCell", bundle: nil),
      forCellWithReuseIdentifier: "JChatMoreInputCell")
    
  }
}

extension JChatMoreViewManager: UICollectionViewDelegate,UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return self.moreItemArr.count;
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    return CGSize(width: 60, height: 80)
  }
  
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      referenceSizeForFooterInSection section: Int) -> CGSize {
//    return CGSize(width: UIScreen.main.bounds.size.width, height: 200)
//  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    CellIdentifier = "JChatMoreInputCell"
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! JChatMoreInputCell
    cell.setup(type: self.moreItemArr[indexPath.item], delegate: self.moreViewdelegate)
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {

    
  }
  

}
