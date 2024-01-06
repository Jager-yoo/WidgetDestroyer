//
//  UserDefaults+Extension.swift
//  WidgetDestroyer
//
//  Created by 유재호 on 1/6/24.
//

import WidgetKit

extension WidgetFamily: Codable { }

extension UserDefaults {

  struct MyData: Codable {
    var widgetsInUse = Set<WidgetFamily>()
  }

  func set<T>(_ keyPath: WritableKeyPath<MyData, T>, _ value: T) {
    var myData = MyData()
    myData[keyPath: keyPath] = value
    let asData = try? JSONEncoder().encode(myData)
    set(asData, forKey: "MyData")
  }

  func get<T>(_ keyPath: KeyPath<MyData, T>) -> T {
    guard
      let asData = data(forKey: "MyData"),
      let myData = try? JSONDecoder().decode(MyData.self, from: asData)
    else {
      return MyData()[keyPath: keyPath] // returns default value
    }
    return myData[keyPath: keyPath]
  }
}
