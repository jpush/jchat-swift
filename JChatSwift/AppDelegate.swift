//
//  AppDelegate.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/15.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
//import PinYin4Objc

let JMSSAGE_APPKEY = "4f7aef34fb361292c566a1cd"
let CHANNEL = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    JMessage.add(self, with: nil)
    
    JMessage.setupJMessage(launchOptions, appKey: JMSSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
    if #available(iOS 8, *) {
      // 可以自定义 categories
      JPUSHService.register(
        forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
        UIUserNotificationType.sound.rawValue |
        UIUserNotificationType.alert.rawValue,
        categories: nil)
    } else {
      // ios 8 以前 categories 必须为nil
      JPUSHService.register(
        forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
        UIRemoteNotificationType.sound.rawValue |
        UIRemoteNotificationType.alert.rawValue,
        categories: nil)
    }
    self.registerJPushStatusNotification()
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.setupRootView()
    self.window?.makeKeyAndVisible()
    print("info \(JMSGUser.myInfo().username))")
    return true
  }
  
  func setupRootView() {
    if UserDefaults.standard.object(forKey: kuserName) != nil {
      self.window?.rootViewController = JChatMainTabViewController.sharedInstance
    } else {
      if UserDefaults.standard.object(forKey: klastLoginUserName) != nil {
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
    
    UINavigationBar.appearance().isTranslucent = false  //TODO: ios8
  
    let shadow = NSShadow()
    UINavigationBar.appearance().titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20),
      NSShadowAttributeName: shadow
    ]

    UINavigationBar.appearance().tintColor = UIColor.white
    
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    JPUSHService.registerDeviceToken(deviceToken)
  }
  
  func registerJPushStatusNotification() {
    let defaultCenter = NotificationCenter.default
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidSetup(_:)), name: NSNotification.Name.jmsgNetworkDidSetup, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkIsConnecting(_:)), name: NSNotification.Name.jpfNetworkIsConnecting, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidClose(_:)), name: NSNotification.Name.jmsgNetworkDidClose, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidRegister(_:)), name: NSNotification.Name.jmsgNetworkDidRegister, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidLogin(_:)), name: NSNotification.Name.jmsgNetworkDidLogin, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.receivePushMessage(_:)), name: NSNotification.Name.jmsgNetworkDidReceiveMessage, object: nil)
  }
  
  // notification from JPush
  func networkDidSetup(_ notification:Notification) {
    print("Action - networkDidSetup")
  }
  
  // notification from JPush
  func networkIsConnecting(_ notification:Notification) {
    print("Action - networkIsConnecting")
  }
  
  // notification from JPush
  func networkDidClose(_ notification:Notification) {
    print("Action - networkDidClose")
  }
  
  // notification from JPush
  func networkDidRegister(_ notification:Notification) {
    print("Action - networkDidRegister")
  }
  
  // notification from JPush
  func networkDidLogin(_ notification:Notification) {
    print("Action - networkDidLogin")
  }
  // notification from JPush

  func receivePushMessage(_ notification:Notification) {
    print("Action - receivePushMessage")
  }
  
  
  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    application.cancelAllLocalNotifications()
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}

extension AppDelegate: JMessageDelegate {
  func onReceive(_ event: JMSGNotificationEvent!) {
    switch event.eventType {
    case .loginKicked:
      UserDefaults.standard.removeObject(forKey: kuserName)
      UserDefaults.standard.synchronize()
      
      let alertView = UIAlertView(title: "登录状态出错", message: "", delegate: self, cancelButtonTitle: "确定")
      alertView.show()
      break
    default:
      break
    }
    
  }
}

extension AppDelegate: UIAlertViewDelegate {
  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    let loginVC = JChatAlreadyLoginViewController()
    loginVC.hidesBottomBarWhenPushed = true
    let loginNVC = UINavigationController(rootViewController: loginVC)
    self.window?.rootViewController = loginNVC
  }
}
