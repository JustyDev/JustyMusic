//
//  ContentView.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import SwiftUI

struct RegisterStep1: View {
  
  @EnvironmentObject var network: NetworkManager
  @EnvironmentObject var router: Router
  
  @FocusState private var isFocused: Bool
  
  @State private var number: String = ""
  @State var loading = false
  
  var body: some View {
    VStack {
      
      Image(systemName: "phone.bubble")
        .font(Font.system(size: 60))
        .padding([.top], 20)
      
      Text("Место эмоций")
        .padding([.top], 5)
        .padding([.bottom], 10)
        .font(Font.system(size: 37, weight: .heavy))
      
      Text("Введите ваш номер телефона, мы позвоним на него и продиктуем код для регистрации")
        .font(Font.system(size: 22, weight: .semibold))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .colorMultiply(.gray)
      
      HStack {
        Text("Уже есть аккаунт?")
          .colorMultiply(.gray)
          .font(Font.system(size: 18, weight: .semibold))
        
        Button(action: {
          router.navigateTo(.login)
        }) {
          Text("Войти")
        }
        .font(Font.system(size: 17, weight: .bold))
        .foregroundColor(.white)
      }
      
      Spacer()
      
      TextField("+7 (999) 000 00-00", text: $number)
        .textContentType(.telephoneNumber)
        .focused($isFocused)
        .keyboardType(.numberPad)
        .tracking(3)
        .font(Font.system(size: 23, weight: .bold))
        .onChange(of: number) {
          let cleared = number.replacing(#/[^0-9]/#, with: "")
          self.number = phoneFromat(with: "+X (XXX) XXX XX-XX", phone: cleared)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 13)
        .background(hexColor(hex: "#101010"))
        .cornerRadius(15)
        .overlay(
          RoundedRectangle(cornerRadius: 15).stroke(hexColor(hex: "#151515"), lineWidth: 2)
        )
        .onAppear {
          self.isFocused = true
        }
        .padding(.horizontal, 15)
      
      BigButton(
        title: "Продолжить",
        loading: loading,
        backgroundColor: Color.white,
        textColor: Color.black
      ) {
        self.loading = true
        self.network.sendRegisterCode(self.number) { result in
          
          if case .success = result { router.navigateTo(.registerStep2) }
          if case .failure = result {
            UINotificationFeedbackGenerator()
              .notificationOccurred(.error)
          }
          
          self.loading = false
        }
      }
      .padding(.bottom, 10)
      
    }.navigationBarBackButtonHidden()
  }
}

#Preview {
  RegisterStep1()
}
