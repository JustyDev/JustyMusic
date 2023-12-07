//
//  Login.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 07.12.2023.
//

import Foundation
import SwiftUI

struct Login: View {
  
  @EnvironmentObject var router: Router
  @EnvironmentObject var network: NetworkManager
  @EnvironmentObject var userSession: SessionManager
  
  @State private var number: String = ""
  @State private var password: String = ""
  
  @FocusState private var isFocused: Bool
  
  @State var loading: Bool = false
  
  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        
        Text("С возвращением!")
          .padding([.vertical], 5)
          .font(Font.system(size: 37, weight: .heavy))
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text("Введите ваш логин и пароль, чтобы войти")
          .multilineTextAlignment(.leading)
          .colorMultiply(.gray)
          .font(Font.system(size: 23, weight: .semibold))
          .frame(maxWidth: .infinity, alignment: .leading)
        
      }
      .padding(.horizontal, 18)
      .padding(.vertical, 5)
      
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
        .padding(.top, 10)
        .padding(.bottom, 15)
      
      SecureField("Пароль", text: $password)
        .keyboardType(.default)
        .textContentType(.newPassword)
        .font(Font.system(size: 21, weight: .regular))
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(hexColor(hex: "#101010"))
        .cornerRadius(15)
        .overlay(
          RoundedRectangle(cornerRadius: 15).stroke(hexColor(hex: "#151515"), lineWidth: 2)
        )
        .padding(.horizontal, 15)
      
      HStack {
        Text("Нет аккаунта?")
          .colorMultiply(.gray)
          .font(Font.system(size: 18, weight: .semibold))
        
        Button(action: {
          router.navigateTo(.registerStep1)
        }) {
          Text("Регистрация")
        }
        .font(Font.system(size: 17, weight: .bold))
        .foregroundColor(.white)
      }
      .padding(.horizontal, 17)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 10)
      
      Spacer()
      
      BigButton(
        title: "Завершить",
        loading: loading,
        backgroundColor: Color.white,
        textColor: Color.black
      ) {
        network.login(
          number,
          password
        ) { result in
          if case .success(let res) = result {
            let res = res as! UserSessionResponse
            
            userSession.saveUserSession(userSession: res.response)
            router.navigateTo(.main)
            
          }
          
          if case .failure(let error) = result {
            print(error.error.message)
          }
          
          self.loading = false
        }
      }
      .padding(.bottom, 10)
    }
    .navigationBarBackButtonHidden()
  }
}

#Preview {
  Login()
}
