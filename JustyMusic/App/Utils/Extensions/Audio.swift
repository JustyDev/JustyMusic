//
//  Audio.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 09.12.2023.
//

import Foundation
import SwiftUI
import AVFoundation

extension AVAudioPlayerNode {
  var currentTime: TimeInterval {
    get {
      if let nodeTime: AVAudioTime = self.lastRenderTime, let playerTime: AVAudioTime = self.playerTime(forNodeTime: nodeTime) {
        return Double(playerTime.sampleTime) / playerTime.sampleRate
      }
      return 0
    }
  }
}

extension AVAudioFile {
  
  var duration: TimeInterval{
    let sampleRateSong = Double(processingFormat.sampleRate)
    let lengthSongSeconds = Double(length) / sampleRateSong
    return lengthSongSeconds
  }
  
}

extension AVPlayer {
  var isPlaying: Bool {
    return rate != 0 && error == nil
  }
}
