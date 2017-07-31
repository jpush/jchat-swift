//
//  JCRegisterViewController.swift
//  JChat
//
//  Created by deng on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCRegisterViewController: UIViewController {
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        _updateRegisterButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -64, width: self.view.width, height: 64))
        view.backgroundColor = UIColor(netHex: 0x2DD0CF)
        let title = UILabel(frame: CGRect(x: self.view.centerX - 10, y: 20, width: 200, height: 44))
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = .white
        title.text = "JChat"
        view.addSubview(title)
        
        
        var rightButton = UIButton(frame: CGRect(x: view.width - 50 - 15, y: 20 + 7, width: 50, height: 30))
        rightButton.setTitle("去登录", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightButton.addTarget(self, action: #selector(_clickLoginButton), for: .touchUpInside)
        view.addSubview(rightButton)
        
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChanged(_ :)), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
        textField.tag = 1002
        textField.delegate = self
        textField.placeholder = "请输入密码"
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.frame = CGRect(x: 38 + 18 + 15, y: 108 + 80 + 60 + 27 + 30, width: self.view.width - 76 - 33, height: 40)
        return textField
    }()
    
    private lazy var userNameTextField: UITextField = {
        var textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChanged(_ :)), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
        textField.tag = 1001
        textField.delegate = self
        textField.placeholder = "请输入用户名"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.frame = CGRect(x: 38 + 18 + 15, y: 108 + 80 + 60, width: self.view.width - 76 - 33, height: 40)
        return textField
    }()
    
    fileprivate lazy var avatorView: UIImageView = {
        var avatorView = UIImageView()
        avatorView.frame = CGRect(x: self.view.centerX - 40, y: 108, width: 80, height: 80)
        avatorView.image = UIImage.loadImage("com_icon_80")
        return avatorView
    }()
    
    private lazy var loginButton: UIButton = {
        var button = UIButton()
        button.frame = CGRect(x: self.view.centerX + 12, y: self.view.height - 42, width: 50, height: 16.5)
        button.setTitle("立即登录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor(netHex: 0x2DD0CF), for: .normal)
        button.addTarget(self, action: #selector(_clickLoginButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(netHex: 0x2DD0CF)
        button.frame = CGRect(x: 38, y: 108 + 185 + 80, width: self.view.width - 76, height: 40)
        button.setTitle("注册", for: .normal)
        button.layer.cornerRadius = 3.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(_userRegister), for: .touchUpInside)
        return button
    }()
    
    private lazy var tipsLabel: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: self.view.centerX - 62, y: self.view.height - 42, width: 74, height: 16.5)
        label.text = "已注册账号？"
        label.textColor = UIColor(netHex: 0x999999)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate lazy var passwordIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 38, y: 108 + 80 + 60 + 27 + 30 + 11 , width: 18, height: 18)
        imageView.image = UIImage.loadImage("com_icon_password")
        return imageView
    }()
    
    fileprivate lazy var usernameIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 38, y: 108 + 80 + 60 + 11 , width: 18, height: 18)
        imageView.image = UIImage.loadImage("com_icon_user_18")
        return imageView
    }()
    
    fileprivate lazy var usernameLine: UILabel = {
        var line = UILabel()
        line.backgroundColor = UIColor(netHex: 0x2DD0CF)
        line.alpha = 0.4
        line.frame = CGRect(x: 38, y: self.userNameTextField.y + 40, width: self.view.width - 76, height: 1)
        return line
    }()
    
    fileprivate lazy var passwordLine: UILabel = {
        var line = UILabel()
        line.backgroundColor = UIColor(netHex: 0x2DD0CF)
        line.alpha = 0.4
        line.frame = CGRect(x: 38, y: self.passwordTextField.y + 40, width: self.view.width - 76, height: 1)
        return line
    }()
    
    fileprivate lazy var bgView: UIView = UIView(frame: self.view.frame)
    
    //MARK: - private func
    private func _init() {
        self.title = "JChat"
        self.view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(bgView)
        view.addSubview(headerView)
        
        bgView.addSubview(avatorView)
        bgView.addSubview(tipsLabel)
        bgView.addSubview(userNameTextField)
        bgView.addSubview(passwordTextField)
        bgView.addSubview(loginButton)
        bgView.addSubview(registerButton)
        bgView.addSubview(usernameIcon)
        bgView.addSubview(passwordIcon)
        bgView.addSubview(usernameLine)
        bgView.addSubview(passwordLine)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapView))
        bgView.addGestureRecognizer(tap)
    }
    
    func textFieldDidChanged(_ textField: UITextField) {
        _updateRegisterButton()
    }
    
    func _isUserNameLegal(_ username: String) -> Bool {
        if username.isEmpty {
            MBProgressHUD_JChat.show(text: "用户名不能为空", view: view)
            return false
        }
        if username.length < 4 || username.length > 128 {
            MBProgressHUD_JChat.show(text: "用户名为4-128位字符", view: view)
            return false
        }
        
        let fristCharRegex = "^([a-zA-Z0-9])(.*)$"
        let fristCharPredicate = NSPredicate(format: "SELF MATCHES %@", fristCharRegex)
        if !fristCharPredicate.evaluate(with: username) {
            MBProgressHUD_JChat.show(text: "用户名以字母或数字开头", view: view)
            return false
        }
       
        if username.isContainsChinese {
            MBProgressHUD_JChat.show(text: "用户名不能包含中文字符", view: view)
            return false
        }
        if username.isExpectations {
            return true
        }
        
        MBProgressHUD_JChat.show(text: "用户名包含非法字符", view: view)
        return false
    }
    
    func _isPasswordLegal(_ password: String) -> Bool {
        if password.isEmpty {
            MBProgressHUD_JChat.show(text: "密码不能为空", view: view)
            return false
        }
        if password.length < 4 || password.length > 128 {
            MBProgressHUD_JChat.show(text: "密码为4-128位字符", view: view)
            return false
        }
        return true
    }
    
    func _tapView() {
        view.endEditing(true)
    }
    
    //MARK: - click event
    func _userRegister() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        let username = userNameTextField.text!.trim()
        let password = passwordTextField.text!.trim()
        if !_isUserNameLegal(username.trim()) {
            return
        }
        if !_isPasswordLegal(password.trim()) {
            return
        }
        
        let url = URL(string: "https://api.im.jpush.cn/v1/users/\(username)")
        MBProgressHUD_JChat.showMessage(message: "用户名校验", toView: self.view)
        JCAPIManager.sharedAPI.searchUser(url!) { (data, response, error) in
            let _ = DispatchQueue.main.sync {
                MBProgressHUD_JChat.hide(forView: self.view, animated: true)
                if error == nil {
                    let result = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if result["username"] != nil {
                        MBProgressHUD_JChat.show(text: "用户名重复", view: self.view)
                    } else {
                        let vc = JCRegisterInfoViewController()
                        vc.username = username
                        vc.password = password
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    MBProgressHUD_JChat.show(text: "校验失败，请重试", view: self.view)
                }
            }
        }
    }
    
    func _clickLoginButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func _updateRegisterButton() {
        if (userNameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            registerButton.isEnabled = false
            registerButton.alpha = 0.7
        } else {
            registerButton.isEnabled = true
            registerButton.alpha = 1.0
        }
    }
    
}

extension JCRegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _updateRegisterButton()
        if textField.tag == 1001 {
            usernameLine.alpha = 1.0
            usernameIcon.image = UIImage.loadImage("com_icon_user_18_pre")
        } else {
            passwordLine.alpha = 1.0
            passwordIcon.image = UIImage.loadImage("com_icon_password_pre")
        }
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.avatorView.isHidden = true
            self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 64)
            self.bgView.frame = CGRect(x: 0, y: -100, width: self.view.width, height: self.view.height)
        })
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        _updateRegisterButton()
        if textField.tag == 1001 {
            usernameLine.alpha = 0.4
            usernameIcon.image = UIImage.loadImage("com_icon_user_18")
        } else {
            passwordLine.alpha = 0.4
            passwordIcon.image = UIImage.loadImage("com_icon_password")
        }
        
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
        UIView.animate(withDuration: 0.3) {
            self.avatorView.isHidden = false
            self.headerView.frame = CGRect(x: 0, y: -64, width: self.view.width, height: 64)
            self.bgView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        }
    }
}
