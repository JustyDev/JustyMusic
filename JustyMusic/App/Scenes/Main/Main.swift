//
//  Main.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 08.12.2023.
//

import SwiftUI

struct Main: View {
  
  @EnvironmentObject var router: Router
  @EnvironmentObject var network: NetworkManager
  @EnvironmentObject var userSession: SessionManager
  @EnvironmentObject var sEngine: SoundEngine
  
  @State private var loading = true
  @State private var playlist: UserTracksByPlaylist?
  @State private var error: ResponseError?
  
  func load() {
    network.tracksByPlaylist(0) { result in
      if case .success(let res) = result {
        let res = res as! UserTracksByPlaylistResponse
        self.playlist = res.response
        
      }
      
      if case .failure(let res) = result {
        
        self.error = res
        
      }
      
      loading = false
    }
  }
  
  @ViewBuilder
  var body: some View {
    return ZStack {
      if loading {
        Preloader()
      } else {
        
        if self.error != nil {
          
          Text("Ошибка при загрузке: " + self.error!.error.message)
            .multilineTextAlignment(.center)
            .colorMultiply(.red)
          
        } else {
          
          VStack {
            
            
            
            ScrollView {
              
              VStack(spacing: 0) {
                
                VStack {
                  Text("Моя медиатека")
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                    .font(Font.system(size: 37, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                }
                
                ForEach(self.playlist!.tracks, id: \.id) { track in
                  
                  Button(action: {
                    sEngine.start(track)
                  }) {
                    
                    HStack {
                      Rectangle()
                        .fill(hexColor(hex: "#101010"))
                        .frame(width: 50, height: 50)
                        .background(hexColor(hex: "#101010"))
                        .cornerRadius(15)
                        .padding(.trailing, 5)
                      
                      VStack(alignment: .leading) {
                        Text(track.title)
                          .bold()
                        
                        Text(track.performers)
                          .colorMultiply(.gray)
                          .frame(alignment: .leading)
                      }
                      
                      Spacer()
                      
                      Image(systemName: "waveform")
                        .foregroundColor(.gray)
                        .opacity((sEngine.isPlaying && sEngine.track?.id == track.id) ? 1 : 0)
                       
                      Menu {
                        Button("Order Now") {
                          
                        }
                        Button("Adjust Order") {
                          
                        }
                      } label: {
                        Image(systemName: "ellipsis")
                          .foregroundColor(.gray)
                          .padding(.all, 10)
                          .opacity(1)
                      }
                      
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    
                  }
                  .buttonStyle(TrackStyle())
                  
                }
                
                Text(String(self.playlist!.tracks.count) + " трека")
                  .multilineTextAlignment(.center)
                  .padding(.top, 15)
                  .colorMultiply(.gray)
                  .font(Font.system(size: 14))
                
              }
              .refreshable {
                load()
              }
            }
            
            Spacer()
            
            SoundPlayer()
            
          }
          .padding(.vertical, 10)
        }
      }
    }.onAppear {
      load()
    }
  }
}

struct TrackStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background(configuration.isPressed ? hexColor(hex: "#050505") : Color.black.opacity(0))
  }
}

#Preview {
  let sessionManager = SessionManager()
  
  let userSession = UserSession(
    id: 1,
    username: "Justy",
    number: "+7 (920) 085 39-75",
    session: Session(
      id: 1,
      key: "jbvRokziH4n8q9IJXAPN26W70ZfOawhS",
      expires: 0,
      created_time: unixTime(),
      last_active: unixTime()
    )
  )
  
  sessionManager.saveUserSession(userSession: userSession)
  
  return RouterView {
    MainTemplate()
  }
  .environmentObject(sessionManager)
  .environmentObject(SoundEngine())
  .environmentObject(NetworkManager())
}
