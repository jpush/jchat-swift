//
//  JCMessageFileContentView.swift
//  JChat
//
//  Created by deng on 2017/7/20.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCMessageFileContentView: UIView, JCMessageContentViewType {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    open func apply(_ message: JCMessageType, _ indexPath: IndexPath?) {
        guard let content = message.content as? JCMessageFileContent else {
            return
        }
        _message = message
        _delegate = content.delegate
        _fileData = content.data
        _fileName = content.fileName
        _fileType = content.fileType
        _fileSize = content.fileSize
        
        _updateFileTypeIcon(_fileType)

        _fileNameLabel.text = _fileName
        _fileSizeLabel.text = _fileSize
        if _fileData != nil {
            _fileStatusLabel.text = "己下载"
        } else {
            _fileStatusLabel.text = "未下载"
        }
    }
    
    private func _updateFileTypeIcon(_ fileType: String?) {
        if let type = fileType {
            switch type.fileFormat() {
            case .document:
                _imageView.image = UIImage.loadImage("com_icon_file_file")
            case .video:
                _imageView.image = UIImage.loadImage("com_icon_file_video")
            case .photo:
                _imageView.image = UIImage.loadImage("com_icon_file_photo")
            case .voice:
                _imageView.image = UIImage.loadImage("com_icon_file_music")
            default:
                _imageView.image = UIImage.loadImage("com_icon_file_other")
            }
        } else {
            _imageView.image = UIImage.loadImage("com_icon_file_other")
        }
    }
    
    private weak var _delegate: JCMessageDelegate?
    
    private var _fileData: Data?
    private var _fileName: String?
    private var _fileType: String?
    private var _fileSize: String?
    private var _message: JCMessageType!
    
    private var _imageView: UIImageView!
    private lazy var _line: UILabel = UILabel()
    private lazy var _fileNameLabel = UILabel()
    private lazy var _fileSizeLabel = UILabel()
    private lazy var _fileStatusLabel = UILabel()
    
    private func _commonInit() {
        _tapGesture()
        _imageView = UIImageView(frame: CGRect(x: 12, y: 18, width: 40, height: 40))
        _imageView.layer.cornerRadius = 2.5
        _imageView.layer.masksToBounds = true
        self.addSubview(_imageView)
        
        _fileNameLabel.frame = CGRect(x: 68, y: 18, width: 120, height: 40)
        _fileNameLabel.numberOfLines = 0
        _fileNameLabel.font = UIFont.systemFont(ofSize: 16)
        _fileNameLabel.textColor = UIColor(netHex: 0x5a5a5a)
        _fileNameLabel.text = "极光IM帮助文档.docx"
        self.addSubview(_fileNameLabel)
        
        _fileStatusLabel.frame = CGRect(x: 103, y: 75, width: 85, height: 20)
        _fileStatusLabel.textAlignment = .right
        _fileStatusLabel.font = UIFont.systemFont(ofSize: 10)
        _fileStatusLabel.textColor = UIColor(netHex: 0x989898)
        _fileStatusLabel.text = "未下载"
        self.addSubview(_fileStatusLabel)
        
        _fileSizeLabel.frame = CGRect(x: 12, y: 75, width: 85, height: 20)
        _fileSizeLabel.font = UIFont.systemFont(ofSize: 10)
        _fileSizeLabel.textColor = UIColor(netHex: 0x989898)
        _fileSizeLabel.text = "100K"
        self.addSubview(_fileSizeLabel)
        
        _line.frame = CGRect(x: 12, y: 74, width: 176, height: 1)
        _line.layer.backgroundColor = UIColor(netHex: 0xE8E8E8).cgColor
        self.addSubview(_line)
    }
    
    func _tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(_clickCell))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func _clickCell() {
        _delegate?.message?(message: _message, fileData: _fileData, fileName: _fileName, fileType: _fileType)
    }
}
