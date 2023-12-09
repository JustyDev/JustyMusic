//
//  Preloader.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 08.12.2023.
//

import SwiftUI

struct Preloader: View {
  
  @State private var preloaderState: Bool = false
  
  var body: some View {
    Circle()
      .trim(from: 0, to: 0.7)
      .stroke(Color.gray, lineWidth: 3)
      .padding(.all, 1)
      .frame(width: 23, height: 23)
      .frame(maxWidth:.infinity)
      .rotationEffect(Angle(degrees: preloaderState ? 360 : 0))
      .animation(.linear(duration: 1)
        .repeatForever(autoreverses: false), value: preloaderState)
      .onAppear() {
        self.preloaderState = true
      }
  }
}

#Preview {
  Preloader()
}
