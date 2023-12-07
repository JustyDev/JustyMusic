//
//  Greeting.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import Foundation
import SwiftUI

struct Main: View {
  
  @EnvironmentObject var router: Router
  
  var body: some View {
    VStack {
      
      VStack(alignment: .leading) {
        
        Text("Моя медиатека")
          .padding([.vertical], 5)
          .font(Font.system(size: 37, weight: .heavy))
          .frame(maxWidth: .infinity, alignment: .leading)
        
      }
      .padding(.horizontal, 18)
      .padding(.vertical, 5)
    }.navigationBarBackButtonHidden()
    
  }
}
