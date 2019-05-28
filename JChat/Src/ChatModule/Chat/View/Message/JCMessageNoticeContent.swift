//
//  JCMessageNoticeContent.swift
//  JChat
//
//  Created by JIGUANG on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

open class JCMessageNoticeContent: NSObject, JCMessageContentType {
    public weak var delegate: JCMessageDelegate?
    
    open var layoutMargins: UIEdgeInsets = .zero
    
    open class var viewType: JCMessageContentViewType.Type {
        return JCMessageNoticeContentView.self
    }
    
    public init(text: String) {
        self.text = text
        super.init()
    }
    
    open var text: String
    
    open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let attr = NSMutableAttributedString(string: text, attributes: convertToOptionalNSAttributedStringKeyDictionary([
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 12),
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white,
            ])) 
        let mattrSize = attr.boundingRect(with: CGSize(width: 250.0, height: Double(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
        let size = CGSize(width: mattrSize.size.width + 11, height: mattrSize.size.height + 4)
        return size
    }

    public static let unsupport: JCMessageNoticeContent = JCMessageNoticeContent(text: "The message does not support")
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
