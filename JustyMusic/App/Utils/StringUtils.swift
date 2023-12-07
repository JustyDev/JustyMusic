//
//  StringUtils.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 03.12.2023.
//

import Foundation
import SwiftUI

func phoneFromat(with mask: String, phone: String) -> String {
  let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
  var result = ""
  var index = numbers.startIndex // numbers iterator
  
  // iterate over the mask characters until the iterator of numbers ends
  for ch in mask where index < numbers.endIndex {
    if ch == "X" {
      // mask requires a number in this place, so take the next one
      result.append(numbers[index])
      
      // move numbers iterator to the next index
      index = numbers.index(after: index)
      
    } else {
      result.append(ch) // just append a mask character
    }
  }
  return result
}

func substrInvert(str: String, start: Int, end : Int) -> String
{
  let startIndex = str.index(str.endIndex, offsetBy: start)
  let endIndex = str.index(str.endIndex, offsetBy: end)
  return String(str[startIndex..<endIndex])
}

func hexColor(hex:String) -> Color {
  var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
  
  if (cString.hasPrefix("#")) {
    cString.remove(at: cString.startIndex)
  }
  
  if ((cString.count) != 6) {
    return Color.gray
  }
  
  var rgbValue:UInt64 = 0
  Scanner(string: cString).scanHexInt64(&rgbValue)
  
  return Color(
    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(rgbValue & 0x0000FF) / 255.0
  )
}
