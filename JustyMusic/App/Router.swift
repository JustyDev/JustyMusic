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
  }
  
  // Used to programatically control our navigation stack
  @Published var path: NavigationPath = NavigationPath()
  
  // Builds the views
  @ViewBuilder func view(for route: Route) -> some View {
    switch route {
    case .login:
      Auth()
        .navigationBarBackButtonHidden()
    case .greeting:
      Greeting()
        
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
