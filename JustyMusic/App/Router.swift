//
//  AppRouter.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
  // Contains the possible destinations in our Router
  enum Route: Hashable {
    case greeting
    case login
    case registerStep1
    case registerStep2
    case registerStep3
    case main
  }
  
  // Used to programatically control our navigation stack
  @Published var path: NavigationPath = NavigationPath()
  
  // Builds the views
  @ViewBuilder func view(for route: Route) -> some View {
    switch route {
      case .login:
        Login()
      case .registerStep1:
        RegisterStep1()
      case .registerStep2:
        RegisterStep2()
      case .registerStep3:
        RegisterStep3()
      case .greeting:
        Greeting()
      case .main:
        Main()
        
    }
  }
  
  // Used by views to navigate to another view
  func navigateTo(_ appRoute: Route) {
    path.append(appRoute)
  }
  
  // Used to go back to the previous screen
  func navigateBack() {
    path.removeLast()
  }
  
  // Pop to the root screen in our hierarchy
  func popToRoot() {
    path.removeLast(path.count)
  }
}
