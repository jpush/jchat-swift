//
//  JChatLocationManager.swift
//  JChatSwift
//
//  Created by oshumini on 2016/11/20.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MapKit

protocol JChatLocationDelegate:NSObjectProtocol {
  func currentLocationCallBack(location:CLLocation)//
  func locationImageCallBack(location: CLLocation,image:UIImage?)
}

class JChatLocationManager: NSObject {
  var locationManager:CLLocationManager!
  weak var locationDelegate:JChatLocationDelegate!
  var locationImageName:String? = nil
  
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
}

extension JChatLocationManager: CLLocationManagerDelegate{
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    
    let location = locations[0]
    self.locationDelegate.currentLocationCallBack(location: location)
  }
  

}
