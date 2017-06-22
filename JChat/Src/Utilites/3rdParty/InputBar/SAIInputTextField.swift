//
//  SAIInputTextField.swift
//  SAIInputBar
//
//  Created by SAGESSE on 7/23/16.
//  Copyright © 2016-2017 SAGESSE. All rights reserved.
//

import UIKit

internal class SAIInputTextField: UITextView {
    
    override var contentSize: CGSize {
        didSet {
            item.contentSizeChanged()
        }
    }
    
    override var text: String! {
        set {
            super.text = newValue
            delegate?.textViewDidChange?(self)
        }
        get {
            return super.text
        }
    }
    override var attributedText: NSAttributedString! {
        set {
            super.attributedText = newValue
            delegate?.textViewDidChange?(self)
        }
        get {
            return super.attributedText
        }
    }
    
//    override func becomeFirstResponder() -> Bool {
//        super.becomeFirstResponder()
//        return self.becomeFirstResponder()
//    }
    
    
    func insertAttributedText(_ attributedText: NSAttributedString) {
        let currnetTextRange = selectedTextRange ?? UITextRange()
        let newTextLength = attributedText.length
        
        // read postion
        let location = offset(from: beginningOfDocument, to: currnetTextRange.start)
        let length = offset(from: currnetTextRange.start, to: currnetTextRange.end)
        let newRange = NSMakeRange(location, newTextLength)
        
        // update text
        let att = typingAttributes
        textStorage.replaceCharacters(in: NSMakeRange(location, length), with: attributedText)
        textStorage.addAttributes(att, range: newRange)
        
        // update new text range
        let newPosition = position(from: beginningOfDocument, offset: location + newTextLength) ?? UITextPosition()
        selectedTextRange = textRange(from: newPosition, to: newPosition)
    }
    
    
    lazy var item: SAIInputTextFieldItem = SAIInputTextFieldItem(textView: self, backgroundView: self.backgroundView)
    lazy var backgroundView: UIImageView = UIImageView()
}

// 旧的
//internal class SACInputBarTextView: UITextView {
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        build()
//    }
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        build()
//    }
//    
//    @inline(__always) private func build() {
//        addSubview(_caretView)
//    }
//    
//    @inline(__always) private func updateCaretView() {
//        _caretView.frame = caretRectForPosition(selectedTextRange?.start ?? UITextPosition())
//    }
//    
//    override func insertText(text: String) {
//        super.insertText(text)
//        updateCaretView()
//    }
//    override func insertAttributedText(attributedText: NSAttributedString) {
//        super.insertAttributedText(attributedText)
//        updateCaretView()
//    }
//    override func deleteBackward() {
//        super.deleteBackward()
//        updateCaretView()
//    }
//    override func clearText() {
//        super.clearText()
//        updateCaretView()
//    }
//    
//    override func willMoveToWindow(newWindow: UIWindow?) {
//        if newWindow != nil {
//            updateCaretView()
//        }
//        super.willMoveToWindow(newWindow)
//    }
//    
//    override func becomeFirstResponder() -> Bool {
//        let b = super.becomeFirstResponder()
//        if b {
//            _isFirstResponder = true
//        }
//        return b
//    }
//    
//    override func resignFirstResponder() -> Bool {
//        let b = super.resignFirstResponder()
//        if b {
//            updateCaretView()
//            _isFirstResponder = false
//        }
//        return b
//    }
//    
//    
//    var maxHeight: CGFloat = 93
//    var editing: Bool = false {
//        didSet {
//            if editing {
//                _caretView.hidden = _isFirstResponder
//            } else {
//                _caretView.hidden = true
//            }
//        }
//    }
//    
//    override var contentSize: CGSize {
//        didSet {
//            guard oldValue != contentSize && (oldValue.height <= maxHeight || contentSize.height <= maxHeight) else {
//                return
//            }
//            invalidateIntrinsicContentSize()
//            // 只有正在显示的时候才添加动画
//            guard window != nil else {
//                return
//            }
//            UIView.animateWithDuration(0.25) {
//                // 必须在更新父视图之前
//                self.layoutIfNeeded()
//                // 必须显示父视图, 因为这个改变会导致父视图大小改变
//                self.superview?.layoutIfNeeded()
//            }
//            SACNotificationCenter.postNotificationName(SACInputBarFrameDidChangeNotification, object: superview)
//        }
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        if contentSize.height > maxHeight {
//            return CGSizeMake(contentSize.width, maxHeight)
//        }
//        return contentSize
//    }
//    
//    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        // 如果是自定义菜单, 完全转发
//        if SACMenuController.sharedMenuController().isCustomMenu() {
//            return SACMenuController.sharedMenuController().canPerformAction(action, withSender: sender)
//        }
//        return super.canPerformAction(action, withSender: sender)
//    }
//    
//    override func forwardingTargetForSelector(aSelector: Selector) -> AnyObject? {
//        // 如果是自定义菜单, 完全转发
//        if SACMenuController.sharedMenuController().isCustomMenu() {
//            return SACMenuController.sharedMenuController().forwardingTargetForSelector(aSelector)
//        }
//        return super.forwardingTargetForSelector(aSelector)
//    }
//    
//    var _isFirstResponder: Bool = false {
//        didSet {
//            editing = !(!editing)
//        }
//    }
//    
//    lazy var _caretView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 1
//        view.clipsToBounds = true
//        view.backgroundColor = UIColor.purpleColor()
//        view.hidden = true
//        return view
//    }()
//}
//
