//
//  JCMessageVoiceContent.swift
//  JChat
//
//  Created by JIGUANG on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

open class JCMessageVoiceContent: NSObject, JCMessageContentType {

    public weak var delegate: JCMessageDelegate?
    open var layoutMargins: UIEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
    open class var viewType: JCMessageContentViewType.Type {
        return JCMessageVoiceContentView.self
    }
    open var data: Data?
    open var duration: TimeInterval = 9999
    open var attributedText: NSAttributedString?
    
    open func sizeThatFits(_ size: CGSize) -> CGSize {
        // +---------------+
        // | |||  99'59''  |
        // +---------------+
        let minute = Int(duration) / 60
        let second = Int(duration) % 60
        var string = "\(minute)'\(second)''"
        if minute == 0 {
            string = "\(second)''"
        }
        attributedText = NSAttributedString(string: string, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 14)]))
        
        return .init(width: 20 + 38 + 20, height: 26)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
