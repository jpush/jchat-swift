//
//  JChatAudioPlayerHelper.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation

protocol JChatAudioPlayerHelperDelegate:NSObjectProtocol {
  func didAudioPlayerBeginPlay(AudioPlayer:AVAudioPlayer)
  func didAudioPlayerStopPlay(AudioPlayer:AVAudioPlayer)
  func didAudioPlayerPausePlay(AudioPlayer:AVAudioPlayer)
}

class JChatAudioPlayerHelper: NSObject {

  var player:AVAudioPlayer!
  weak var delegate:JChatAudioPlayerHelperDelegate?
  
  class var sharedInstance: JChatAudioPlayerHelper {
    struct Static {
      static var onceToken: dispatch_once_t = 0
      static var instance: JChatAudioPlayerHelper? = nil
    }
    dispatch_once(&Static.onceToken) {
      Static.instance = JChatAudioPlayerHelper()
    }
    return Static.instance!
  }
  
  override init() {
    super.init()
    
  }

  
  func managerAudioWithData(data:NSData, toplay:Bool) {
    if toplay {
      self.playAudioWithData(data)
    } else {
      self.pausePlayingAudio()
    }
  }
  
  func playAudioWithData(voiceData:NSData) {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    } catch let error as NSError {
      print("set category fail \(error)")
    }
    
    if self.player != nil {
      self.player.stop()
      self.player = nil
    }
    
    do {
      let pl:AVAudioPlayer = try AVAudioPlayer(data: voiceData)
      pl.delegate = self
      pl.play()
      self.player = pl
    } catch let error as NSError {
      print("alloc AVAudioPlayer with voice data fail with error \(error)")
    }
    
    UIDevice.currentDevice().proximityMonitoringEnabled = true
  }

  func pausePlayingAudio() {
    self.player?.pause()
  }
  
  func stopAudio() {
    if self.player.playing {
      self.player.stop()
    }
    
    UIDevice.currentDevice().proximityMonitoringEnabled = false
    self.delegate?.didAudioPlayerStopPlay(self.player)
  }
}


extension JChatAudioPlayerHelper:AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
    self.stopAudio()
  }
}
