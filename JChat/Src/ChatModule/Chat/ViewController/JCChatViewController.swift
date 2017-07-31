//
//  JCChatViewController.swift
//  JChat
//
//  Created by deng on 2017/2/28.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage
import YHPhotoKit
import MobileCoreServices
import AVKit
import AVFoundation

class JCChatViewController: UIViewController {
    
    open var conversation: JMSGConversation
    fileprivate var isGroup = false
    lazy var imageMessageArr: NSMutableArray = NSMutableArray()
    
    //MARK - life cycle
    public required init(conversation: JMSGConversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
        self.automaticallyAdjustsScrollViewInsets = false;
        if let draft = JCDraft.getDraft(conversation) {
            self.draft = draft
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    
    override func loadView() {
        super.loadView()
        let frame = CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height - 64)
        chatView = JCChatView(frame: frame, chatViewLayout: chatViewLayout)
        chatView.delegate = self
        chatView.messageDelegate = self
        _toolbar.translatesAutoresizingMaskIntoConstraints = false
        _toolbar.delegate = self
        if draft != nil {
            _toolbar.text = draft
            draft = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        if isGroup {
            let group = conversation.target as! JMSGGroup
            self.title = group.displayName()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        JCDraft.update(text: _toolbar.text, conversation: conversation)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        JMessage.remove(self, with: conversation)
    }
    
    private var draft: String?
    fileprivate lazy var _toolbar: SAIInputBar = SAIInputBar(type: .default)
    fileprivate lazy var _inputViews: [String: UIView] = [:]
    fileprivate weak var _inputItem: SAIInputItem?
    var chatViewLayout: JCChatViewLayout = .init()
    var chatView: JCChatView!
    fileprivate lazy var reminds: [JCRemind] = []
    fileprivate lazy var documentInteractionController = UIDocumentInteractionController()
    
    fileprivate lazy var imagePicker: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        return picker
    }()
    
    fileprivate lazy var videoPicker: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .camera
        picker.cameraCaptureMode = .video
        picker.videoMaximumDuration = 10
        picker.delegate = self
        return picker
    }()
    
    fileprivate lazy var _emoticonGroups: [JCCEmoticonGroup] = {
        var groups: [JCCEmoticonGroup] = []
        if let group = JCCEmoticonGroup(identifier: "com.apple.emoji") {
            groups.append(group)
        }
        if let group = JCCEmoticonGroup(identifier: "cn.jchat.guangguang") {
            groups.append(group)
        }
        return groups
    }()
    fileprivate lazy var _emoticonSendBtn: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10 + 8, 0, 8)
        button.setTitle("发送", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage.loadImage("chat_emoticon_btn_send_blue"), for: .normal)
        button.setBackgroundImage(UIImage.loadImage("chat_emoticon_btn_send_gray"), for: .disabled)
        button.addTarget(self, action: #selector(_sendHandler), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var emoticonView: JCEmoticonInputView = {
        let emoticonView = JCEmoticonInputView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 275))
        emoticonView.delegate = self
        emoticonView.dataSource = self
        return emoticonView
    }()
    
    fileprivate lazy var toolboxView: SAIToolboxInputView = {
        var toolboxView = SAIToolboxInputView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 197))
        toolboxView.delegate = self
        toolboxView.dataSource = self
        return toolboxView
    }()
    fileprivate lazy var _toolboxItems: [SAIToolboxItem] = {
        return [
            SAIToolboxItem("page:pic", "照片", UIImage.loadImage("chat_tool_pic")),
            SAIToolboxItem("page:camera", "拍照", UIImage.loadImage("chat_tool_camera")),
            SAIToolboxItem("page:video_s", "小视频", UIImage.loadImage("chat_tool_video_short")),
            SAIToolboxItem("page:location", "位置", UIImage.loadImage("chat_tool_location")),
            ]
    }()
    
    fileprivate var myAvator: UIImage?
    lazy var messages: [JCMessage] = []
    fileprivate let currentUser = JMSGUser.myInfo()
    fileprivate var messagePage = 0
    fileprivate var currentMessage: JCMessageType!
    fileprivate var maxTime = 0
    fileprivate var minTime = 0
    fileprivate var isFristLaunch = true
    fileprivate var recordingHub: JChatRecordingView!
    fileprivate lazy var recordHelper: JChatRecordVoiceHelper = {
        let recordHelper = JChatRecordVoiceHelper()
        recordHelper.delegate = self
        return recordHelper
    }()
    
    fileprivate lazy var leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 65 / 3))
    
    private func _init() {
        myAvator = UIImage.getMyAvator()
        isGroup = conversation.isGroup
        _updateTitle()
        view.backgroundColor = .white
        JMessage.add(self, with: conversation)
        _setupNavigation()
        
        _loadMessage(messagePage)
        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapView))
        tap.delegate = self
        chatView.addGestureRecognizer(tap)
        view.addSubview(chatView)
        
        _updateBadge()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_removeAllMessage), name: NSNotification.Name(rawValue: kDeleteAllMessage), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_updateFileMessage(_:)), name: NSNotification.Name(rawValue: kUpdateFileMessage), object: nil)
    }
    
    func _updateFileMessage(_ notification: Notification) {
        let userInfo = notification.userInfo
        let msgId = userInfo?[kUpdateFileMessage] as! String
        let message = conversation.message(withMessageId: msgId)!
        let content = message.content as! JMSGFileContent
        let url = URL(fileURLWithPath: content.originMediaLocalPath)
        let data = try! Data(contentsOf: url)
        updateFileMessage(message, data: data)
    }
    
    private func _updateTitle() {
        if isGroup {
            let group = conversation.target as! JMSGGroup
            title = group.displayName()
        } else {
            title = conversation.title
        }
    }
    
    func _removeAllMessage() {
        messages.removeAll()
        chatView.removeAll()
    }
    
    func _tapView() {
        view.endEditing(true)
        let _ = _toolbar.resignFirstResponder()
    }
    
    private func _setupNavigation() {
        let navButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if isGroup {
            navButton.setImage(UIImage.loadImage("com_icon_group_w"), for: .normal)
            navButton.addTarget(self, action: #selector(_getGroupInfo), for: .touchUpInside)
        } else {
            navButton.setImage(UIImage.loadImage("com_icon_user_w"), for: .normal)
            navButton.addTarget(self, action: #selector(_getSingleInfo), for: .touchUpInside)
        }
        let item1 = UIBarButtonItem(customView: navButton)
        navigationItem.rightBarButtonItems =  [item1]
        
        leftButton.setImage(UIImage.loadImage("com_icon_back"), for: .normal)
        leftButton.setImage(UIImage.loadImage("com_icon_back"), for: .highlighted)
        leftButton.addTarget(self, action: #selector(_back), for: .touchUpInside)
        leftButton.setTitle("会话", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftButton.contentHorizontalAlignment = .left
        let item2 = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItems =  [item2]
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func _back() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func _loadMessage(_ page: Int) {
        let messages = conversation.messageArrayFromNewest(withOffset: NSNumber(value: page * 15), limit: NSNumber(value: 17))
        if messages.count == 0 {
            return
        }
        var msgs: [JCMessage] = []
        for index in 0..<messages.count {
            let message = messages[index]
            if let msg = self._parseMessage(message) {
                msgs.insert(msg, at: 0)
                if isNeedInsertTimeLine(message.timestamp.intValue) || index == messages.count - 1 {
                    let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(message.timestamp.intValue / 1000)))
                    let m = JCMessage(content: timeContent)
                    msgs.insert(m, at: 0)
                }
            }
        }
        if page != 0 {
            self.chatView.insert(contentsOf: msgs, at: 0)
        } else {
            self.chatView.append(contentsOf: msgs)
        }
        self.messages.insert(contentsOf: msgs, at: 0)
    }
    
    private func isNeedInsertTimeLine(_ time: Int) -> Bool {
        if maxTime == 0 || minTime == 0 {
            maxTime = time
            minTime = time
            return true
        }
        if (time - maxTime) >= 5 * 60000 {
            maxTime = time
            return true
        }
        if (minTime - time) >= 5 * 60000 {
            minTime = time
            return true
        }
        return false
    }
    
    // MARK: - parse message
    fileprivate func _parseMessage(_ message: JMSGMessage) -> JCMessage? {
        var msg: JCMessage!
        let fromUser = message.fromUser
        let currentUser = JMSGUser.myInfo()
        let isCurrent = fromUser.isEqual(to: currentUser)
        let state = message.state
        
        switch(message.contentType) {
        case .text:
            let content = message.content as! JMSGTextContent
            msg = JCMessage(content: JCMessageTextContent(text: content.text))
        case .image:
            let model = JChatMessageModel()
            model.setChatModel(message, conversation: self.conversation)
            imageMessageArr.add(model)
            
            let content = message.content as! JMSGImageContent
            let imageContent = JCMessageImageContent()
            imageContent.imageSize = content.imageSize
            if message.isLargeEmoticon {
                imageContent.imageSize = CGSize(width: content.imageSize.width / 3, height: content.imageSize.height / 3)
            }
            
            if state == .sending {
                content.uploadHandler = {  (percent:Float, msgId:(String?)) -> Void in
                    imageContent.upload?(percent)
                }
            }
            imageContent.delegate = self
            msg = JCMessage(content: imageContent)
            content.thumbImageData({ (data, id, error) in
                if data != nil {
                    imageContent.image = UIImage(data: data!)
                    msg.content = imageContent
                }
            })
        case .eventNotification:
            let content = message.content as! JMSGEventContent
            let noticeContent = JCMessageNoticeContent(text: content.showEventNotification())
            msg = JCMessage(content: noticeContent)
            
        case .voice:
            let content = message.content as! JMSGVoiceContent
            let voidContent = JCMessageVoiceContent()
            voidContent.duration = TimeInterval(content.duration.intValue)
            msg = JCMessage(content: voidContent)
            content.voiceData({ (data, id, error) in
                if data != nil {
                    voidContent.data = data
                }
            })
        case .file:
            let content = message.content as! JMSGFileContent
            weak var weakSelf = self
            if message.isShortVideo {
                let videoContent = JCMessageVideoContent()
                videoContent.delegate = self
                msg = JCMessage(content: videoContent)
                content.fileData({ (data, id, error) in
                    if data != nil {
                        videoContent.data = data
                        weakSelf?.updateFileMessage(message, data: data!)
                    }
                })
                videoContent.fileContent = content
            } else {
                let fileContent = JCMessageFileContent()
                fileContent.delegate = self
                fileContent.fileName = content.fileName
                fileContent.fileType = message.fileType
                fileContent.fileSize = message.fileSize
                // 为什么要判断文件是否存在呢，这个是由于sdk bug导致的，sdk修复后可以去除
                if !content.originMediaLocalPath.isEmpty && JCFileManager.fileExists(atPath: content.originMediaLocalPath) {
                    content.fileData({ (data, id, error) in
                        if data != nil {
                            fileContent.data = data
                            weakSelf?.updateFileMessage(message, data: data!)
                        }
                    })
                }
                msg = JCMessage(content: fileContent)
            }
            
        case .location:
            let content = message.content as! JMSGLocationContent
            let locationContent = JCMessageLocationContent()
            locationContent.address = content.address
            locationContent.lat = content.latitude.doubleValue
            locationContent.lon = content.longitude.doubleValue
            locationContent.delegate = self
            msg = JCMessage(content: locationContent)
            
        case .prompt:
            let content = message.content as! JMSGPromptContent
            let noticeContent = JCMessageNoticeContent(text: content.promptText)
            msg = JCMessage(content: noticeContent)
            
        default:
            msg = JCMessage(content: JCMessageNoticeContent.unsupport)
        }
        if msg.options.alignment != .center {
            msg.options.alignment = isCurrent ? .right : .left
            if isGroup {
                msg.options.showsCard = !isCurrent
            }
        }
        msg.msgId = message.msgId
        msg.options.state = state
        if isCurrent {
            msg.senderAvator = myAvator
        }
        msg.sender = fromUser
        msg.name = fromUser.displayName()
        return msg
    }
    
    
    // MARK: - send message
    func send(_ message: JCMessage, _ jmessage: JMSGMessage) {
        if isNeedInsertTimeLine(jmessage.timestamp.intValue) {
            let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(jmessage.timestamp.intValue / 1000)))
            let m = JCMessage(content: timeContent)
            messages.append(m)
            chatView.append(m)
        }
        message.msgId = jmessage.msgId
        message.name = currentUser.displayName()
        message.senderAvator = myAvator
        message.sender = currentUser
        message.options.alignment = .right
        message.options.state = .sending
        
        chatView.append(message)
        messages.append(message)
        chatView.scrollToLast(animated: false)
        conversation.send(jmessage)
    }
    
    func send(forText text: NSAttributedString) {
        let message = JCMessage(content: JCMessageTextContent(attributedText: text))
        let content = JMSGTextContent(text: text.string)
        let msg = JMSGMessage.createMessage(conversation, content, reminds)
        send(message, msg)
    }
    
    func send(forLargeEmoticon emoticon: JCCEmoticonLarge) {
        guard let image = emoticon.contents as? UIImage else {
            return
        }
        let messageContent = JCMessageImageContent()
        messageContent.image = image
        messageContent.delegate = self
        let message = JCMessage(content: messageContent)
        
        let content = JMSGImageContent(imageData: UIImagePNGRepresentation(image)!)
        let msg = JMSGMessage.createMessage(conversation, content!, nil)
        msg.isLargeEmoticon = true
        message.options.showsTips = true
        send(message, msg)
    }
    
    func send(forImage image: UIImage) {
        let content = JMSGImageContent(imageData: UIImagePNGRepresentation(image)!)
        let message = JMSGMessage.createMessage(conversation, content!, nil)
        let imageContent = JCMessageImageContent()
        imageContent.delegate = self
        imageContent.image = image
        content?.uploadHandler = {  (percent:Float, msgId:(String?)) -> Void in
            imageContent.upload?(percent)
        }
        let msg = JCMessage(content: imageContent)
        send(msg, message)
    }
    
    func send(voiceData: Data, duration: Double) {
        let voiceContent = JCMessageVoiceContent()
        voiceContent.data = voiceData
        voiceContent.duration = duration
        
        let content = JMSGVoiceContent(voiceData: voiceData, voiceDuration: NSNumber(value: duration))
        let message = JMSGMessage.createMessage(conversation, content, nil)
        
        let msg = JCMessage(content: voiceContent)
        send(msg, message)
    }
    
    func send(fileData: Data) {
        let videoContent = JCMessageVideoContent()
        videoContent.data = fileData
        videoContent.delegate = self
        
        let content = JMSGFileContent(fileData: fileData, fileName: "小视频")
        let message = JMSGMessage.createMessage(conversation, content, nil)
        message.isShortVideo = true
        let msg = JCMessage(content: videoContent)
        send(msg, message)
    }
    
    func send(address: String, lon: NSNumber, lat: NSNumber) {
        
        let locationContent = JCMessageLocationContent()
        locationContent.address = address
        locationContent.lat = lat.doubleValue
        locationContent.lon = lon.doubleValue
        locationContent.delegate = self
        
        let content = JMSGLocationContent(latitude: lat, longitude: lon, scale: NSNumber(value: 1), address: address)
        
        let message = JMSGMessage.createMessage(conversation, content, nil)
        let msg = JCMessage(content: locationContent)
        send(msg, message)
    }
    
    func keyboardFrameChanged(_ notification: Notification) {
        
        let dic = NSDictionary(dictionary: (notification as NSNotification).userInfo!)
        let keyboardValue = dic.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let bottomDistance = UIScreen.main.bounds.size.height - keyboardValue.cgRectValue.origin.y
        let duration = Double(dic.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        
        UIView.animate(withDuration: duration, animations: {
        }) { (finish) in
            if (bottomDistance == 0 || bottomDistance == self._toolbar.height) && !self.isFristLaunch {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.chatView.scrollToLast(animated: false)
            }
            self.isFristLaunch = false
        }
    }
    
    func _sendHandler() {
        let text = _toolbar.attributedText
        if text != nil && (text?.length)! > 0 {
            send(forText: text!)
            _toolbar.attributedText = nil
        }
    }
    
    func _getSingleInfo() {
        let vc = JCSingleSettingViewController()
        vc.user = conversation.target as! JMSGUser
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func _getGroupInfo() {
        let vc = JCGroupSettingViewController()
        let group = conversation.target as! JMSGGroup
        vc.group = group
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - JMSGMessage Delegate
extension JCChatViewController: JMessageDelegate {
    
    fileprivate func updateFileMessage(_ message: JMSGMessage, data: Data) {
        let index = messages.index { (m) -> Bool in
            return m.msgId == message.msgId
        }
        if let index = index {
            let msg = messages[index]
            if message.isShortVideo {
                let videoContent = msg.content as! JCMessageVideoContent
                videoContent.data = data
                videoContent.delegate = self
                msg.content = videoContent
            } else {
                let fileContent = msg.content as! JCMessageFileContent
                fileContent.data = data
                fileContent.delegate = self
                msg.content = fileContent
            }
            msg.updateSizeIfNeeded = true
            chatView.update(msg, at: index)
            msg.updateSizeIfNeeded = false
            chatView.update(msg, at: index)
            messages[index] = msg
        }
    }
    
    func _updateBadge() {
        JMSGConversation.allConversations { (result, error) in
            guard let conversations = result as? [JMSGConversation] else {
                return
            }
            let count = getAllConversation(conversations)
            if count == 0 {
                self.leftButton.setTitle("会话", for: .normal)
            } else {
                self.leftButton.setTitle("会话(\(count))", for: .normal)
            }
        }
    }
    
    func onReceive(_ message: JMSGMessage!, error: Error!) {
        if error != nil {
            return
        }
        let message = _parseMessage(message)
        // TODO: 这个判断是sdk bug导致的，暂时只能这么改
        if self.messages.contains(where: { (m) -> Bool in
            return m.msgId == message?.msgId
        }) {
            let indexs = chatView.indexPathsForVisibleItems
            for index in indexs {
                var m = self.messages[index.row]
                if !m.msgId.isEmpty {
                    m = self._parseMessage(self.conversation.message(withMessageId: m.msgId)!)!
                    self.chatView.update(m, at: index.row)
                }
            }
            return
        }
        
        if let message = message {
            self.messages.append(message)
            chatView.append(message)
        }
        self.conversation.clearUnreadCount()
        if !self.chatView.isRoll {
            chatView.scrollToLast(animated: true)
        }
        _updateBadge()
    }
    
    func onSendMessageResponse(_ message: JMSGMessage!, error: Error!) {
        if let error = error as NSError? {
            if error.code == 803009 {
                MBProgressHUD_JChat.show(text: "发送失败，此次消息包含敏感词", view: view)
            }
        }
        let index = messages.index { (m) -> Bool in
            return m.msgId == message.msgId
        }
        if let index = index {
            let msg = self.messages[index]
            msg.options.state = message.state
            self.messages[index] = msg
            self.chatView.update(msg, at: index)
        }
    }
    
    func onReceive(_ retractEvent: JMSGMessageRetractEvent!) {
        let index = messages.index { (m) -> Bool in
            return m.msgId == retractEvent.retractMessage.msgId
        }
        if let index = index {
            if let msg = _parseMessage(retractEvent.retractMessage) {
                self.messages[index] = msg
                self.chatView.update(msg, at: index)
            }
        }
    }
    
    func onSyncOfflineMessageConversation(_ conversation: JMSGConversation!, offlineMessages: [JMSGMessage]!) {
        let messages = offlineMessages.sorted(by: { (m1, m2) -> Bool in
            return m1.timestamp.intValue < m2.timestamp.intValue
        })
        for item in messages {
            let message = self._parseMessage(item)
            if let message = message {
                self.messages.append(message)
                chatView.append(message)
            }
            self.conversation.clearUnreadCount()
            if !chatView.isRoll {
                chatView.scrollToLast(animated: true)
            }
        }
        _updateBadge()
    }
}

// MARK: - JCEmoticonInputViewDataSource & JCEmoticonInputViewDelegate
extension JCChatViewController: JCEmoticonInputViewDataSource, JCEmoticonInputViewDelegate {
    
    open func numberOfEmotionGroups(in emoticon: JCEmoticonInputView) -> Int {
        return _emoticonGroups.count
    }
    open func emoticon(_ emoticon: JCEmoticonInputView, emotionGroupForItemAt index: Int) -> JCEmoticonGroup {
        return _emoticonGroups[index]
    }
    open func emoticon(_ emoticon: JCEmoticonInputView, numberOfRowsForGroupAt index: Int) -> Int {
        return _emoticonGroups[index].rows
    }
    open func emoticon(_ emoticon: JCEmoticonInputView, numberOfColumnsForGroupAt index: Int) -> Int {
        return _emoticonGroups[index].columns
    }
    open func emoticon(_ emoticon: JCEmoticonInputView, moreViewForGroupAt index: Int) -> UIView? {
        if _emoticonGroups[index].type.isSmall {
            return _emoticonSendBtn
        }
        else {
            return nil
        }
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, insetForGroupAt index: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 10, 12 + 24, 10)
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, shouldSelectFor item: JCEmoticon) -> Bool {
        return true
    }
    open func emoticon(_ emoticon: JCEmoticonInputView, didSelectFor item: JCEmoticon) {
        
        if item.isBackspace {
            _toolbar.deleteBackward()
            return
        }
        
        if let emoticon = item as? JCCEmoticonLarge {
            send(forLargeEmoticon: emoticon)
            return
        }
        if let code = item.contents as? String {
            return _toolbar.insertText(code)
        }
        if let image = item.contents as? UIImage {
            let d = _toolbar.font?.descender ?? 0
            let h = _toolbar.font?.lineHeight ?? 0
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: d, width: h, height: h)
            _toolbar.insertAttributedText(NSAttributedString(attachment: attachment))
            return
        }
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, shouldPreviewFor item: JCEmoticon?) -> Bool {
        return false
    }
    open func emoticon(_ emoticon: JCEmoticonInputView, didPreviewFor item: JCEmoticon?) {
        
    }
}

// MARK: - SAIToolboxInputViewDataSource & SAIToolboxInputViewDelegate
extension JCChatViewController: SAIToolboxInputViewDataSource, SAIToolboxInputViewDelegate {
    
    open func numberOfToolboxItems(in toolbox: SAIToolboxInputView) -> Int {
        return _toolboxItems.count
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, toolboxItemForItemAt index: Int) -> SAIToolboxItem {
        return _toolboxItems[index]
    }
    
    open func toolbox(_ toolbox: SAIToolboxInputView, numberOfRowsForSectionAt index: Int) -> Int {
        return 2
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, numberOfColumnsForSectionAt index: Int) -> Int {
        return 4
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, insetForSectionAt index: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 10, 12, 10)
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, shouldSelectFor item: SAIToolboxItem) -> Bool {
        return true
    }
    private func _pushToSelectPhotos() {
        let vc = YHPhotoPickerViewController()
        vc.maxPhotosCount = 9;
        vc.pickerDelegate = self
        self.present(vc, animated: true)
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, didSelectFor item: SAIToolboxItem) {
        let _ = _toolbar.resignFirstResponder()
        switch item.identifier {
        case "page:pic":
            if PHPhotoLibrary.authorizationStatus() != .authorized {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    DispatchQueue.main.sync {
                        if status != .authorized {
                            JCAlertView.bulid().setTitle("无权限访问照片").setMessage("请在设备的设置-极光 IM中允许访问照片。").setDelegate(self).addCancelButton("好的").addButton("去设置").setTag(10001).show()
                        } else {
                            self._pushToSelectPhotos()
                        }
                    }
                })
            } else {
                _pushToSelectPhotos()
            }
        case "page:camera":
            present(imagePicker, animated: true, completion: nil)
        case "page:video_s":
            present(videoPicker, animated: true, completion: nil)
        case "page:location":
            let vc = JCAddMapViewController()
            vc.addressBlock = { (dict: Dictionary?) in
                if dict != nil {
                    let lon = Float(dict?["lon"] as! String)
                    let lat = Float(dict?["lat"] as! String)
                    let address = dict?["address"] as! String
                    self.send(address: address, lon: NSNumber(value: lon!), lat: NSNumber(value: lat!))
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - UIImagePickerControllerDelegate & YHPhotoPickerViewControllerDelegate
extension JCChatViewController: YHPhotoPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func selectedPhotoBeyondLimit(_ count: Int32, currentView view: UIView!) {
        MBProgressHUD_JChat.show(text: "最多选择\(count)张图片", view: nil)
    }
    
    func yhPhotoPickerViewController(_ PhotoPickerViewController: YHSelectPhotoViewController!, selectedPhotos photos: [Any]!) {
        for item in photos {
            guard let photo = item as? UIImage else {
                return
            }
            send(forImage: photo)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        image = image?.fixOrientation()
        if image != nil {
            send(forImage: image!)
        }
        let videoUrl = info[UIImagePickerControllerMediaURL] as! URL?
        if videoUrl != nil {
            let data = try! Data(contentsOf: videoUrl!)
            send(fileData: data)
        }
    }
}

extension JCChatViewController: JCMessageDelegate {
    func message(videoData data: Data?) {
        if let data = data {
            JCVideoManager.playVideo(data: data, currentViewController: self)
        }
    }
    
    func message(location address: String?, lat: Double, lon: Double) {
        let vc = JCAddMapViewController()
        vc.isOnlyShowMap = true
        vc.lat = lat
        vc.lon = lon
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func message(image: UIImage?, indexPath: IndexPath?) {
        let browserImageVC = JChatImageBrowserViewController()
        //        let tmpImageArr = self.imageMessageArr
        browserImageVC.imageArr = [image!]
        browserImageVC.imgCurrentIndex = 0
        self.present(browserImageVC, animated: true) {}
    }
    
    func message(message: JCMessageType, fileData data: Data?, fileName: String?, fileType: String?) {
        if data == nil {
            let vc = JCFileDownloadViewController()
            vc.title = fileName
            let msg = conversation.message(withMessageId: message.msgId)
            vc.fileSize = msg?.fileSize
            vc.message = msg
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let fileType = fileType else {
                return
            }
            let msg = conversation.message(withMessageId: message.msgId)!
            let content = msg.content as! JMSGFileContent
            switch fileType.fileFormat() {
            case .document:
                let vc = JCDocumentViewController()
                vc.title = fileName
                vc.fileData = data
                vc.filePath = content.originMediaLocalPath
                vc.fileType = fileType
                self.navigationController?.pushViewController(vc, animated: true)
            case .video, .voice:
                let url = URL(fileURLWithPath: content.originMediaLocalPath)
                try! JCVideoManager.playVideo(data: Data(contentsOf: url), fileType, currentViewController: self)
            case .photo:
                let browserImageVC = JChatImageBrowserViewController()
                let image = UIImage(contentsOfFile: content.originMediaLocalPath)
                browserImageVC.imageArr = [image!]
                browserImageVC.imgCurrentIndex = 0
                self.present(browserImageVC, animated: true) {}
            default:
                let url = URL(fileURLWithPath: content.originMediaLocalPath)
                documentInteractionController.url = url
                documentInteractionController.presentOptionsMenu(from: .zero, in: self.view, animated: true)
            }
        }
    }
    
    func clickTips(message: JCMessageType, indexPath: IndexPath?) {
        self.currentMessage = message
        let alertView = UIAlertView(title: "重新发送", message: "是否重新发送该消息？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "发送")
        alertView.show()
    }
    
    func tapAvatarView(message: JCMessageType) {
        let _ = _toolbar.resignFirstResponder()
        if message.options.alignment == .right {
            self.navigationController?.pushViewController(JCMyInfoViewController(), animated: true)
        } else {
            let vc = JCUserInfoViewController()
            vc.user = message.sender
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension JCChatViewController: JCChatViewDelegate {
    func refershChatView( chatView: JCChatView) {
        messagePage += 1
        _loadMessage(messagePage)
        self.chatView.stopRefresh()
    }
    
    func deleteMessage(message: JCMessageType) {
        conversation.deleteMessage(withMessageId: message.msgId)
        if let index = messages.index(where: { (m) -> Bool in
            m.msgId == message.msgId
        }) {
            messages.remove(at: index)
        }
    }
    
    //    func forwardMessage(message: JCMessageType) {
    //        if let message = conversation.message(withMessageId: message.msgId) {
    //            let vc = JCForwardViewController()
    //            vc.message = message
    //            let nav = JCNavigationController(rootViewController: vc)
    //            self.present(nav, animated: true)
    //        }
    //    }
    
    func withdrawMessage(message: JCMessageType) {
        guard let message = conversation.message(withMessageId: message.msgId) else {
            return
        }
        JMSGMessage.retractMessage(message, completionHandler: { (result, error) in
            if error == nil {
                let index = self.messages.index { (m) -> Bool in
                    return m.msgId == message.msgId
                }
                if let index = index {
                    if let msg = self._parseMessage(self.conversation.message(withMessageId: message.msgId)!) {
                        self.messages[index] = msg
                        self.chatView.update(msg, at: index)
                    }
                }
            } else {
                MBProgressHUD_JChat.show(text: "消息发送超过3分钟，不能撤回", view: self.view)
            }
        })
    }
}

extension JCChatViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 10001 {
            if buttonIndex == 1 {
                JCAppManager.openAppSetter()
            }
            return
        }
        switch buttonIndex {
        case 1:
            if let index = messages.index(where: { (m) -> Bool in
                return currentMessage.msgId == m.msgId
            }) {
                self.messages.remove(at: index)
                self.chatView.remove(at: index)
                let msg = conversation.message(withMessageId: currentMessage.msgId)
                currentMessage.options.state = .sending
                messages.append(currentMessage as! JCMessage)
                chatView.append(currentMessage)
                conversation.send(msg!)
                chatView.scrollToLast(animated: true)
            }
        default:
            break
        }
    }
}

// MARK: - SAIInputBarDelegate & SAIInputBarDisplayable
extension JCChatViewController: SAIInputBarDelegate, SAIInputBarDisplayable {
    
    open override var inputAccessoryView: UIView? {
        return _toolbar
    }
    open var scrollView: SAIInputBarScrollViewType {
        return chatView
    }
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open func inputView(with item: SAIInputItem) -> UIView? {
        if let view = _inputViews[item.identifier] {
            return view
        }
        switch item.identifier {
        case "kb:emoticon":
            let view = JCEmoticonInputView()
            view.delegate = self
            view.dataSource = self
            _inputViews[item.identifier] = view
            return view
            
        case "kb:toolbox":
            let view = SAIToolboxInputView()
            view.delegate = self
            view.dataSource = self
            _inputViews[item.identifier] = view
            return view
            
        default:
            return nil
        }
    }
    
    open func inputViewContentSize(_ inputView: UIView) -> CGSize {
        return CGSize(width: view.frame.width, height: 216)
    }
    
    func inputBar(_ inputBar: SAIInputBar, shouldDeselectFor item: SAIInputItem) -> Bool {
        return true
    }
    open func inputBar(_ inputBar: SAIInputBar, shouldSelectFor item: SAIInputItem) -> Bool {
        if item.identifier == "kb:audio" {
            return true
        }
        guard let _ = inputView(with: item) else {
            return false
        }
        return true
    }
    open func inputBar(_ inputBar: SAIInputBar, didSelectFor item: SAIInputItem) {
        _inputItem = item
        
        if item.identifier == "kb:audio" {
            inputBar.deselectBarAllItem()
            return
        }
        if let kb = inputView(with: item) {
            inputBar.setInputMode(.selecting(kb), animated: true)
        }
    }
    open func inputBar(didChangeMode inputBar: SAIInputBar) {
        if _inputItem?.identifier == "kb:audio" {
            return
        }
        if let item = _inputItem, !inputBar.inputMode.isSelecting {
            inputBar.deselectBarItem(item, animated: true)
        }
    }
    
    open func inputBar(didChangeText inputBar: SAIInputBar) {
        _emoticonSendBtn.isEnabled = inputBar.attributedText.length != 0
    }
    
    public func inputBar(shouldReturn inputBar: SAIInputBar) -> Bool {
        if inputBar.attributedText.length == 0 {
            return false
        }
        send(forText: inputBar.attributedText)
        inputBar.attributedText = nil
        return false
    }
    
    func inputBar(_ inputBar: SAIInputBar, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentIndex = range.location
        if !isGroup {
            return true
        }
        if string == "@" {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                let vc = JCRemindListViewController()
                vc.finish = { (user, isAtAll, length) in
                    let text = inputBar.text!
                    var displayName = "所有成员"
                    if let user = user {
                        displayName = user.displayName()
                    }
                    let remind = JCRemind(user, currentIndex, currentIndex + 2 + displayName.length, displayName.length + 2, isAtAll)
                    if text.length == currentIndex + 1 {
                        inputBar.text = text + displayName + " "
                    } else {
                        let index1 = text.index(text.endIndex, offsetBy: currentIndex - text.length + 1)
                        let prefix = text.substring(with: Range<String.Index>(text.startIndex..<index1))
                        let index2 = text.index(text.startIndex, offsetBy: currentIndex + 1)
                        let suffix = text.substring(with: Range<String.Index>(index2..<text.endIndex))
                        inputBar.text = prefix + displayName + " " + suffix
                        let _ = self.updateRemids(inputBar, "@" + displayName + " ", range, currentIndex)
                    }
                    self.reminds.append(remind)
                    self.reminds.sort(by: { (r1, r2) -> Bool in
                        return r1.startIndex < r2.startIndex
                    })
                }
                vc.group = self.conversation.target as! JMSGGroup
                let nav = JCNavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: {
                    
                })
            }
        } else {
            return updateRemids(inputBar, string, range, currentIndex)
        }
        return true
    }
    
    func updateRemids(_ inputBar: SAIInputBar, _ string: String, _ range: NSRange, _ currentIndex: Int) -> Bool {
        for index in 0..<reminds.count {
            let remind = reminds[index]
            let length = remind.length
            let startIndex = remind.startIndex
            let endIndex = remind.endIndex
            // Delete
            if currentIndex == endIndex - 1 && string.length == 0 {
                for _ in 0..<length {
                    inputBar.deleteBackward()
                }
                // Move Other Index
                for subIndex in (index + 1)..<reminds.count {
                    let subTemp = reminds[subIndex]
                    subTemp.startIndex -= length
                    subTemp.endIndex -= length
                }
                reminds.remove(at: index)
                return false;
            } else if currentIndex > startIndex && currentIndex < endIndex {
                // Delete Content
                if string.length == 0 {
                    for subIndex in (index + 1)..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex -= 1
                        subTemp.endIndex -= 1
                    }
                    reminds.remove(at: index)
                    return true
                }
                // Add Content
                else {
                    for subIndex in (index + 1)..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex += string.length
                        subTemp.endIndex += string.length
                    }
                    reminds.remove(at: index)
                    return true
                }
            }
        }
        for index in 0..<reminds.count {
            let tempDic = reminds[index]
            let startIndex = tempDic.startIndex
            if currentIndex <= startIndex {
                if string.characters.count == 0 {
                    for subIndex in index..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex -= 1
                        subTemp.endIndex -= 1
                    }
                    return true
                } else {
                    for subIndex in index..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex += string.length
                        subTemp.endIndex += string.length
                    }
                    return true
                }
            }
        }
        return true
    }
    
    func inputBar(touchDown recordButton: UIButton, inputBar: SAIInputBar) {
        if self.recordingHub != nil {
            self.recordingHub.removeFromSuperview()
        }
        self.recordingHub = JChatRecordingView(frame: CGRect.zero)
        self.recordHelper.updateMeterDelegate = self.recordingHub
        self.recordingHub.startRecordingHUDAtView(view)
        self.recordingHub.frame = CGRect(x: view.centerX - 70, y: view.centerY - 70, width: 136, height: 136)
        self.recordHelper.startRecordingWithPath(String.getRecorderPath()) { () -> Void in
        }
    }
    
    func inputBar(dragInside recordButton: UIButton, inputBar: SAIInputBar) {
        self.recordingHub.pauseRecord()
    }
    
    func inputBar(dragOutside recordButton: UIButton, inputBar: SAIInputBar) {
        self.recordingHub.resaueRecord()
    }
    
    func inputBar(touchUpInside recordButton: UIButton, inputBar: SAIInputBar) {
        if recordHelper.recorder ==  nil {
            return
        }
        self.recordHelper.finishRecordingCompletion()
        if (self.recordHelper.recordDuration! as NSString).floatValue < 1 {
            self.recordingHub.showErrorTips()
            let time: TimeInterval = 1.5
            let hub = self.recordingHub
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                hub?.removeFromSuperview()
            }
            return
        } else {
            self.recordingHub.removeFromSuperview()
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: self.recordHelper.recordPath!))
        send(voiceData: data, duration: Double(self.recordHelper.recordDuration!)!)
    }
    
    func inputBar(touchUpOutside recordButton: UIButton, inputBar: SAIInputBar) {
        self.recordHelper.cancelledDeleteWithCompletion()
        self.recordingHub.removeFromSuperview()
    }
}

// MARK: - JChatRecordVoiceHelperDelegate
extension JCChatViewController: JChatRecordVoiceHelperDelegate {
    public func beyondLimit(_ time: TimeInterval) {
        self.recordHelper.finishRecordingCompletion()
        self.recordingHub.removeFromSuperview()
        let data = try! Data(contentsOf: URL(fileURLWithPath: self.recordHelper.recordPath!))
        send(voiceData: data, duration: Double(self.recordHelper.recordDuration!)!)
    }
}

extension JCChatViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return true
        }
        if view.isKind(of: JCMessageTextContentView.self) {
            return false
        }
        return true
    }
}

extension JCChatViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
}
