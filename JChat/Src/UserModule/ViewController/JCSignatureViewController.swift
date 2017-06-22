//
//  JCSignatureViewController.swift
//  JChat
//
//  Created by deng on 2017/3/29.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCSignatureViewController: UIViewController {
    
    var signature: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
        signatureTextView.text = signature
        var count = 30 - signature.characters.count
        count = count < 0 ? 0 : count
        tipLabel.text = "\(count)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private lazy var saveButton: UIButton = {
        var saveButton = UIButton()
        saveButton.setTitle("提交", for: .normal)
        let colorImage = UIImage.createImage(color: UIColor(netHex: 0x2dd0cf), size: CGSize(width: self.view.width - 30, height: 40))
        saveButton.setBackgroundImage(colorImage, for: .normal)
        saveButton.addTarget(self, action: #selector(_saveSignature), for: .touchUpInside)
        return saveButton
    }()
    private lazy var bgView: UIView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.width, height: 120))
    private lazy var signatureTextView: UITextView = UITextView(frame: CGRect(x: 15, y: 15, width: self.view.width - 30, height: 90))
    private lazy var navRightButton: UIBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(_saveSignature))
    fileprivate lazy var tipLabel:  UILabel = UILabel(frame: CGRect(x: self.bgView.width - 15 - 50, y: self.bgView.height - 24, width: 50, height: 12))
 
    //MARK: - private func 
    private func _init() {
        self.title = "个性签名"
        self.automaticallyAdjustsScrollViewInsets = false;
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        bgView.backgroundColor = .white
        view.addSubview(bgView)
        
        signatureTextView.delegate = self
        signatureTextView.font = UIFont.systemFont(ofSize: 16)
        signatureTextView.backgroundColor = .white
        bgView.addSubview(signatureTextView)
        
        tipLabel.text = "30"
        
        tipLabel.textColor = UIColor(netHex: 0x999999)
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textAlignment = .right
        bgView.addSubview(tipLabel)

        view.addConstraint(_JCLayoutConstraintMake(saveButton, .left, .equal, view, .left, 15))
        view.addConstraint(_JCLayoutConstraintMake(saveButton, .right, .equal, view, .right, -15))
        view.addConstraint(_JCLayoutConstraintMake(saveButton, .top, .equal, bgView, .bottom, 15))
        view.addConstraint(_JCLayoutConstraintMake(saveButton, .height, .equal, nil, .notAnAttribute, 40))
        
        _setupNavigation()
    }
    
    private func _setupNavigation() {
        self.navigationItem.rightBarButtonItem =  navRightButton
    }
    
    //MARK: - click func
    func _saveSignature() {
        signatureTextView.resignFirstResponder()
        
        JMSGUser.updateMyInfo(withParameter: signatureTextView.text!, userFieldType: .fieldsSignature) { (resultObject, error) -> Void in
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateUserInfo), object: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                print("error:\(String(describing: error?.localizedDescription))")
            }
            
        }
    }
}

extension JCSignatureViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.markedTextRange != nil {
            
        } else {
            let text = textView.text!
            if text.characters.count > 30 {
                let range = Range<String.Index>(text.startIndex ..< text.index(text.startIndex, offsetBy: 30))
                
                let subText = text.substring(with: range)
                textView.text = subText
            }
            let count = 30 - (textView.text?.characters.count)!
            tipLabel.text = "\(count)"
        }
    }
}
