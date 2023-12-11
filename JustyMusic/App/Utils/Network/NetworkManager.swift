//
//  NetworkManager.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 06.12.2023.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
  
  @Published var regStep2State: RegisterCodeResponse?
  @Published var regStep3State: RegisterSilentCheckCodeResponse?
  
  typealias HandlerRegisterCode = (Result<Response, ResponseError>) -> Void
  
  func sendRegisterCode(_ number: String, then handler: @escaping Net.Handler) {
    Net.request(
      url: "auth/register",
      method: "GET",
      data: [
        "phone_number": number
      ],
      decoder: RegisterCodeResponse.self,
      then: { result in
        
        if case .success(let res) = result {
          self.regStep2State = res as? RegisterCodeResponse
        }
        
        handler(result)
      }
    )
    
  }
  
  func silentCheckCode(_ number: String, _ code: String, then handler: @escaping Net.Handler) {
    Net.request(
      url: "auth/register",
      method: "PUT",
      data: [
        "phone_number": number,
        "code": code
      ],
      decoder: RegisterSilentCheckCodeResponse.self,
      then: { result in
        
        if case .success(let res) = result {
          self.regStep3State = res as? RegisterSilentCheckCodeResponse
        }
        
        handler(result)
      }
    )
  }
  
  func register(_ number: String, _ code: String, _ password: String, _ username: String, then handler: @escaping Net.Handler) {
    Net.request(
      url: "auth/register",
      method: "POST",
      data: [
        "phone_number": number,
        "password": password,
        "username": username,
        "code": code
      ],
      decoder: UserSessionResponse.self,
      then: handler
    )
  }
  
  func login(_ number: String, _ password: String, then handler: @escaping Net.Handler) {
    Net.request(
      url: "auth/login",
      method: "POST",
      data: [
        "phone_number": number,
        "password": password
      ],
      decoder: UserSessionResponse.self,
      then: handler
    )
  }
  
  func tracksByPlaylist(_ playlist_id: Int, then handler: @escaping Net.Handler) {
    Net.request(
      url: "tracks/byPlaylist",
      method: "GET",
      data: [
        "playlist_id": playlist_id
      ],
      decoder: UserTracksByPlaylistResponse.self,
      then: handler
    )
  }
  
}
