//
//  Greeting.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import Foundation
import SwiftUI

struct Greeting: View {
  
  @EnvironmentObject var router: Router
  
  @State private var showingCredits = false
  
  var body: some View {
    VStack {
    
      Text("Привет!")
        .padding([.top, .leading], 25)
        .padding([.bottom], 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .bold()
        .font(Font.system(size: 40, weight: .heavy))
      
      Text("Это JustyMusic, место, где мы создаём незабываемые эмоции для тебя.")
        .padding([.leading, .trailing], 25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .bold()
        .font(Font.system(size: 23, weight: .regular))
        .colorMultiply(.gray)
      
      Spacer()
      
      BigButton(
        title: "Войти в аккаунт",
        backgroundColor: Color.white,
        textColor: Color.black
      ) {
        router.navigateTo(.login)
      }
      
      Button(action: {
        router.navigateTo(.registerStep1)
      }) {
        Text("Зарегистрироваться")
      }
      .foregroundColor(.white)
      .padding([.bottom], 10)
      .padding([.top], 5)
      
      .sheet(isPresented: $showingCredits) {
        Text("This app was brought to you by Hacking with Swift")
          .presentationDetents([.large, .large])
      }
    }.navigationBarBackButtonHidden()
    
  }
}
