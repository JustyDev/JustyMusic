//
//  SessionManager.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 07.12.2023.
//

import Foundation

class SessionManager: ObservableObject {
  
  @Published var userSession: UserSession? = nil
  
  public func isAuth() -> Bool {
    return self.userSession == nil
  }
  
  public func saveUserSession(userSession: UserSession) {
    let encoder = JSONEncoder()
    if let encodedUser = try?encoder.encode(userSession) {
      UserDefaults.standard.set(encodedUser, forKey: "user_session")
      self.userSession = userSession
    }
  }
  
  public func clear() {
    UserDefaults.standard.removeObject(forKey: "user_session")
    self.userSession = nil
  }
  
  init() {
    if let savedUserData = UserDefaults.standard.object(forKey: "user_session") as? Data {
      let decoder = JSONDecoder()
      let userSession = try? decoder.decode(UserSession.self, from: savedUserData)
      
      if userSession == nil {
        return
      }
      
      if ((userSession?.session.last_active ?? 0) + (userSession?.session.expires ?? 0 ) > unixTime() || userSession?.session.expires == 0) {
        self.userSession = userSession
      }
      
    }
  }
  
}

struct UserSessionResponse: Response {
  var response: UserSession
}

struct UserSession: Encodable, Decodable, Response {
  var id: Int
  var username: String
  var session: Session
}

struct Session: Encodable, Decodable {
  var id: Int
  var key: String
  var expires: Int
  var created_time: Int
  var last_active: Int
}
