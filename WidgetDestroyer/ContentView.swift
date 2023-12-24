//
//  ContentView.swift
//  WidgetDestroyer
//
//  Created by 유재호 on 12/21/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {

  @Environment(\.scenePhase) private var scenePhase

  var body: some View {
    VStack {
      Image(systemName: "arrow.clockwise")
        .imageScale(.large)

      Text("Go \(Text("**Background**").foregroundStyle(.blue)) to\nreload all widgets!")
    }
    .font(.largeTitle)
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .background {
        WidgetCenter.shared.reloadAllTimelines()
        print("♻️ Widget reload")
      }
    }
  }
}

#Preview {
  ContentView()
}
