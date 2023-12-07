

struct RegisterCodeResponse:Response {
  
  var response: RegisterCode
  
}

struct RegisterCode: Decodable {
  var phone_number: String
  var type: String
}


struct RegisterSilentCheckCodeResponse:Response {
  
  var response: RegisterSilentCheckCode
  
}

struct RegisterSilentCheckCode: Decodable {
  var type: String
  var phone_number: String
  var code: String
}
