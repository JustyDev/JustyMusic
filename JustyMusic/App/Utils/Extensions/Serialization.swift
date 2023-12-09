//
//  Serialization.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 09.12.2023.
//

import Foundation

@propertyWrapper
public struct Transiant<T>: Codable {
  public var wrappedValue: T?
  
  public init(wrappedValue: T?) {
    self.wrappedValue = wrappedValue
  }
  
  public init(from decoder: Decoder) throws {
    self.wrappedValue = nil
  }
  
  public func encode(to encoder: Encoder) throws {
    // Do nothing
  }
}

extension KeyedDecodingContainer {
  public func decode<T>(
    _ type: Transiant<T>.Type,
    forKey key: Self.Key) throws -> Transiant<T>
  {
    return Transiant(wrappedValue: nil)
  }
}

extension KeyedEncodingContainer {
  public mutating func encode<T>(
    _ value: Transiant<T>,
    forKey key: KeyedEncodingContainer<K>.Key) throws
  {
    // Do nothing
  }
}
