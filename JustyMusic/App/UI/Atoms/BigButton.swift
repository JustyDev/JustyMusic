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
  
  private let title: String
  private let action: () -> Void
  
  // It would be nice to make this into a binding.
  private let disabled: Bool
  
  init(title: String,
       disabled: Bool = false,
       backgroundColor: Color = Color.green,
       textColor: Color = Color.white,
       action: @escaping () -> Void
  ) {
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    self.title = title
    self.action = action
    self.disabled = disabled
  }
  
  var body: some View {
    HStack {
      Spacer(minLength: BigButton.buttonHorizontalMargins)
      Button(action:self.action) {
        Text(self.title)
          .frame(maxWidth:.infinity)
      }
      .buttonStyle(LargeButtonStyle(backgroundColor: backgroundColor,
                                    textColor: textColor,
                                    isDisabled: disabled))
      .disabled(self.disabled)
      Spacer(minLength: BigButton.buttonHorizontalMargins)
    }
    .frame(maxWidth:.infinity)
  }
}


#Preview {
  BigButton(
    title: "Invite a Friend",
    backgroundColor: Color.white,
    textColor: Color.black
  ) {
    print("Hello World")
  }
}
