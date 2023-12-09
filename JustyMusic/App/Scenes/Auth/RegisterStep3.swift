//
//  RegisterStep3.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 07.12.2023.
//

import Foundation
import SwiftUI

struct RegisterStep3: View {
  
  @State private var username: String = ""
  @State private var password: String = ""
  
  @State var loading: Bool = false
  
  @EnvironmentObject var router: Router
  @EnvironmentObject var network: NetworkManager
  @EnvironmentObject var userSession: SessionManager
  
  @FocusState private var isFocused: Bool
  
  var body: some View {
    VStack {
      
      VStack(alignment: .leading) {
        
        Text("Последний шаг")
          .padding([.vertical], 5)
          .font(Font.system(size: 37, weight: .heavy))
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text("Придумайте уникальный ник и пароль, чтобы завершить регистрацию")
          .padding(.bottom, 10)
          .multilineTextAlignment(.leading)
          .colorMultiply(.gray)
          .font(Font.system(size: 23, weight: .semibold))
          .frame(maxWidth: .infinity, alignment: .leading)
        
      }
      .padding(.horizontal, 18)
      .padding(.vertical, 5)
      
      TextField("Имя пользователя", text: $username)
        .keyboardType(.default)
        .font(Font.system(size: 21, weight: .regular))
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(hexColor(hex: "#101010"))
        .cornerRadius(15)
        .overlay(
          RoundedRectangle(cornerRadius: 15).stroke(hexColor(hex: "#151515"), lineWidth: 2)
        )
        .padding(.horizontal, 15)
        .focused($isFocused)
        .onAppear {
          self.isFocused = true
        }
      
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
        .padding(.vertical, 15)
      
      Spacer()
      
      BigButton(
        title: "Завершить",
        loading: loading,
        clickEffect: false,
        backgroundColor: Color.white,
        textColor: Color.black
      ) {
        self.loading = true
        network.register(
          (self.network.regStep3State?.response.phone_number)!,
          (self.network.regStep3State?.response.code)!,
          password,
          username
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
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        
        Button {
          
          router.navigateBack()
          router.navigateBack()
          
        } label: {
          HStack {
            Image(systemName: "chevron.backward")
            Text("К началу")
          }
        }
      }
    }
  }
  
}

#Preview {
  RouterView {
    RegisterStep3()
  }
}
