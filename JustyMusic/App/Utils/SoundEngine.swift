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
  
  @Published var track: Track?
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
  
  func start(_ song: Track) {
    self.track = song
    
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(playerDidFinishPlaying),
        name: .AVPlayerItemDidPlayToEndTime,
        object: self.track?.player?.currentItem
      )
  }
  
  @objc func playerDidFinishPlaying(note: NSNotification) {
    print("Audio Finished")
  }
  
  func play() {
    if self.isPlaying { return }
    
    self.track?.player?.play()
    
    setupNowPlaying()
    setupRemoteCommandCenter()
    self.isPlaying = true
  }
  
  func pause() {
    if !self.isPlaying { return }
    
    self.track?.player?.pause()
    self.isPlaying = false
  }
  
  func setupNowPlaying() {
    // Define Now Playing Info
    
    var nowPlayingInfo = [String : Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = self.track?.title
    nowPlayingInfo[MPMediaItemPropertyArtist] = self.track?.artist.name
    
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.track?.player?.currentItem?.asset.duration.seconds
    
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.track?.player?.currentTime().seconds
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.track?.player?.rate
    
    // Set the metadata
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    MPNowPlayingInfoCenter.default().playbackState = .playing
  }
  
  func setupRemoteCommandCenter() {
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
  var source: String
  var liked: Bool
  var artist: SongArtist
  
  @Transiant
  var player: AVPlayer?
  
  init(id: Int, title: String, source: String, liked: Bool, artist: SongArtist) {
    self.id = id
    self.title = title
    self.source = source
    self.liked = liked
    self.artist = artist
    
    guard let url_object = URL(string: self.source) else { fatalError("Missing URL") }
    
    let playerItem = AVPlayerItem(url: url_object)
    
    self.player = AVPlayer(playerItem:playerItem)
  }
  
  mutating func dislike() -> Void {
    self.liked = false
    
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }
  
  mutating func like() -> Void {
    self.liked = true
    
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }
}

struct SongArtist: Decodable, Encodable {
  var id: Int
  var name: String
}
