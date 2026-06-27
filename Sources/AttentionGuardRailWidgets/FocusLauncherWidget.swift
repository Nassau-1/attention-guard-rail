import SwiftUI
import WidgetKit

struct FocusLauncherEntry: TimelineEntry {
  let date: Date
  let items: [WidgetLauncherItem]
}

struct FocusLauncherProvider: TimelineProvider {
  func placeholder(in context: Context) -> FocusLauncherEntry {
    FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.selectedItems)
  }

  func getSnapshot(in context: Context, completion: @escaping (FocusLauncherEntry) -> Void) {
    completion(FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.selectedItems))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<FocusLauncherEntry>) -> Void) {
    completion(Timeline(entries: [FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.selectedItems)], policy: .never))
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
  var primaryURL: URL
  var requiresDelay: Bool

  var focusHomeURL: URL {
    requiresDelay ? URL(string: "attentionguardrail://launch?target=\(id)")! : primaryURL
  }

  private static let appGroupID = "group.com.enzoterrier.attentionguardrail"
  private static let launcherSelectionKey = "launcherSelectionIDs"
  private static let delayedSelectionKey = "delayedSelectionIDs"

  static let defaults: [WidgetLauncherItem] = [
    WidgetLauncherItem(id: "linkedin", title: "LinkedIn", systemImage: "briefcase", primaryURL: URL(string: "linkedin://")!, requiresDelay: true),
    WidgetLauncherItem(id: "instagram", title: "Instagram", systemImage: "camera", primaryURL: URL(string: "instagram://app")!, requiresDelay: true),
    WidgetLauncherItem(id: "youtube", title: "YouTube", systemImage: "play.rectangle", primaryURL: URL(string: "youtube://")!, requiresDelay: true),
    WidgetLauncherItem(id: "mail", title: "Mail", systemImage: "envelope", primaryURL: URL(string: "message://")!, requiresDelay: false)
  ]

  static var selectedItems: [WidgetLauncherItem] {
    let defaultsStore = UserDefaults(suiteName: appGroupID) ?? .standard
    let delayedIDs = Set(defaultsStore.array(forKey: delayedSelectionKey) as? [String] ?? defaults.filter { $0.requiresDelay }.map(\.id))
    guard let ids = defaultsStore.array(forKey: launcherSelectionKey) as? [String], !ids.isEmpty else {
      return defaults.map { item in
        var item = item
        item.requiresDelay = delayedIDs.contains(item.id)
        return item
      }
    }

    return ids.compactMap { id in
      guard var item = defaults.first(where: { $0.id == id }) else { return nil }
      item.requiresDelay = delayedIDs.contains(item.id)
      return item
    }
  }
}

#Preview(as: .systemMedium) {
  FocusLauncherWidget()
} timeline: {
  FocusLauncherEntry(date: Date(), items: WidgetLauncherItem.defaults)
}
