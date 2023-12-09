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
  
  var body: some View {
    
    return VStack {
      
      ScrollView {
        VStack {
          Text("Моя медиатека")
            .padding(.top, 20)
            .padding(.bottom, 5)
            .font(Font.system(size: 37, weight: .heavy))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        Button("Розовый вечер") {
          
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
          
          sEngine.play()
        }.padding(.all, 10)
        
        Button("Survival") {
          sEngine.start(
            Track(
              id: 2,
              title: "Survival",
              source: "https://justydev.ru/song2.mp3",
              liked: true,
              artist: SongArtist(
                id: 2,
                name: "Tim haperlin"
              )
            )
          )
          
          sEngine.play()
        }.padding(.all, 10)
      }
      .padding(.horizontal, 20)
      
      Spacer()
      
      SoundPlayer()
      
    }
    .padding(.vertical, 10)
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
      key: "some_string",
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
