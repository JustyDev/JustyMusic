//
//  SoundPlayer.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 09.12.2023.
//

import SwiftUI
import AVFoundation

struct SoundPlayer: View {
  
  @EnvironmentObject var sEngine: SoundEngine
  
  @State private var dragAmount = CGSize.zero
  @State private var isFully = false
  
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
        
        VStack(alignment: .leading) {
          Text(sEngine.track!.title)
            .bold()
          
          Text(sEngine.track!.performers)
            .colorMultiply(.gray)
            .frame(alignment: .leading)
        }
        
        Spacer()
        
        Button(action: {
          if sEngine.track!.is_liked {
            sEngine.track!.dislike()
          } else {
            sEngine.track!.like()
          }
        }) {
          Image(systemName: sEngine.track!.is_liked ? "heart.fill" : "heart")
            .foregroundColor(sEngine.track!.is_liked ? .red : .gray)
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
      .contentShape(Rectangle())
      .onTapGesture {
        self.isFully = true
      }
      .presentationBackground(.thinMaterial)
      .simultaneousGesture(
        DragGesture(minimumDistance: 5)
          .onChanged { value in
            let height = value.translation.height
            if height > 0 {
              dragAmount = CGSize(width: 0, height: height <= 50 ? height : 50)
            }
          }
          .onEnded { value in
            
            if value.translation.height < -50 {
              self.isFully = true
            }
            
            if value.translation.height > 50 {
              sEngine.stop()
              UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            
            dragAmount = .zero
          }
      )
      .offset(dragAmount)
      .animation(.linear(duration: 0.1), value: dragAmount)
      .fullScreenSheet(isPresented: $isFully) {
        FullScreenPlayer().environmentObject(sEngine)
      }
    }
  }
}

struct FullScreenPlayer: View {
  
  @EnvironmentObject var sEngine: SoundEngine
  
  var body: some View {
    ZStack(alignment: .top) {
      RoundedRectangle(cornerRadius: 40)
        .fill(hexColor(hex: "#101010"))
      
      VStack {
        Text(String(sEngine.track?.player?.currentTime().seconds ?? 0))
          .font(.largeTitle)
          .padding(.all, 30)
          .multilineTextAlignment(.center)
      }
    }
  }
}

#Preview {
  
  let sEngine = SoundEngine()
  
  sEngine.start(
    Track(
      id: 2,
      title: "Survivor",
      performers: "Tim Haperlin",
      is_explicit: false,
      is_liked: true
    ),
    false
  )
  
  return VStack {
    Spacer()
    SoundPlayer()
    Rectangle()
      .opacity(0)
      .frame(width: .infinity, height: 70)
  }.environmentObject(sEngine)
}
