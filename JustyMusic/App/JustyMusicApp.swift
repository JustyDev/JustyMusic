//
//  JustyMusicApp.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import SwiftUI

@main
struct JustyMusicApp: App {
  
  var sessionManager = SessionManager()
  
  var body: some Scene {
    WindowGroup {
      RouterView {
        if !sessionManager.isAuth() {
          Greeting()
        } else {
          MainTemplate()
        }
      }
      .environmentObject(NetworkManager())
      .environmentObject(SoundEngine())
    }.environmentObject(sessionManager)
  }
  
}

#Preview {
  let sessionManager = SessionManager()
  
  sessionManager.clear()
  
//  let userSession = UserSession(
//    id: 1,
//    username: "Justy",
//    session: Session(
//      id: 1,
//      key: "some_string",
//      expires: 0,
//      created_time: unixTime(),
//      last_active: unixTime()
//    )
//  )
//  
//  sessionManager.saveUserSession(userSession: userSession)
  
  return RouterView {
    if !sessionManager.isAuth() {
      Greeting()
    } else {
      MainTemplate()
    }
  }
  .environmentObject(NetworkManager())
  .environmentObject(SoundEngine())
  .environmentObject(sessionManager)
}
