//
//  JChatRecordVoiceHelper.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/22.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation

let maxRecordTime = 60.0

typealias CompletionCallBack = () -> Void

class JChatRecordVoiceHelper: NSObject {
  var stopRecordCompletion:CompletionCallBack?
  var startRecordCompleted:CompletionCallBack?
  var cancelledDeleteCompletion:CompletionCallBack?


  var recorder:AVAudioRecorder?
  var recordPath:String?
  var recordDuration:String?
  var recordProgress:Float?
  var theTimer:NSTimer?
  var currentTimeInterval:NSTimeInterval?

  weak var updateMeterDelegate:JChatRecordingView?
  override init() {
    super.init()
  }
  
   deinit {
    self.stopRecord()
    self.recordPath = nil
  }
  
  func updateMeters() {
    if self.recorder == nil { return }
    self.currentTimeInterval = self.recorder?.currentTime

    self.recordProgress = self.recorder?.peakPowerForChannel(0)
    self.updateMeterDelegate?.setPeakPower(self.recordProgress!)
    
    if self.currentTimeInterval > maxRecordTime {
      self.stopRecord()
      if self.stopRecordCompletion != nil {
        dispatch_async(dispatch_get_main_queue(), self.stopRecordCompletion!)
        self.recorder?.updateMeters()
      }
    }
  }
  
  func getVoiceDuration(recordPath:String) {
    do {
      let player:AVAudioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: recordPath))
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
    
    if self.recorder?.recording != false {
      self.recorder?.stop()
    }
    
    self.recorder = nil
  }

  func stopRecord() {
    self.cancelRecording()
    self.resetTimer()
  }
  
  func startRecordingWithPath(path:String, startRecordCompleted:CompletionCallBack) {
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
      AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleIMA4),
      AVNumberOfChannelsKey: 1,
      AVSampleRateKey : 16000.0
    ]
    
    do {
      self.recorder = try AVAudioRecorder(URL: NSURL.fileURLWithPath(self.recordPath!), settings: recordSettings)
      self.recorder!.delegate = self
      self.recorder!.meteringEnabled = true
      self.recorder!.prepareToRecord()
      self.recorder?.recordForDuration(160.0)
    } catch let error as NSError {
      recorder = nil
      print(error.localizedDescription)
    }
    
    if ((self.recorder?.record()) != false) {
      self.resetTimer()
      self.theTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(JChatRecordVoiceHelper.updateMeters), userInfo: nil, repeats: true)
    } else {
      print("fail record")
    }
    
    if self.startRecordCompleted != nil {
      dispatch_async(dispatch_get_main_queue(), self.startRecordCompleted!)
    }
  }
  
  func finishRecordingCompletion() {
    self.stopRecord()
    self.getVoiceDuration(self.recordPath!)
    
    if self.stopRecordCompletion != nil {
      dispatch_async(dispatch_get_main_queue(), self.stopRecordCompletion!)
    }
  }
  
  func cancelledDeleteWithCompletion() {
    self.stopRecord()
    if self.recordPath != nil {
      let fileManager:NSFileManager = NSFileManager.defaultManager()
      if fileManager.fileExistsAtPath(self.recordPath!) == true {
        do {
          try fileManager.removeItemAtPath(self.recordPath!)
        } catch let error as NSError {
          print("can no to remove the voice file \(error.localizedDescription)")
        }
      } else {
        if self.cancelledDeleteCompletion != nil {
          dispatch_async(dispatch_get_main_queue(), self.cancelledDeleteCompletion!)
        }
      }
      
    }
  }
// test player
  func playVoice(recordPath:String) {
    do {
      print("\(recordPath)")
      let player:AVAudioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: recordPath))
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
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
    print("finished playing \(flag)")
    
  }
  
  func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
    if let e = error {
      print("\(e.localizedDescription)")
    }
  }
}

extension JChatRecordVoiceHelper : AVAudioRecorderDelegate {
  
}



