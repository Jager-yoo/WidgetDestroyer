//
//  NumberWidget.swift
//  NumberWidget
//
//  Created by 유재호 on 12/21/23.
//

import WidgetKit
import SwiftUI

// MARK: - TimelineProvider

struct Provider: TimelineProvider {
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: .now, fact: "placeholder 🗒️")
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: .now, fact: "getSanpshot 📸")
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Task {
      let fetchedFact = await fetchNumberFact()
      let currentDate = Date.now
      let entry = SimpleEntry(date: currentDate, fact: fetchedFact)
      let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
      let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
      completion(timeline)
    }
  }

  private func fetchNumberFact() async -> String {
    let url = URL(string: "http://numbersapi.com/random/trivia")!
    let (data, _) = try! await URLSession.shared.data(from: url)
    return String(decoding: data, as: UTF8.self)
  }
}

// MARK: Model

struct SimpleEntry: TimelineEntry {
  let date: Date
  let fact: String
}

// MARK: - UI

struct NumberWidgetEntryView : View {
  let entry: Provider.Entry

  var body: some View {
    VStack {
      Text(entry.fact)
        .foregroundStyle(.blue)
      Text(entry.date, style: .relative)
        .multilineTextAlignment(.center)
    }
  }
}

// MARK: - Widget Configuration

struct NumberWidget: Widget {
  private let kind: String = "NumberWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
        NumberWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Number Widget")
    .description("fetching random number fact...")
    .supportedFamilies(
      [
        .systemSmall,
        .systemMedium,
        .systemLarge,
        .accessoryRectangular,
        .accessoryCircular
      ]
    )
    .contentMarginsDisabled()
  }
}

// MARK: - Preview

#Preview(as: .systemMedium) {
  NumberWidget()
} timeline: {
  SimpleEntry(date: .now, fact: "Random number api")
  SimpleEntry(date: .now, fact: "Random number api")
}
