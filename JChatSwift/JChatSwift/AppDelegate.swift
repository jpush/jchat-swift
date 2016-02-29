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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    JMessage.setupJMessage(launchOptions, appKey: JMSSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
    if #available(iOS 8, *) {
      // 可以自定义 categories
      JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
    } else {
      JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
    }
    return true
  }
  
  
//  - (void)setupRootView {
//  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
//  _tabBarCtl.loginIdentify = kHaveLogin;
//  self.window.rootViewController = _tabBarCtl;
//  } else {
//  if ([[NSUserDefaults standardUserDefaults] objectForKey:klastLoginUserName]) {
//  JCHATAlreadyLoginViewController *rLoginCtl = [[JCHATAlreadyLoginViewController alloc] init];//TODO:
//  UINavigationController *nvrLoginCtl = [[UINavigationController alloc] initWithRootViewController:rLoginCtl];
//  nvrLoginCtl.navigationBar.tintColor = kNavigationBarColor;
//  self.window.rootViewController = nvrLoginCtl;
//  } else {
//  JCHATLoginViewController *rootCtl = [[JCHATLoginViewController alloc] initWithNibName:@"JCHATLoginViewController" bundle:nil];
//  UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:rootCtl];
//  navLoginVC.navigationBar.tintColor = kNavigationBarColor;
//  self.window.rootViewController = navLoginVC;
//  }
//  }
//  
//  [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x3f80de)];
//  if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//  [[UINavigationBar appearance] setTranslucent:NO];//!
//  }
//  
//  NSShadow* shadow = [NSShadow new];
//  shadow.shadowOffset = CGSizeMake(0.0f, 0.0f);
//  [[UINavigationBar appearance] setTitleTextAttributes: @{
//  NSForegroundColorAttributeName: [UIColor whiteColor],
//  NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
//  NSShadowAttributeName: shadow
//  }];
//  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//  }
  func setupRootView() {
    if NSUserDefaults.standardUserDefaults().objectForKey(kuserName) != nil {
      
    }
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

