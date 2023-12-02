//
//  ContentView.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import SwiftUI

struct Auth: View {
  
  @State private var number: String = ""
  @FocusState private var isFocused: Bool
  
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Продолжим")
      
      TextField("Some text", text: $number)
        .focused($isFocused)
        .keyboardType(.numberPad)
        
      
    }
    .padding()
  }
}

#Preview {
  Auth()
}
