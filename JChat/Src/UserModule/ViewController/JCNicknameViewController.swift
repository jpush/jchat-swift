//
//  JCNicknameViewController.swift
//  JChat
//
//  Created by deng on 2017/3/29.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCNicknameViewController: UIViewController {
    
    var nickName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
        nicknameTextField.text = nickName
        var count = 20 - nickName.characters.count
        count = count < 0 ? 0 : count
        tipLabel.text = "\(count)"
        nicknameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private lazy var navRightButton: UIBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(_saveNickname))
    fileprivate lazy var nicknameTextField: UITextField = UITextField(frame: CGRect(x: 0, y: 64, width: self.view.width, height: 45))
    fileprivate lazy var tipLabel:  UILabel = UILabel(frame: CGRect(x: self.view.width - 15 - 28, y: 64 + 21, width: 28, height: 12))
    
    //MARK: - private func 
    private func _init() {
        self.title = "昵称"
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(netHex: 0xe8edf3)
        
        nicknameTextField.backgroundColor = .white
        nicknameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        nicknameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 27, height: 0))
        nicknameTextField.leftViewMode = .always
        nicknameTextField.rightViewMode = .always
        nicknameTextField.delegate = self
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChanged(_ :)), for: .editingChanged)
        view.addSubview(nicknameTextField)
        
        tipLabel.text = "20"
        tipLabel.textColor = UIColor(netHex: 0x999999)
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textAlignment = .right
        view.addSubview(tipLabel)
        _setupNavigation()
    }
    
    private func _setupNavigation() {
        self.navigationItem.rightBarButtonItem =  navRightButton
    }
    
    func textFieldDidChanged(_ textField: UITextField) {
        // markedTextRange指的是当前高亮选中的，除了长按选中，用户中文输入拼音过程往往也是高亮选中状态
        if textField.markedTextRange == nil {
            let text = textField.text!
            if text.characters.count > 20 {
                let range = Range<String.Index>(text.startIndex ..< text.index(text.startIndex, offsetBy: 20))
                
                let subText = text.substring(with: range)
                textField.text = subText
            }
            let count = 20 - (textField.text?.characters.count)!
            tipLabel.text = "\(count)"
        }
    }
    
    //MARK: - click func
    func _saveNickname() {
        nicknameTextField.resignFirstResponder()
        let nickname = nicknameTextField.text!
        JMSGUser.updateMyInfo(withParameter: nickname, userFieldType: .fieldsNickname) { (resultObject, error) -> Void in
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateUserInfo), object: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                print("error:\(String(describing: error?.localizedDescription))")
            }
        }
    }
}

extension JCNicknameViewController: UITextFieldDelegate {
    
}
