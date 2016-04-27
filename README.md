# jchat-swift


### 介绍

JChatSwift 是用Swift实现的一个聊天 App。

JChat 具有完备的即时通讯功能。主要有：

- 基本的聊天类型：文本、语音、图片；
- 单聊与群聊；
- 用户属性，包括头像；
- 黑名单；
- 好友通讯录；

JChat 的功能基于 JMessage SDK 来开发。它是一个 JMessage SDK 的完备的 Demo，但不仅仅是 Demo。我们的预期与目标是，当你的业务需要一个企业级的聊天 App 时，可以基于这里提供的源代码，更换 Logo 与应用名称，就可以直接用上。

JChat 当前提供 Android 与 iOS 版本。稍后也将提供 Web 版本。

- [JChat Android](https://github.com/jpush/jchat-android)

### 运行

本源代码项目要编译运行跑起来，需要注意以下几个地方。

##### 打开项目文件 JChatSwift.xcworkspace

因为这是一个 [CocoaPods](https://cocoapods.org) 项目。打开 .xcodeproj 项目目录将缺少依赖。

	
##### 配置运行的基本属性

- appKey：JPush appKey 是 JMessage SDK 运行的基本参数。请到 [JPush 官方网站](https://jpush.cn)登录控制台创建应用获取。
- bundle_id：这是一个 iOS 应用的基本属性。你需要登录到 Apple 开发者网站去创建应用。

### JMessage 文档

- [JMessage iOS 集成指南](http://docs.jpush.io/guideline/jmessage_ios_guide/)
- [JMessage iOS 说明](http://docs.jpush.io/client/im_sdk_ios/)
- [JMessage iOS API Docs](http://docs.jpush.io/client/jmessage_ios_appledoc_html/)
- [Swift 中调用 JMessage接口教程](http://dev.eltima.com/post/90770164170/using-third-party-objective-c-frameworks-in-swift) 添加如下代码到 xxx-Bridging-Header.h 文件中
```
#import <JMessage/JMessage.h>
```

### JMessage 升级

JMessage 当前版本为 2.0.x。与之前 1.0.x 版本有比较大的变更。

因为变更太大，所以这次变更有点不够友好，大部分 API 有调整，包括对象结构。这会导致集成 JMessage SDK 1.0.x 版本的 App 切换到新版本时，会编译不通过，某些 API 调用需要调整。调整的具体思路，可参考本项目 JChat iOS 源代码，以及 JMessage iOS 相关文档。

## JChat 介绍

## JChat 工程结构
![如图](https://github.com/jpush/jchat-swift/blob/master/READMEREC/JChat流程图副本.png)

## JChat 代码结构
主要分为五个功能模块：用户详情 (UserInfo)，会话列表 (Conversation List)，会话 (Conversation) 登录 (Login) 和 设置 (Setting)。每个功能模块按照 MVC 模式划分，部分模块还有一些 Util 类。

CustomUI
自定义 View

Category
通用 Category

Util
通用辅助类

## 主要功能索引
### JMessage 初始化代码
建议在 AppDelegate didFinishLaunchingWithOptions 方式初始化，如JChat 所示
```
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    JMessage.setupJMessage(launchOptions, appKey: JMSSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
    if #available(iOS 8, *) {
      // 可以自定义 categories
      JPUSHService.registerForRemoteNotificationTypes(
        UIUserNotificationType.Badge.rawValue |
        UIUserNotificationType.Sound.rawValue |
        UIUserNotificationType.Alert.rawValue,
        categories: nil)
    } else {
      JPUSHService.registerForRemoteNotificationTypes(
        UIUserNotificationType.Badge.rawValue |
        UIUserNotificationType.Sound.rawValue |
        UIUserNotificationType.Alert.rawValue,
        categories: nil)
    }
    self.registerJPushStatusNotification()
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.setupRootView()
    self.window?.makeKeyAndVisible()
    return true
  }

```

注册SDK
注册APNS
成功获得APNS token 传入JPUSHService 如下代码所示
```
- (void)application:(UIApplication *)application
  func application(application: UIApplication,
                              didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    JPUSHService.registerDeviceToken(deviceToken)
  }
```

### 注册 登录
首次使用JMessage 需要有JMessage 账户，通过如下代码注册一个新用户。JChat 项目在JCHATRegisterViewController 类中执行了注册操作，并且在注册完成回调执行登录操作(登录操作也可以移动到其它地方进行，具体看程序业务)。
```
@IBAction func clickToRegister(sender: AnyObject) {
    print("Action - clickToRegister")
    UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    if self.checkValidUsername(usernameTF.text!, password: passwordTF.text!) {
      MBProgressHUD.showMessage("正在注册", view: self.view)
      JMSGUser.registerWithUsername(usernameTF.text!, password: passwordTF.text!, completionHandler: { (resultObject, error) -> Void in
        if error == nil {
          MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
          MBProgressHUD.showMessage("注册成功,正在自动登陆", view: self.view)
          JMSGUser.loginWithUsername(self.usernameTF.text!, password: self.passwordTF.text!, completionHandler: { (resultObject, error) -> Void in
              MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if error == nil {

              self.userLoginSave()

              let detailVC = JCHATSetDetailViewController()
              self.navigationController?.pushViewController(detailVC, animated: true)
              
            } else {
              print("login fail error \(NSString.errorAlert(error))")
              MBProgressHUD.showMessage(NSString.errorAlert(error), view: self.view)
            }
          })
        }
      })
    }
  }
```
注册完成会回调 handler ，如下代码。如果出现错误会返回的error 不为nil，注意resultOvject 不同接口会返回不同类型的值或者nil，详细信息可以关注 [JMessage 官方文档](http://docs.jpush.io/client/im_sdk_ios/#summary)
```
public typealias JMSGCompletionHandler = (AnyObject!, NSError!) -> Void
```

### 会话 (Conversation)
会话是一个用户与用户之间聊天的载体，要有会话用户之间才能收发消息
获得会话有两种方式 1. 创建会话 2. 获取历史会话
#### 1.创建会话
如下代码分别创建了 单聊会话，和群聊会话, JChatSwift 在JChatConversationListViewController类 实现创建会话操作
```
func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 0 { return }

    if alertView.textFieldAtIndex(0)?.text == "" {
      MBProgressHUD .showMessage("请输入用户名", view: self.view)
      return
    } else {
      MBProgressHUD.showMessage("正在创建单聊", toView: self.view)
      JMSGConversation.createSingleConversationWithUsername((alertView.textFieldAtIndex(0)?.text)!, completionHandler: { (singleConversation, error) -> Void in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
        
        if error == nil {
          let chattingVC = JChatChattingViewController()
          chattingVC.hidesBottomBarWhenPushed = true
          chattingVC.conversation = singleConversation as! JMSGConversation
          self.navigationController?.pushViewController(chattingVC, animated: true)
          
        } else {
          MBProgressHUD.showMessage("添加的用户不存在", view: self.view)
        }
      })
    }
  }
```

#### 2. 获取历史会话
JChatSwift 在 JChatConversationListViewController类中获取所有历史会话的具体代码如下
```
  func getConversationList() {
    JMSGConversation.allConversations { (resultObject, error) -> Void in
      print("huangmin 888 \(resultObject)")
      if error == nil {
        self.conversationArr.removeAllObjects()
        self.conversationArr.addObjectsFromArray((resultObject as! [AnyObject]).reverse())
      } else {
        self.conversationArr.removeAllObjects()
      }
      self.conversationListTable.reloadData()
    }
  }
```
#### 3. 添加代理
若想监听conversation 的消息需要把某个对象设为conversation的delegate（可以是任何对象），比如JChatSwift JChatChattingViewController类需要监听发送回调，受消息回调则必须先设置代理，具体代码如下
```
JMessage.addDelegate(self, withConversation: self.conversation)
```

#### 4. 发送消息
JMSGMessage 是消息的实体。需要自己创建要发送的消息，JChatSwift JCHATConversationViewController类中发送消息的代码如下
```  
  func sendTextMessage(messageText: String) {
    let textContent:JMSGTextContent = JMSGTextContent(text: messageText)
    let textMessage:JMSGMessage = self.conversation.createMessageWithContent(textContent)!
    self.conversation.sendMessage(textMessage)
    let textModel:JChatMessageModel = JChatMessageModel()
    textModel.setChatModel(textMessage, conversation: self.conversation)
    self.appendMessage(textModel)
  }
```

#### 5. 接收消息
前面已经说了可以给conversation 添加回调delegate，收到消息也是通过回调函数来获取的，JChatSwift JChatChattingViewController类 收到消息回调方法如下
```
func onReceiveMessage(message: JMSGMessage!, error: NSError!) {
    self.conversation.clearUnreadCount()
    if message != nil {
      print("收到 message msgID 为 \(message.msgId)")
    } else {
      print("收到message 为 nil")
    }
    
    if error != nil {
      return
    }
    
    if !self.conversation.isMessageForThisConversation(message) {
      return
    }
    
    if message.contentType == .Custom { return }

    if messageDataSource.isContaintMessage(message.msgId) { print("该条消息已加载") }

    if message.contentType == .EventNotification {}
    
    let model = JChatMessageModel()
    model.setChatModel(message, conversation: self.conversation)
    self.appendMessage(model)
  }
```

