//
//  Greeting.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import Foundation
import SwiftUI

struct MainTemplate: View {
  
  @EnvironmentObject var router: Router
  @EnvironmentObject var userSession: SessionManager
  
  @State private var selectedView: Router.Route = .main
  
  var body: some View {
    VStack {
      
      TabView(selection: $selectedView) {
        
        Main()
          .tabItem {
            Label("Медиатека", systemImage: "music.note.house")
          }
          .tag(Router.Route.main)
        
        Account()
          .tabItem {
            Label("Поиск", systemImage: "magnifyingglass")
          }
          .tag(Router.Route.search)
        
        Account()
          .tabItem {
            Label("Аккаунт", systemImage: "person.crop.circle")
          }
          .tag(Router.Route.account)
        
      }
      
    }.navigationBarBackButtonHidden()
    
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
