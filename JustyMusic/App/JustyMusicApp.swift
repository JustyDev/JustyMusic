//
//  JustyMusicApp.swift
//  JustyMusic
//
//  Created by Дмитрий Сидоров on 02.12.2023.
//

import SwiftUI

@main
struct JustyMusicApp: App {
    
    var body: some Scene {
        WindowGroup {
            RouterView {
                Greeting()
            }
        }
    }
    
}

#Preview {
  RouterView {
      Greeting()
  }
}
