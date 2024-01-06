//
//  WidgetDetector.swift
//  NumberWidgetExtension
//
//  Created by 유재호 on 1/6/24.
//

import WidgetKit

final class WidgetDetector {

  /// Singleton instance of WidgetDetector
  static let shared = WidgetDetector()

  private init() { }

  func detect() {
    WidgetCenter.shared.getCurrentConfigurations { result in
      if case .success(let widgetInfo) = result {
        self.diff(widgetInfo)
      }
    }
  }

  private func diff(_ newValue: [WidgetInfo]) {
    let cachedWidgetsInUse = UserDefaults.standard.get(\.widgetsInUse)
    let newWidgetsInUse = Set(newValue.map(\.family))

    guard newWidgetsInUse != cachedWidgetsInUse else {
      return // ignores if the same
    }

    let addedWidgets = newWidgetsInUse.subtracting(cachedWidgetsInUse)
    let removedWidgets = cachedWidgetsInUse.subtracting(newWidgetsInUse)

    for added in addedWidgets {
      didAddWidget(family: added)
    }

    for removed in removedWidgets {
      didRemoveWidget(family: removed)
    }

    UserDefaults.standard.set(\.widgetsInUse, newWidgetsInUse)
  }

  private func didAddWidget(family: WidgetFamily) {
    print("🟢\(family) widget added!")
  }

  private func didRemoveWidget(family: WidgetFamily) {
    print("🔴\(family) widget removed!")
  }
}
