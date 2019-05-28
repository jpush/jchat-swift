//
//  JCMessageVideoContent.swift
//  JChat
//
//  Created by JIGUANG on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

let JC_VIDEO_MSG_IMAGE_WIDTH: CGFloat = 160.0
let JC_VIDEO_MSG_IMAGE_HEIGHT: CGFloat = 120.0

open class JCMessageVideoContent: NSObject, JCMessageContentType {

    typealias uploadVideoHandle = (_ percent: Float) -> ()
    
    public weak var delegate: JCMessageDelegate?
    var uploadVideo: uploadVideoHandle?
    open var layoutMargins: UIEdgeInsets = .zero
    open class var viewType: JCMessageContentViewType.Type {
        return JCMessageVideoContentView.self
    }
    open var data: Data?
    open var image: UIImage?
    //open var fileContent: JMSGFileContent?
    open var videoContent: JMSGVideoContent?
    //由于andriod暂时不支持文件视频类型，故sdk对文件视频类的做了特殊处理
    open var videoFileContent: JMSGFileContent?

    open func sizeThatFits(_ size: CGSize) -> CGSize {
        printLog("viedeo")
        if image == nil {
            return .init(width: 140, height: 89)
        }
        //image = JCVideoManager.getFristImage(data: data!)
        let size = image?.size ?? .zero
        let scale = min(min(JC_VIDEO_MSG_IMAGE_WIDTH, size.width) / size.width, min(JC_VIDEO_MSG_IMAGE_HEIGHT, size.height) / size.height)
        
        let w = size.width * scale
        let h = size.height * scale
        return .init(width: w, height: h)
    }
}
