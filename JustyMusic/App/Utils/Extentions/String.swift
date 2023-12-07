//
//  String.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 06.12.2023.
//

import Foundation

extension String {
  mutating func regReplace(pattern: String, replaceWith: String = "") {
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .anchorsMatchLines])
      let range = NSRange(self.startIndex..., in: self)
      self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
    } catch { return }
  }
}
