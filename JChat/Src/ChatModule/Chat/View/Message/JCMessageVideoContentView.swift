//
//  JCMessageVideoContentView.swift
//  JChat
//
//  Created by JIGUANG on 2017/3/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

open class JCMessageVideoContentView: UIImageView, JCMessageContentViewType {
    
    public override init(image: UIImage?) {
        super.init(image: image)
        _commonInit()
    }
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        _commonInit()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    open func apply(_ message: JCMessageType) {
        guard let content = message.content as? JCMessageVideoContent else {
            return
        }
        _message = message
        _delegate = content.delegate
        
        weak var weakSelf = self
        
        percentLabel.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        if message.options.state == .sending {
            percentLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            percentLabel.isHidden = false
            percentLabel.textColor = .white
            content.uploadVideo = { (percent: Float ) -> Void  in
                DispatchQueue.main.async {
                    let p = Int(percent * 100)
                    weakSelf?.percentLabel.text = "\(p)%"
                    if percent == 1.0 {
                        weakSelf?.percentLabel.isHidden = true
                        weakSelf?.percentLabel.text = ""
                    }
                }
            }
        } else {
            percentLabel.textColor = .clear
            percentLabel.backgroundColor = .clear
            _data = content.data
        }
        
        if content.image != nil {
            DispatchQueue.main.async {
                self.image = content.image
            }
        }else{
            self.image = UIImage.createImage(color: UIColor(netHex: 0xCDD0D1), size: self.size)
            content.videoContent?.videoThumbImageData({ (data, id, error) in
                if data != nil {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data!)
                    }
                }
            })
        }
        _playImageView.center = CGPoint(x: self.width / 2, y: self.height / 2)
    }

    private weak var _delegate: JCMessageDelegate?
    private var _data: Data?
    private var _playImageView: UIImageView!
    private var _message: JCMessageType!
    
    private lazy var percentLabel: UILabel = {
        var percentLabel = UILabel(frame: CGRect(x: 20, y: 40, width: 50, height: 20))
        percentLabel.isUserInteractionEnabled = false
        percentLabel.textAlignment = .center
        percentLabel.textColor = .white
        percentLabel.font = UIFont.systemFont(ofSize: 17)
        return percentLabel
    }()
    
    private func _commonInit() {
        isUserInteractionEnabled = true
        layer.cornerRadius = 2
        layer.masksToBounds = true
        _tapGesture()
        _playImageView = UIImageView(frame: CGRect(x: 0, y: 50, width: 41, height: 41))
        _playImageView.image = UIImage.loadImage("com_icon_play")
        addSubview(_playImageView)
        addSubview(self.percentLabel)
    }
    
    func _tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(_clickCell))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    @objc func _clickCell() {
        
        percentLabel.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        percentLabel.textColor = .clear
        percentLabel.backgroundColor = .clear
        if _data != nil {
            printLog("local is have video data.")
            _delegate?.message?(message: _message, videoData: _data)
        }else{
            guard let content = _message.content as? JCMessageVideoContent else {
                return
            }
            percentLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            percentLabel.isHidden = false
            percentLabel.textColor = .white
            weak var weakSelf = self
            content.videoContent?.videoData(progress: { (percent, msgid) in
                let p = Int(percent * 100)
                weakSelf?.percentLabel.text = "\(p)%"
            }, completionHandler: { (data, id, error) in
                weakSelf?._data = data;
                weakSelf?.percentLabel.isHidden = true
                weakSelf?.percentLabel.text = ""
                weakSelf?._delegate?.message?(message: self._message, videoData: weakSelf?._data)
            })
            
            content.videoFileContent?.fileData(progress: { (percent, msgid) in
                DispatchQueue.main.async {
                    let p = Int(percent * 100)
                    weakSelf?.percentLabel.text = "\(p)%"
                }
            }, completionHandler: { (data, id, error) in
                DispatchQueue.main.async {
                    weakSelf?._data = data;
                    weakSelf?.percentLabel.isHidden = true
                    weakSelf?.percentLabel.text = ""
                    weakSelf?._delegate?.message?(message: self._message, videoData: weakSelf?._data)
                }
            })
        }
    }
}
