import SwiftUI

struct PinEntryView: View {
  
  var pinLimit: Int = 4
  var canEdit: Bool = true
  var isError: Bool = false
  
  @Binding var pinCode: String
  
  private var pins: [String] {
    return pinCode.map { String($0) }
  }
  
  var body: some View {
    ZStack {
      VStack {
        PinCodeTextField(limit: pinLimit, canEdit: canEdit, text: $pinCode)
          .border(Color.black, width: 1)
          .frame(height: 60)
          .padding()

      }
      .opacity(0)
      
      VStack {
        HStack(spacing: 32) {
          ForEach(0 ..< pinLimit) { item in
            Text(item < pinCode.count ? pins[item] : "")
              .frame(width: 16, height: 16)
              .padding(.all, 13)
              .font(Font.system(size: 19, weight: .bold))
              .background(hexColor(hex: "#101010"))
              .cornerRadius(15)
              .overlay() {
                RoundedRectangle(cornerRadius: 15)
                  .stroke(isError ? .red : hexColor(hex: "#151515"), lineWidth: 2)
              }
          }
          .frame(width: 24, height: 32) // We give a constant frame to avoid any layout movements when the state changes.
        }
      }
    }
  }
}

/// A UITextField Representable that enables the PinField to become first responder.
struct PinCodeTextField: UIViewRepresentable {
  
  class Coordinator: NSObject, UITextFieldDelegate {
    
    var limit: Int
    var canEdit: Bool
    @Binding var text: String
    
    init(limit: Int, canEdit: Bool, text: Binding<String>) {
      self.limit = limit
      self.canEdit = canEdit
      self._text = text
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
      DispatchQueue.main.async {
        self.text = textField.text ?? ""
      }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if !canEdit {
        return false
      }
      
      let currentText = textField.text ?? ""
      
      guard let stringRange = Range(range, in: currentText) else { return false }
      
      let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
      
      return updatedText.count <= limit
    }
  }
  
  var limit: Int
  var canEdit: Bool
  @Binding var text: String
  
  func makeUIView(context: UIViewRepresentableContext<PinCodeTextField>) -> UITextField {
    let textField = UITextField(frame: .zero)
    textField.delegate = context.coordinator
    textField.textAlignment = .center
    textField.keyboardType = .numberPad
    return textField
  }
  
  func makeCoordinator() -> PinCodeTextField.Coordinator {
    return Coordinator(limit: limit, canEdit: canEdit, text: $text)
  }
  
  func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PinCodeTextField>) {
    uiView.text = text
    context.coordinator.canEdit = canEdit
    uiView.becomeFirstResponder()
  }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
  
  // MARK: - Properties
  
  var content: (Binding<Value>) -> Content
  @State private var value: Value
  
  // MARK: - Initializer
  init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
    self._value = State(wrappedValue: value)
    self.content = content
  }
  
  // MARK: - Body
  
  var body: some View {
    content($value)
  }
}

#Preview {
  
  @State var isError: Bool = false
  
  return Group {
    StatefulPreviewWrapper("") {
      PinEntryView(isError: false, pinCode: $0)
    }
    .previewLayout(.sizeThatFits)
    
    StatefulPreviewWrapper("12") {
      PinEntryView(isError: true, pinCode: $0)
    }
    .previewLayout(.sizeThatFits)
//    
//    StatefulPreviewWrapper("1333") {
//      PinEntryView(isError: $isError as Bool, pinCode: $0)
//    }
//    .previewLayout(.sizeThatFits)
//    
//    StatefulPreviewWrapper("12") {
//      PinEntryView(pinLimit: 6, pinCode: $0)
//    }
//    .previewLayout(.sizeThatFits)
//    
//    StatefulPreviewWrapper("12") {
//      PinEntryView(isError: $isError as Bool, pinLimit: 6, pinCode: $0)
//    }
//    .background(Color.black)
//    .previewLayout(.sizeThatFits)
//    .colorScheme(.dark)
  }
}
