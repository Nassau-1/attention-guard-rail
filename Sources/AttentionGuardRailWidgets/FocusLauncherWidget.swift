import SwiftUI
import WidgetKit

struct FocusLauncherEntry: TimelineEntry {
  let date: Date
  let items: [WidgetLauncherItem]
}

struct FocusLauncherProvider: TimelineProvider {
  func placeholder(in context: Context) -> FocusLauncherEntry {
    FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.defaults)
  }

  func getSnapshot(in context: Context, completion: @escaping (FocusLauncherEntry) -> Void) {
    completion(FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.defaults))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<FocusLauncherEntry>) -> Void) {
    completion(Timeline(entries: [FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.defaults)], policy: .never))
  }
}

struct FocusLauncherWidgetView: View {
  var entry: FocusLauncherEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      ForEach(entry.items) { item in
        Link(destination: item.focusHomeURL) {
          HStack(spacing: 10) {
            Image(systemName: item.systemImage)
              .frame(width: 20)
            Text(item.title)
              .font(.headline)
              .lineLimit(1)
            Spacer()
          }
          .foregroundStyle(.white)
        }
      }
      Spacer(minLength: 0)
    }
    .padding(16)
    .containerBackground(.black, for: .widget)
  }
}

struct FocusLauncherWidget: Widget {
  let kind = "FocusLauncherWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: FocusLauncherProvider()) { entry in
      FocusLauncherWidgetView(entry: entry)
    }
    .configurationDisplayName("Guard Launcher")
    .description("Text-only launcher routed through Attention Guard Rail.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}

struct WidgetLauncherItem: Identifiable {
  var id: String
  var title: String
  var systemImage: String

  var focusHomeURL: URL {
    URL(string: "attentionguardrail://launch?target=\(id)")!
  }

  static let defaults: [WidgetLauncherItem] = [
    WidgetLauncherItem(id: "linkedin", title: "LinkedIn", systemImage: "briefcase"),
    WidgetLauncherItem(id: "instagram", title: "Instagram", systemImage: "camera"),
    WidgetLauncherItem(id: "youtube", title: "YouTube", systemImage: "play.rectangle"),
    WidgetLauncherItem(id: "mail", title: "Mail", systemImage: "envelope")
  ]
}

#Preview(as: .systemMedium) {
  FocusLauncherWidget()
} timeline: {
  FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.defaults)
}

