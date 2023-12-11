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
    method: String = "GET",
    data: [String: Any] = [:],
    decoder: Response.Type,
    then handler: @escaping (Result<Response, ResponseError>) -> Void
  ) {
    
    var components = URLComponents(string: url_prefix + url)!
    
    if method == "GET" {
      components.queryItems = data.map { (key, value) in
        URLQueryItem(name: key, value: value as? String)
      }
    }
    
    let req = NSMutableURLRequest(url: components.url!)
    req.httpMethod = method
    
    if method != "GET" {
      req.httpBody = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
    }
    
    let session_key = SessionManager().userSession?.session.key
    
    //HTTP Headers
    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("application/json", forHTTPHeaderField: "Accept")
    
    if session_key != nil {
      req.addValue(session_key!, forHTTPHeaderField: "AccessToken")
    }
    
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
