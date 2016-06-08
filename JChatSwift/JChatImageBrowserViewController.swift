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
  var imgCurrentIndex:Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.blackColor()
    self.setupImageBrowser()
  }

  override func viewDidLayoutSubviews() {
    self.imageBrowser.scrollToItemAtIndexPath(NSIndexPath(forItem: imgCurrentIndex, inSection: 0), atScrollPosition: .Left, animated: false)
  }
  
  func setupImageBrowser() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .Horizontal
    flowLayout.minimumLineSpacing = 0
    self.imageBrowser = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
    self.view.addSubview(self.imageBrowser)
    self.imageBrowser.snp_makeConstraints { (make) in
      make.right.left.top.bottom.equalTo(self.view)
    }
    
    self.imageBrowser.backgroundColor = UIColor.clearColor()
    self.imageBrowser.delegate = self
    self.imageBrowser.dataSource = self
    self.imageBrowser.minimumZoomScale = 0
    self.imageBrowser.pagingEnabled = true
    self.imageBrowser.registerNib(UINib(nibName: "JChatMessageImageCollectionViewCell", bundle: nil),
                                  forCellWithReuseIdentifier: "JChatMessageImageCollectionViewCell")
    
    self.addGestureToImageBrowser()
  }
  
  private func addGestureToImageBrowser() {
    let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.singleTapImage(_:)))
    singleTapGesture.delegate = self
    singleTapGesture.numberOfTapsRequired = 1
    self.imageBrowser.addGestureRecognizer(singleTapGesture)
    
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapImage(_:)))
    doubleTapGesture.delegate = self
    doubleTapGesture.numberOfTapsRequired = 2
    self.imageBrowser.addGestureRecognizer(doubleTapGesture)
    
    singleTapGesture.requireGestureRecognizerToFail(doubleTapGesture)
  }
  
  func singleTapImage(gestureRecognizer:UITapGestureRecognizer)  {
    print("\(gestureRecognizer)")
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func doubleTapImage(gestureRecognizer:UITapGestureRecognizer) {
    print("double tap image")
    let cell = imageBrowser.cellForItemAtIndexPath(self.currentIndex()) as! JChatMessageImageCollectionViewCell
    cell.adjustImageScale()
  }
  

  private func currentIndex() -> NSIndexPath {
    let itemIndex:Int = Int(imageBrowser.contentOffset.x / imageBrowser.frame.size.width)
    return NSIndexPath(forItem: itemIndex, inSection: 0)
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
    print("\(UIScreen.mainScreen().bounds.size)")
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

extension JChatImageBrowserViewController:UIGestureRecognizerDelegate {

}
