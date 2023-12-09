//
//  Net.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 07.12.2023.
//

import Foundation

protocol Response: Decodable {}

struct Net {
  
  typealias Handler = (Result<Response, ResponseError>) -> Void
  
  static func request(
    url: String,
    url_prefix: String = Config.API_URL,
    method: String = "POST",
    data: [String: Any] = [:],
    decoder: Response.Type,
    then handler: @escaping (Result<Response, ResponseError>) -> Void
  ) {
    
    guard let url_object = URL(string: url_prefix + url) else { fatalError("Missing URL") }
    
    let req = NSMutableURLRequest(url: url_object)
    req.httpMethod = method
    
    req.httpBody = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
    
    //HTTP Headers
    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("application/json", forHTTPHeaderField: "Accept")
    
    URLSession.shared.dataTask(with: req as URLRequest) { (data, response, error) in
      if let error = error {
        handler(.failure(ResponseError.init(error.localizedDescription)))
        return
      }
      
      guard let response = response as? HTTPURLResponse else { return }
      
      if response.statusCode == 200 {
        guard let data = data else { return }
        DispatchQueue.main.async {
          do {
            
            let decoded_success = try JSONDecoder().decode(decoder.self, from: data)
            handler(.success(decoded_success))
            
          } catch _ {
            
            do {
              let decodedError = try JSONDecoder().decode(ResponseError.self, from: data)
              handler(.failure(decodedError))
            } catch let error {
              handler(.failure(ResponseError.init(error.localizedDescription)))
            }
            
            //handler(.failure(ResponseError.init(error.localizedDescription)))
          }
        }
      }
    }.resume()
  }
  
}
