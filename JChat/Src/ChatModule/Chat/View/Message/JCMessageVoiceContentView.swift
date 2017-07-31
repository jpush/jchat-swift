//
//  JCMessageVoiceContentView.swift
//  JChat
//
//  Created by deng on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation

open class JCMessageVoiceContentView: UIView, JCMessageContentViewType {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    deinit {
        JChatAudioPlayerHelper.sharedInstance.stopAudio()
    }

    
    open func apply(_ message: JCMessageType, _ indexPath: IndexPath?) {
        guard let content = message.content as? JCMessageVoiceContent else {
            return
        }
        
        _updateViewLayouts(message.options)
        _data = content.data
        _titleLabel.attributedText = content.attributedText
    }
    
    private func _updateViewLayouts(_ options: JCMessageOptions) {
        guard _alignment != options.alignment else {
            return
        }
        _alignment = options.alignment
        
        let aw = CGFloat(20)
        let tw = bounds.maxX - 8 - aw
        
        if _alignment == .left {
            
            _titleLabel.textColor = UIColor(netHex: 0x999999)
            _titleLabel.textAlignment = .right
            _animationView.image = UIImage.loadImage("chat_voice_receive_icon_3")
            _animationView.animationImages = [
                UIImage.loadImage("chat_voice_receive_icon_1"),
                UIImage.loadImage("chat_voice_receive_icon_2"),
                UIImage.loadImage("chat_voice_receive_icon_3"),
            ].flatMap { $0 }
            
            _animationView.frame = CGRect(x: bounds.minX, y: 3, width: aw, height: 20)
            _titleLabel.frame = CGRect(x: bounds.maxX - tw, y: 3, width: tw, height: 20)
            
        } else {
            
            _titleLabel.textColor = UIColor(netHex: 0x4D9999)
            _titleLabel.textAlignment = .left
            
            _animationView.image = UIImage.loadImage("chat_voice_send_icon_3")
            _animationView.animationImages = [
                UIImage.loadImage("chat_voice_send_icon_1"),
                UIImage.loadImage("chat_voice_send_icon_2"),
                UIImage.loadImage("chat_voice_send_icon_3"),
            ].flatMap { $0 }
            
            _animationView.frame = CGRect(x: bounds.maxX - aw, y: 3, width: aw, height: 20)
            _titleLabel.frame = CGRect(x: bounds.minX, y: 3, width: tw, height: 20)
        }
        
    }
    
    private func _commonInit() {

        _animationView.animationDuration = 0.8
        _animationView.animationRepeatCount = 0
        
        addSubview(_animationView)
        addSubview(_titleLabel)
        _tapGesture()
    }
    
    func _tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(_clickCell))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func _clickCell() {
        if let player = JChatAudioPlayerHelper.sharedInstance.player {
            if player.isPlaying {
                JChatAudioPlayerHelper.sharedInstance.stopAudio()
                return
            }
        }
        JChatAudioPlayerHelper.sharedInstance.delegate = self
        JChatAudioPlayerHelper.sharedInstance.managerAudioWithData(_data!, toplay: true)
        _animationView.startAnimating()
    }
    
    fileprivate lazy var _animationView: UIImageView = UIImageView()
    private lazy var _titleLabel: UILabel = UILabel()
    private var _data: Data?
    
    private var _alignment: JCMessageAlignment = .center
}

extension JCMessageVoiceContentView: JChatAudioPlayerHelperDelegate {
    func didAudioPlayerStopPlay(_ AudioPlayer: AVAudioPlayer) {
        self._animationView.stopAnimating()
    }
    func didAudioPlayerBeginPlay(_ AudioPlayer: AVAudioPlayer) {
        
    }
    func didAudioPlayerPausePlay(_ AudioPlayer: AVAudioPlayer) {
        self._animationView.stopAnimating()
    }
}
