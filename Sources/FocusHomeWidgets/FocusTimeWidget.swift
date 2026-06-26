import SwiftUI
import WidgetKit

struct FocusTimeEntry: TimelineEntry {
  let date: Date
}

struct FocusTimeProvider: TimelineProvider {
  func placeholder(in context: Context) -> FocusTimeEntry {
    FocusTimeEntry(date: Date())
  }

  func getSnapshot(in context: Context, completion: @escaping (FocusTimeEntry) -> Void) {
    completion(FocusTimeEntry(date: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<FocusTimeEntry>) -> Void) {
    let entry = FocusTimeEntry(date: Date())
    let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }
}

struct FocusTimeWidgetView: View {
  var entry: FocusTimeEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(entry.date, style: .time)
        .font(.system(size: 40, weight: .semibold, design: .rounded))
        .monospacedDigit()
        .minimumScaleFactor(0.7)

      Text(entry.date.formatted(.dateTime.weekday(.wide).day().month(.wide)))
        .font(.callout)
        .foregroundStyle(.secondary)
        .lineLimit(2)

      Spacer()

      HStack {
        Label("Focus", systemImage: "moon")
          .font(.caption.weight(.medium))
        Spacer()
      }
      .foregroundStyle(.secondary)
    }
    .padding(16)
    .containerBackground(.black, for: .widget)
  }
}

struct FocusTimeWidget: Widget {
  let kind = "FocusTimeWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: FocusTimeProvider()) { entry in
      FocusTimeWidgetView(entry: entry)
    }
    .configurationDisplayName("Focus Time")
    .description("Minimal time and day widget for the top of the home screen.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}

#Preview(as: .systemMedium) {
  FocusTimeWidget()
} timeline: {
  FocusTimeEntry(date: Date())
}

