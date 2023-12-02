//
//  RouterView.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import Foundation
import SwiftUI

struct RouterView<Content: View>: View {
  @StateObject var router: Router = Router()
  // Our root view content
  private let content: Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    NavigationStack(path: $router.path) {
      content
        .navigationDestination(for: Router.Route.self) { route in
          router.view(for: route)
        }
    }
    .environmentObject(router)
  }
}
