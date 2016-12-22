//
//  JChatLocationManager.swift
//  JChatSwift
//
//  Created by oshumini on 2016/11/20.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MapKit

let locationImageSizeDefault = CGSize(width: 200, height: 100)

protocol JChatLocationDelegate:NSObjectProtocol {
  func currentLocationCallBack(location:CLLocation)//
  func locationImageCallBack(location: CLLocation,image:UIImage?)
}

typealias CompletionBlock = (_ result: UIImage) -> Void


class JChatLocationManager: NSObject {
  var locationManager:CLLocationManager!
  weak var locationDelegate:JChatLocationDelegate!
  var locationImageName:String? = nil
  
  override init() {
    super.init()
  }
  
  init(delegate:JChatLocationDelegate) {
    super.init()
    locationDelegate = delegate
  }
  
  func getCurrentLocation() {
    locationManager = CLLocationManager()
    locationManager.requestAlwaysAuthorization()
    locationManager.delegate = self
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  func getLocationImage(location:CLLocation, size:CGSize) {
    
    
    
    let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan())
    let options = MKMapSnapshotOptions()
    
    options.region = region
    options.size = size
    options.scale = UIScreen.main.scale
    options.showsPointsOfInterest = true
    let mapShoot = MKMapSnapshotter(options: options)
    
    mapShoot.start { (mapshoot, error) in
      
      let image = mapshoot!.image
      let finalImageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      let pin = MKPinAnnotationView()
      
      let pinImage = pin.image
      UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
      image.draw(at: CGPoint(x: 0, y: 0))
      pinImage?.draw(at: CGPoint(x: finalImageRect.size.width/2, y: finalImageRect.size.height/2))
      let finalImage = UIGraphicsGetImageFromCurrentImageContext()
      self.locationDelegate.locationImageCallBack(location: location,image: finalImage)
    }
  }
  
  class func getLocationImage(message:JMSGMessage, size:CGSize, callback: @escaping CompletionBlock) {
    if JChatFileManage.sharedInstance.exitImage(name: "\(message.msgId).png") {
      let locationImg = JChatFileManage.sharedInstance.getImage(name: "\(message.msgId).png")
      callback(locationImg!)
    } else {
      let content = message.content as! JMSGLocationContent
      let location = CLLocation(latitude: CLLocationDegrees(content.latitude), longitude: CLLocationDegrees(content.longitude))
//      JChatLocationManager.getLocationImageCallBack(location: location, size: size, callback: )
      JChatLocationManager.getLocationImageCallBack(location: location, size: size, callback: { (image) in
        JChatFileManage.sharedInstance.writeImage(name: "\(message.msgId).png", image: image)
        callback(image)
      })
    }
  }
  
  class func getLocationImageCallBack(location:CLLocation, size:CGSize, callback:@escaping CompletionBlock) {
    
    let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan())
    
    let options = MKMapSnapshotOptions()
    options.region = region
    options.size = size
    options.scale = UIScreen.main.scale
    options.showsPointsOfInterest = true
    let mapShoot = MKMapSnapshotter(options: options)
    
    mapShoot.start { (mapshoot, error) in
      
      let image = mapshoot!.image
      let finalImageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      let pin = MKPinAnnotationView()
      
      let pinImage = pin.image
      UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
      image.draw(at: CGPoint(x: 0, y: 0))
      pinImage?.draw(at: CGPoint(x: finalImageRect.size.width/2, y: finalImageRect.size.height/2))
      let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//      self.locationDelegate.locationImageCallBack(location: location,image: finalImage)
      
//       writeimage
      if finalImage != nil {
        callback(finalImage!)
      }
      
    }
    
  }
  
}

extension JChatLocationManager: CLLocationManagerDelegate{
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    locationManager.stopUpdatingLocation()
    manager.stopUpdatingLocation()
    manager.delegate = nil;
    let location = locations[0]
    self.locationDelegate.currentLocationCallBack(location: location)
  }
  

}
