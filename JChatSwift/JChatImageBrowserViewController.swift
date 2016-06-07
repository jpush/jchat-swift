//
//  JChatImageBrowserViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/6/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

private var CellIdentifier = ""

class JChatImageBrowserViewController: UIViewController {
  
  private var imageBrowser:UICollectionView!
  var imageArr:NSArray!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.blueColor()
    self.setupImageBrowser()
    
  }

  func setupImageBrowser() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .Horizontal
    
    self.imageBrowser = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
    self.view.addSubview(self.imageBrowser)
    self.imageBrowser.snp_makeConstraints { (make) in
      make.right.left.top.bottom.equalTo(self.view)
    }
    
    self.imageBrowser.backgroundColor = UIColor.clearColor()
    self.imageBrowser.delegate = self
    self.imageBrowser.dataSource = self
    self.imageBrowser.minimumZoomScale = 0
    
    self.imageBrowser.registerNib(UINib(nibName: "JChatMessageImageCollectionViewCell", bundle: nil),
                                  forCellWithReuseIdentifier: "JChatMessageImageCollectionViewCell")
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
}

extension JChatImageBrowserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageArr.count;
    
  }
  
  func collectionView(collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
  }
  

  func collectionView(collectionView: UICollectionView,
                      cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    CellIdentifier = "JChatMessageImageCollectionViewCell"
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("JChatMessageImageCollectionViewCell", forIndexPath: indexPath) as! JChatMessageImageCollectionViewCell
    cell.setImage(imageArr[indexPath.row] as! JChatMessageModel)
    return cell
  }
}
