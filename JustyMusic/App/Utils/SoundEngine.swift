//
//  Player.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 08.12.2023.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit
import MediaPlayer

class SoundEngine: ObservableObject {
  
  var queue: [Track] = []
  var history: [Track] = []
  
  @MainActor @Published var track: Track?
  @Published var isPlaying: Bool = false
  
  init() {
    let session = AVAudioSession.sharedInstance()
    
    do {
      try session.setCategory(.playback, mode: .default, options: .allowAirPlay)
      try session.setActive(true)
    } catch {
      print(error)
    }
  }
  
  @MainActor func start(_ track: Track, _ start: Bool = true) {
    
    self.isPlaying = false
  
    self.track = track
    
    Task {
      self.track!.prepare()
      
      if start {
        self.play()
      }
    }
  }
  
  @MainActor func stop() {
    self.pause()
    self.track = nil
  }
  
  @objc func playerDidFinishPlaying(note: NSNotification) {
    print("Audio Finished")
  }
  
  @MainActor func play() {
    if self.isPlaying { return }
    
    self.track?.player?.play()
    
    setupNowPlaying()
    setupRemoteCommandCenter()
    self.isPlaying = true
  }
  
  @MainActor func pause() {
    if !self.isPlaying { return }
    
    self.track?.player?.pause()
    self.isPlaying = false
  }
  
  @MainActor func setupNowPlaying() {
    // Define Now Playing Info
    
    var nowPlayingInfo = [String : Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = self.track?.title
    nowPlayingInfo[MPMediaItemPropertyArtist] = self.track?.performers
    
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.track?.player?.currentItem?.asset.duration.seconds
    
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.track?.player?.currentTime().seconds
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.track?.player?.rate
    
    // Set the metadata
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    MPNowPlayingInfoCenter.default().playbackState = .playing
  }
  
  @MainActor func setupRemoteCommandCenter() {
    let commandCenter = MPRemoteCommandCenter.shared();
    commandCenter.playCommand.isEnabled = true
    commandCenter.playCommand.addTarget {event in
      self.play()
      return .success
    }
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget {event in
      self.pause()
      return .success
    }
    
    commandCenter.likeCommand.isEnabled = true
    commandCenter.likeCommand.addTarget {event in
      self.track?.like()
      return .success
    }
    
    commandCenter.dislikeCommand.isEnabled = true
    commandCenter.dislikeCommand.addTarget {event in
      self.track?.dislike()
      return .success
    }
  }
}


struct Track: Decodable, Encodable {
  var id: Int
  var title: String
  var performers: String
  var is_explicit: Bool
  var is_liked: Bool
  
  @Transiant
  var player: AVPlayer?
  
  init(id: Int, title: String, performers: String, is_explicit: Bool, is_liked: Bool) {
    self.id = id
    self.title = title
    self.performers = performers
    self.is_explicit = is_explicit
    self.is_liked = is_liked
  }
  
  mutating func prepare() {
    guard let url_object = URL(string: Config.API_URL + "tracks/listen?track_id=" + String(self.id)) else { fatalError("Missing URL") }
    
    let playerItem = AVPlayerItem(url: url_object)
    
    self.player = AVPlayer(playerItem:playerItem)
  }
  
  mutating func dislike() -> Void {
    self.is_liked = false
    
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }
  
  mutating func like() -> Void {
    self.is_liked = true
    
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }
}
