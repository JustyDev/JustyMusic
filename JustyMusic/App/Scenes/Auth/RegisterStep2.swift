//
//  RegisterStep2.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 06.12.2023.
//

import SwiftUI

struct RegisterStep2: View {
  
  @EnvironmentObject var network: NetworkManager
  @EnvironmentObject var router: Router
  
  @State private var code: String = ""
  @State var loading = false
  
  func onSubmit() {
    
    self.loading = true
    
    network.silentCheckCode((self.network.regStep2State?.response.phone_number)!, code) { result in
      
      if case .success = result { router.navigateTo(.registerStep3) }
      if case .failure = result {
        self.code = ""
        UINotificationFeedbackGenerator()
          .notificationOccurred(.error)
      }
      
      self.loading = false
    }
    
  }
  
  var body: some View {
    VStack {
      
      Image(systemName: "phone.badge.waveform")
        .font(Font.system(size: 60))
        .padding([.top], 20)
      
      Text("Ждите звонка")
        .padding([.top], 5)
        .padding([.bottom], 10)
        .font(Font.system(size: 37, weight: .heavy))
      
      Text("Мы позвоним и продиктуем пятизначный код")
        .font(Font.system(size: 22, weight: .semibold))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .colorMultiply(.gray)
      
      HStack {
        
        
        PinEntryView(pinLimit: 5, pinCode: $code)
          .onChange(of: code) {
            if self.$code.wrappedValue.count == 5 {
              onSubmit()
            }
          }
          .disabled(self.loading)
    
      }
      .padding(.horizontal, 40)
      .padding(.vertical, 20)
      
      Spacer()
      
      BigButton(
        title: "Продолжить",
        loading: loading,
        backgroundColor: Color.white,
        textColor: Color.black,
        action: onSubmit
      )
      .padding(.bottom, 10)
      
    }
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        
        Button {
          
          router.navigateBack()
          
        } label: {
          HStack {
            Image(systemName: "chevron.backward")
            Text("Телефон")
          }
        }
      }
    }
  }
  
}

#Preview {
  RouterView {
    RegisterStep2()
  }
}
