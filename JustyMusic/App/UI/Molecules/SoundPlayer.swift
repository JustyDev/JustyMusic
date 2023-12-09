//
//  SoundPlayer.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 09.12.2023.
//

import SwiftUI

struct SoundPlayer: View {
  
  @EnvironmentObject var sEngine: SoundEngine
  
  var body: some View {
    
    if sEngine.track == nil {
      EmptyView()
    } else {
      
      HStack {
        Rectangle()
          .fill(hexColor(hex: "#151515"))
          .frame(width: 45, height: 45)
          .background(hexColor(hex: "#151515"))
          .cornerRadius(15)
          .padding(.trailing, 5)
        
        VStack {
          Text(sEngine.track!.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text(sEngine.track!.artist.name)
            .colorMultiply(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.system(size: 15))
        }
        
        Spacer()
        
        Button(action: {
          if sEngine.track!.liked {
            sEngine.track!.dislike()
          } else {
            sEngine.track!.like()
          }
        }) {
          Image(systemName: sEngine.track!.liked ? "heart.fill" : "heart")
            .foregroundColor(sEngine.track!.liked ? .red : .gray)
            .font(Font.system(size: 20))
            .padding(10)
            .padding(.trailing, -5)
        }
        
        Button(action: {
          if !sEngine.isPlaying {
            sEngine.play()
          } else {
            sEngine.pause()
          }
        }) {
          Image(systemName: sEngine.isPlaying ? "pause.fill" : "play.fill")
            .foregroundColor(.white)
            .font(Font.system(size: 21))
            .padding(10)
            .padding(.leading, -5)
        }
      }
      
      .padding(.vertical, 10)
      .padding(.horizontal, 15)
      //.background(hexColor(hex: "#101010"))
    }
  }
}

#Preview {
  
  let sEngine = SoundEngine()
  
  sEngine.start(
    Track(
      id: 1,
      title: "Розовый вечер",
      source: "https://justydev.ru/song.mp3",
      liked: false,
      artist: SongArtist(
        id: 1,
        name: "Amirchik"
      )
    )
  )
  
  return VStack {
    SoundPlayer()
  }.environmentObject(sEngine)
}
