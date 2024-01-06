//
//  ContentView.swift
//  WidgetDestroyer
//
//  Created by 유재호 on 12/21/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {

  @State private var widgetsInUse: [WidgetFamily] = []

  @Environment(\.scenePhase) private var scenePhase

  var body: some View {
    VStack {
      GroupBox("Widgets in use") {
        ForEach(widgetsInUse, id: \.self) { widget in
          Text(widget.description)
            .font(.body)
        }
      }
      .padding()

      Image(systemName: "arrow.clockwise")
        .imageScale(.large)

      Text("Go \(Text("**Background**").foregroundStyle(.blue)) to\nreload all widgets!")
    }
    .font(.largeTitle)
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        WidgetDetector.shared.detect() // ✅
        // just to display the current widgets
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          widgetsInUse = Array(UserDefaults.standard.get(\.widgetsInUse))
            .sorted(by: { $0.description.count < $1.description.count })
        }
      } else if newPhase == .background {
        WidgetCenter.shared.reloadAllTimelines()
      }
    }
  }
}

#Preview {
  ContentView()
}
