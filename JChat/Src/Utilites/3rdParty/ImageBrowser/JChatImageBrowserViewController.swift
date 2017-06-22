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
  
  fileprivate var imageBrowser: UICollectionView!
  var imageArr:NSArray!
  var imgCurrentIndex:Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black
    self.setupImageBrowser()
  }

  override func viewDidLayoutSubviews() {
    self.imageBrowser.scrollToItem(at: IndexPath(item: imgCurrentIndex, section: 0), at: .left, animated: false)
  }
  
  func setupImageBrowser() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 0
    self.imageBrowser = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    self.view.addSubview(self.imageBrowser)
    self.imageBrowser.frame = self.view.frame
    
    self.imageBrowser.backgroundColor = UIColor.clear
    self.imageBrowser.delegate = self
    self.imageBrowser.dataSource = self
    self.imageBrowser.minimumZoomScale = 0
    self.imageBrowser.isPagingEnabled = true
    self.imageBrowser.register(UINib(nibName: "JChatMessageImageCollectionViewCell", bundle: nil),
                                  forCellWithReuseIdentifier: "JChatMessageImageCollectionViewCell")
  }
  
  func singleTapImage(_ gestureRecognizer:UITapGestureRecognizer)  {
    self.dismiss(animated: true, completion: nil)
  }
  
  func doubleTapImage(_ gestureRecognizer:UITapGestureRecognizer) {
    let cell = imageBrowser.cellForItem(at: self.currentIndex()) as! JChatMessageImageCollectionViewCell
    cell.adjustImageScale()
  }
  

  fileprivate func currentIndex() -> IndexPath {
    let itemIndex:Int = Int(imageBrowser.contentOffset.x / imageBrowser.frame.size.width)
    return IndexPath(item: itemIndex, section: 0)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension JChatImageBrowserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageArr.count;
    
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    print("\(UIScreen.main.bounds.size)")
    return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
  }
  

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    CellIdentifier = "JChatMessageImageCollectionViewCell"
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JChatMessageImageCollectionViewCell", for: indexPath) as! JChatMessageImageCollectionViewCell
    cell.setImage(image: imageArr[indexPath.row] as! UIImage)
    cell.delegate = self
    return cell
  }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension JChatImageBrowserViewController: JCImageBrowserCellDelegate {
    func singleTap() {
        self.dismiss(animated: true, completion: nil)
    }
}
