//
//  JCVideoManager.swift
//  JChat
//
//  Created by deng on 2017/4/26.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class JCVideoManager: NSObject {
    
    static func playVideo(data: Data, currentViewController: UIViewController) {
        let  playVC = AVPlayerViewController()
        
        let filePath = "\(NSHomeDirectory())/Documents/abcd.MOV"
        
        if JCVideoManager.saveFileToLocal(data: data, savaPath: filePath) {
            let url = URL(fileURLWithPath: filePath)
            let player = AVPlayer(url: url)
            playVC.player = player
            currentViewController.present(playVC, animated: true, completion: nil)
        }
    }
    
    static func getFristImage(data: Data) -> UIImage? {
        let filePath = "\(NSHomeDirectory())/Documents/getImage.MOV"
        if !JCVideoManager.saveFileToLocal(data: data, savaPath: filePath) {
            return nil
        }
        let videoURL = URL(fileURLWithPath: filePath)
        let avAsset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0,600)
        var actualTime = CMTimeMake(0,0)
        do {
            let imageRef = try generator.copyCGImage(at: time, actualTime: &actualTime)
            let frameImg = UIImage(cgImage: imageRef)
            return frameImg
        } catch {
            return UIImage.createImage(color: .gray, size: CGSize(width: 160, height: 120))
        }
    }
    
    static func saveFileToLocal(data: Data, savaPath: String) -> Bool {
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: savaPath)
        if exist {
            try! fileManager.removeItem(atPath: savaPath)
        }
        if !fileManager.createFile(atPath: savaPath, contents: data, attributes: nil) {
            return false
        }
        return true
    }

}
