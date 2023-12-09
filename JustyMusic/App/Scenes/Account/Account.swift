//
//  Main.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 08.12.2023.
//

import SwiftUI

struct Account: View {
  
  @EnvironmentObject var router: Router
  @EnvironmentObject var network: NetworkManager
  @EnvironmentObject var userSession: SessionManager
  
  @State private var isPresentingConfirm: Bool = false
  
  var body: some View {
    VStack(alignment: .leading) {
      
      VStack {
        Text("Ваш аккаунт")
          .padding(.top, 20)
          .padding(.bottom, 5)
          .font(Font.system(size: 37, weight: .heavy))
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(userSession.userSession?.number ?? "")
          .multilineTextAlignment(.leading)
          .colorMultiply(.gray)
          .font(Font.system(size: 23, weight: .semibold))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 20)
      
      Form {
        Button("Выйти из аккаунта") {
          isPresentingConfirm = true
        }
        .foregroundColor(.red)
        .confirmationDialog(
          "Вы уверены?",
          isPresented: $isPresentingConfirm
        ) {
          Button("Выйти из аккаунта", role: .destructive) {
            router.navigateTo(.greeting)
            userSession.logOut()
          }
        }
        
      }.padding(.vertical, 5)
      
    }
  }
}
