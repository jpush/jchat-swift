//
//  JChatRecordVoiceHelper.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/22.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation

@objc public protocol JChatRecordVoiceHelperDelegate: NSObjectProtocol {
    @objc optional func beyondLimit(_ time: TimeInterval)
    
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


let maxRecordTime = 60.0

typealias CompletionCallBack = () -> Void

class JChatRecordVoiceHelper: NSObject {
    
    weak var delegate: JChatRecordVoiceHelperDelegate?
    
    var stopRecordCompletion: CompletionCallBack?
    var startRecordCompleted: CompletionCallBack?
    var cancelledDeleteCompletion: CompletionCallBack?
    
    
    var recorder: AVAudioRecorder?
    var recordPath: String?
    var recordDuration: String?
    var recordProgress: Float?
    var theTimer: Timer?
    var currentTimeInterval: TimeInterval?
    
    weak var updateMeterDelegate: JChatRecordingView?
    
    override init() {
        super.init()
    }
    
    deinit {
        self.stopRecord()
        self.recordPath = nil
    }
    
    func updateMeters() {
        if self.recorder == nil {
            return
        }
        self.currentTimeInterval = self.recorder?.currentTime
        
        self.recordProgress = self.recorder?.peakPower(forChannel: 0)
        self.updateMeterDelegate?.setPeakPower(self.recordProgress!)
        self.updateMeterDelegate?.setTime(currentTimeInterval!)
        
        if self.currentTimeInterval > maxRecordTime {
            self.stopRecord()
            delegate?.beyondLimit?(currentTimeInterval!)
            if self.stopRecordCompletion != nil {
                DispatchQueue.main.async(execute: self.stopRecordCompletion!)
                self.recorder?.updateMeters()
            }
        }
    }
    
    func getVoiceDuration(_ recordPath:String) {
        do {
            let player:AVAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: recordPath))
            player.play()
            self.recordDuration = "\(player.duration)"
        } catch let error as NSError {
            print("get AVAudioPlayer is fail \(error)")
        }
    }
    
    func resetTimer() {
        if self.theTimer == nil {
            return
        } else {
            self.theTimer!.invalidate()
            self.theTimer = nil
        }
    }
    
    func cancelRecording() {
        if self.recorder == nil { return }
        
        if self.recorder?.isRecording != false {
            self.recorder?.stop()
        }
        
        self.recorder = nil
    }
    
    func stopRecord() {
        self.cancelRecording()
        self.resetTimer()
    }
    
    func startRecordingWithPath(_ path:String, startRecordCompleted:@escaping CompletionCallBack) {
        print("Action - startRecordingWithPath:")
        self.startRecordCompleted = startRecordCompleted
        self.recordPath = path
        
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try audioSession.setActive(true)
        } catch let error as NSError {
            print("could not set session active")
            print(error.localizedDescription)
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleIMA4 as UInt32),
            AVNumberOfChannelsKey: 1 as AnyObject,
            AVSampleRateKey : 16000.0 as AnyObject
        ]
        
        do {
            self.recorder = try AVAudioRecorder(url: URL(fileURLWithPath: self.recordPath!), settings: recordSettings)
            self.recorder!.delegate = self
            self.recorder!.isMeteringEnabled = true
            self.recorder!.prepareToRecord()
            self.recorder?.record(forDuration: 160.0)
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
        if ((self.recorder?.record()) != false) {
            self.resetTimer()
            self.theTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(JChatRecordVoiceHelper.updateMeters), userInfo: nil, repeats: true)
        } else {
            print("fail record")
        }
        
        if self.startRecordCompleted != nil {
            DispatchQueue.main.async(execute: self.startRecordCompleted!)
        }
    }
    
    func finishRecordingCompletion() {
        self.stopRecord()
        self.getVoiceDuration(self.recordPath!)
        
        if self.stopRecordCompletion != nil {
            DispatchQueue.main.async(execute: self.stopRecordCompletion!)
        }
    }
    
    func cancelledDeleteWithCompletion() {
        self.stopRecord()
        if self.recordPath != nil {
            let fileManager:FileManager = FileManager.default
            if fileManager.fileExists(atPath: self.recordPath!) == true {
                do {
                    try fileManager.removeItem(atPath: self.recordPath!)
                } catch let error as NSError {
                    print("can no to remove the voice file \(error.localizedDescription)")
                }
            } else {
                if self.cancelledDeleteCompletion != nil {
                    DispatchQueue.main.async(execute: self.cancelledDeleteCompletion!)
                }
            }
            
        }
    }
    // test player
    func playVoice(_ recordPath:String) {
        do {
            print("\(recordPath)")
            let player:AVAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: recordPath))
            player.volume = 1
            player.delegate = self
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
            
        } catch let error as NSError {
            print("get AVAudioPlayer is fail \(error)")
        }
    }
}

extension JChatRecordVoiceHelper : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}

extension JChatRecordVoiceHelper : AVAudioRecorderDelegate {
    
}
