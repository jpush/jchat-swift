//
//  JCEmoticon.swift
//  JChat
//
//  Created by JIGUANG on 2017/3/8.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

internal protocol JCEmoticonDelegate: class {
    func emoticon(shouldSelectFor emoticon: JCEmoticon) -> Bool
    func emoticon(didSelectFor emoticon: JCEmoticon)
    
    func emoticon(shouldPreviewFor emoticon: JCEmoticon?) -> Bool
    func emoticon(didPreviewFor emoticon: JCEmoticon?)
}

open class JCEmoticon: NSObject {
    
    open var isBackspace: Bool {
        return self === JCEmoticon.backspace
    }
    
    public static let backspace: JCEmoticon = {
        let em = JCEmoticon()
        em.contents = "⌫"
        return em
    }()
    
    open func draw(in rect: CGRect, in ctx: CGContext) {
        
        switch contents {
        case let image as UIImage:
            var nrect = rect
            nrect.size = image.size
            nrect.origin.x = rect.minX + (rect.width - nrect.width) / 2
            nrect.origin.y = rect.minY + (rect.height - nrect.height) / 2
            image.draw(in: nrect)
            
        case let str as NSString:
            let cfg = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 32)]
            let size = str.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary(cfg))
            let nrect = CGRect(x: rect.minX + (rect.width - size.width + 3) / 2,
                               y: rect.minY + (rect.height - size.height) / 2,
                               width: size.width,
                               height: size.height)
            str.draw(in: nrect, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(cfg))
            
        case let str as NSAttributedString:
            str.draw(in: rect)
            
        default:
            break
        }
    }
    
    open func show(in view: UIView) {
        let imageView = view.subviews.first as? UIImageView ?? {
            let imageView = UIImageView()
            view.subviews.forEach{
                $0.removeFromSuperview()
            }
            view.addSubview(imageView)
            return imageView
            }()
        
        if let image = contents as? UIImage {
            imageView.subviews.forEach{
                $0.removeFromSuperview()
            }
            imageView.bounds = CGRect(origin: .zero, size: image.size)
            imageView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
            imageView.image = contents as? UIImage
        }
        if let emjoji = contents as? String {
            imageView.subviews.forEach{
                $0.removeFromSuperview()
            }
            let label = UILabel(frame: view.frame)
            label.textAlignment = .center
            label.text = emjoji
            label.font = UIFont.systemFont(ofSize: view.frame.width / 3 * 2)
            imageView.addSubview(label)
        }
    }
    
    // 目前只支持UIImage/NSString/NSAttributedString
    open var contents: Any?
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
