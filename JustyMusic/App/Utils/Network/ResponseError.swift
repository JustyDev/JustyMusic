//
//  ResponseError.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 06.12.2023.
//

import Foundation

struct ResponseError: Decodable, Error {
  
  var error: Err
  
  init(_ message: String) {
    self.error = Err(message: message)
  }
  
  struct Err: Decodable {
    var message: String
  }
  
}
