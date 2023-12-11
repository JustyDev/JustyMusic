//
//  View.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 10.12.2023.
//

import Foundation
import SwiftUI

extension View {
  
  func fullScreenSheet<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder view: @escaping () -> Content
  ) -> some View {
    
    func present() {
      DispatchQueue.main.async {
        let topMostController = self.topMostController()
        
        if topMostController == nil {
          return
        }
        
        let someView = FullScreenSheetScene(isPresented: isPresented) {
          view()
        }
        
        let viewController = UIHostingController(rootView: someView)
        viewController.view?.backgroundColor = .clear
        viewController.modalPresentationStyle = .overFullScreen
        topMostController!.present(viewController, animated: true)
      }
    }
    
    return self.onChange(of: isPresented.wrappedValue) {
      if isPresented.wrappedValue {
        present()
      }else {
        self.topMostController()?.dismiss(animated: true)
      }
    }
  }
  
  func topMostController() -> UIViewController? {
    
    guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return nil
    }
    
    guard let firstWindow = firstScene.windows.first else {
      return nil
    }
    
    var topController = firstWindow.rootViewController!
    
    //var topController: UIViewController = UIApplication.shared.windows.first!.rootViewController!
    while (topController.presentedViewController != nil) {
      topController = topController.presentedViewController!
    }
    return topController
  }
}

struct FullScreenSheetScene<Content: View>: View {
  
  @State var position: Double = 0.0
  @Binding var isPresented: Bool
  @ViewBuilder var view: () -> Content
  
  var body: some View {
    view()
      .cornerRadius(50)
      .overlay(
        RoundedRectangle(cornerRadius: 50)
          .opacity(0)
      )
      .ignoresSafeArea(.all)
      .offset(y: position)
      .gesture(
        DragGesture(minimumDistance: 30)
          .onChanged { value in
            if value.translation.height > 0 {
              position = value.translation.height
            }
            
          }
          .onEnded { value in
            if position >= 50 {
              isPresented = false
            } else {
              position = .zero
            }
          }
      )
      .frame(width: .infinity, height: .infinity)
      .animation(.linear(duration: 0.2), value: position)
      .contentShape(Rectangle())
      .onDisappear(perform: {
        position = .zero
      })
  }
}

#if DEBUG
struct PreviewFullScreenSheet: View {
  
  @State var isPresented = false
  
  var body: some View {
    VStack {
      Button("Present modal", action: {
        isPresented = true
      })
      .padding()
      .fullScreenSheet(isPresented: $isPresented) {
        ZStack(alignment: .top) {
          RoundedRectangle(cornerRadius: 5)
            .fill(hexColor(hex: "#101010"))
            .fill(Gradient(colors: [.purple.opacity(0.9), .purple.opacity(0.1)]))
          VStack {
            Spacer()
            Text("Slide me down to make me disappear... ")
              .font(.largeTitle)
              .padding(.all, 30)
              .multilineTextAlignment(.center)
            Spacer()
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
#endif

#Preview {
  PreviewFullScreenSheet()
}
