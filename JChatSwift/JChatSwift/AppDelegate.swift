//
//  AppDelegate.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/15.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

let JMSSAGE_APPKEY = "4f7aef34fb361292c566a1cd"
let CHANNEL = ""

let kuserName = "userName"
let klastLoginUserName = "lastLoginedUserName"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

//    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: kuserName)
//    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: klastLoginUserName)
//    return true
    
    JMessage.setupJMessage(launchOptions, appKey: JMSSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
    if #available(iOS 8, *) {
      // 可以自定义 categories
      JPUSHService.registerForRemoteNotificationTypes(
        UIUserNotificationType.Badge.rawValue |
        UIUserNotificationType.Badge.rawValue |
        UIUserNotificationType.Alert.rawValue,
        categories: nil)
    } else {
      JPUSHService.registerForRemoteNotificationTypes(
        UIUserNotificationType.Badge.rawValue |
        UIUserNotificationType.Badge.rawValue |
        UIUserNotificationType.Alert.rawValue,
        categories: nil)
    }

    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.setupRootView()
    self.window?.makeKeyAndVisible()
    return true
  }
  
  func setupRootView() {
    if NSUserDefaults.standardUserDefaults().objectForKey(kuserName) != nil {
      self.window?.rootViewController = JChatMainTabViewController.sharedInstance
    } else {
      if NSUserDefaults.standardUserDefaults().objectForKey(klastLoginUserName) != nil {
        let rootVC = JChatAlreadyLoginViewController()
        let rootNV = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNV
      } else {
        let rootVC = JChatLoginViewController()
        let rootNV = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNV
      }
    }
    
    UINavigationBar.appearance().barTintColor = UIColor(netHex: 0x3f80de)
    if Float(UIDevice.currentDevice().systemVersion) >= 8.0 {
      UINavigationBar.appearance().translucent = false
    }
    
    let shadow = NSShadow()
    UINavigationBar.appearance().titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.whiteColor(),
      NSFontAttributeName: UIFont.boldSystemFontOfSize(20),
      NSShadowAttributeName: shadow
    ]
  }
  
//  - (void)registerJPushStatusNotification {
//  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//  [defaultCenter addObserver:self
//  selector:@selector(networkDidSetup:)
//  name:kJPFNetworkDidSetupNotification
//  object:nil];
//  [defaultCenter addObserver:self
//  selector:@selector(networkIsConnecting:)
//  name:kJPFNetworkIsConnectingNotification
//  object:nil];
//  [defaultCenter addObserver:self
//  selector:@selector(networkDidClose:)
//  name:kJPFNetworkDidCloseNotification
//  object:nil];
//  [defaultCenter addObserver:self
//  selector:@selector(networkDidRegister:)
//  name:kJPFNetworkDidRegisterNotification
//  object:nil];
//  [defaultCenter addObserver:self
//  selector:@selector(networkDidLogin:)
//  name:kJPFNetworkDidLoginNotification
//  object:nil];
//  
//  [defaultCenter addObserver:self
//  selector:@selector(receivePushMessage:)
//  name:kJPFNetworkDidReceiveMessageNotification
//  object:nil];
//  
//  }
  func registerJPushStatusNotification() {
    let defaultCenter = NSNotificationCenter.defaultCenter()
    defaultCenter.addObserver(self, selector: Selector(""), name: kJPFNetworkDidSetupNotification, object: nil)
    defaultCenter.addObserver(self, selector: Selector(""), name: kJPFNetworkIsConnectingNotification, object: nil)
    defaultCenter.addObserver(self, selector: Selector(""), name: kJPFNetworkDidCloseNotification, object: nil)
    defaultCenter.addObserver(self, selector: Selector(""), name: kJPFNetworkDidRegisterNotification, object: nil)
    defaultCenter.addObserver(self, selector: Selector(""), name: kJPFNetworkDidLoginNotification, object: nil)
    defaultCenter.addObserver(self, selector: Selector(""), name: kJPFNetworkDidReceiveMessageNotification, object: nil)
  }
  
  // notification from JPush
  func networkDidSetup(notification:NSNotification) {
    print("Action - networkDidSetup")
  }
  
  // notification from JPush
  func networkIsConnecting(notification:NSNotification) {
    print("Action - networkIsConnecting")
  }
  
  // notification from JPush
  func networkDidClose(notification:NSNotification) {
    print("Action - networkDidClose")
  }
  
  // notification from JPush
  func networkDidRegister(notification:NSNotification) {
    print("Action - networkDidRegister")
  }
  
  // notification from JPush
  func networkDidLogin(notification:NSNotification) {
    print("Action - networkDidLogin")
  }
  // notification from JPush

  func receivePushMessage(notification:NSNotification) {
    print("Action - receivePushMessage")
  }
  
  
  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
  }

  func applicationWillEnterForeground(application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    application.cancelAllLocalNotifications()
  }

  func applicationDidBecomeActive(application: UIApplication) {
  }

  func applicationWillTerminate(application: UIApplication) {
  }


}

