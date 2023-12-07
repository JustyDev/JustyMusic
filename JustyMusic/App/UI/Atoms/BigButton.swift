//
//  BigButton.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import Foundation
import SwiftUI

struct LargeButtonStyle: ButtonStyle {
  
  let backgroundColor: Color
  let textColor: Color
  let isDisabled: Bool
  
  func makeBody(configuration: Self.Configuration) -> some View {
    let currentForegroundColor = isDisabled || configuration.isPressed ? textColor.opacity(0.6) : textColor
    return configuration.label
      .padding()
      .foregroundColor(currentForegroundColor)
      .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor)
    // This is the key part, we are using both an overlay as well as cornerRadius
      .cornerRadius(15)
      .overlay(
        RoundedRectangle(cornerRadius: 15)
          .stroke(currentForegroundColor, lineWidth: 0)
      )
      .padding([.top, .bottom], 10)
      .font(Font.system(size: 19, weight: .semibold))
  }
}

struct BigButton: View {
  
  private static let buttonHorizontalMargins: CGFloat = 15
  
  var backgroundColor: Color
  var textColor: Color
  var loading: Bool
  
  private let title: String
  private let action: () -> Void
  
  // It would be nice to make this into a binding.
  private let disabled: Bool
  
  @State private var preloaderState: Bool = false
  
  init(
    title: String,
    disabled: Bool = false,
    loading: Bool = false,
    backgroundColor: Color = Color.green,
    textColor: Color = Color.white,
    action: @escaping () -> Void
  ) {
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    self.title = title
    self.loading = loading
    self.action = action
    self.disabled = disabled
  }
  
  var body: some View {
    HStack {
      Spacer(minLength: BigButton.buttonHorizontalMargins)
      Button(action:self.action) {
        
        if self.loading {
          
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
          
        } else {
          Text(self.title).frame(maxWidth:.infinity)
        }
      
      }
      .buttonStyle(LargeButtonStyle(
        backgroundColor: backgroundColor,
        textColor: textColor,
        isDisabled: disabled))
      .disabled(self.disabled || self.loading)
      Spacer(minLength: BigButton.buttonHorizontalMargins)
    }
    .frame(maxWidth:.infinity)
  }
}


#Preview {
  VStack {
    BigButton(
      title: "Invite a Friend",
      loading: true,
      backgroundColor: Color.white,
      textColor: Color.black
    ) {
      print("Hello World")
    }
    
    BigButton(
      title: "Invite a Friend",
      loading: false,
      backgroundColor: Color.white,
      textColor: Color.black
    ) {
      print("Hello World")
    }
  }
}
