//
//  NetworkManager.swift
//  NumberWidgetExtension
//
//  Created by 유재호 on 12/24/23.
//

import Foundation

final class NetworkManager {

  /// Singleton instance of NetworkManager
  static let shared = NetworkManager()

  private init() { }

  /// last fetched number fact
  private var cachedNumberFact: String? {
    didSet {
      lastCachedDate = .now
    }
  }

  /// Date when the last number fact was cached
  private var lastCachedDate: Date?

  /// Checks if the cached data was fetched within the last 60 seconds
  private var hasCacheUnder60seconds: Bool {
    if cachedNumberFact != nil, let lastCachedDate, Date.now.timeIntervalSince(lastCachedDate) < 60 {
      return true
    } else {
      return false
    }
  }

  /// Fetches a new number fact
  /// returning cached data if available and fetched within the last 60 seconds
  func fetchNumberFact() async -> String {
    if let cachedNumberFact, hasCacheUnder60seconds {
      return cachedNumberFact // return cached fact
    }

    let fact = await _fetchNumberFact()
    self.cachedNumberFact = fact // update cache
    return fact
  }

  /// Internal method to asynchronously fetch a new number fact from the numbers API
  private func _fetchNumberFact() async -> String {
    let url = URL(string: "http://numbersapi.com/random/trivia")!
    let (data, _) = try! await URLSession.shared.data(from: url)
    return String(decoding: data, as: UTF8.self)
  }
}
