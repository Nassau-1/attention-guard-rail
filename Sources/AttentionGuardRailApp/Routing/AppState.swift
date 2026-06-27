import Foundation
import FamilyControls
import SwiftUI
import WidgetKit

@MainActor
@Observable
final class AppState {
  private static let appGroupID = "group.com.enzoterrier.attentionguardrail"
  private static let launcherSelectionKey = "launcherSelectionIDs"
  private static let delayedSelectionKey = "delayedSelectionIDs"
  private static let activitySelectionKey = "familyActivitySelection"
  private static let launchDelayEnabledKey = "launchDelayEnabled"
  private static let extensionDelayEnabledKey = "extensionDelayEnabled"
  private static let blockingNowEnabledKey = "blockingNowEnabled"

  var selectedTab: AppTab = .home
  var pendingLaunch: LauncherItem?
  var launcherItems: [LauncherItem] = LauncherItem.defaults
  var focusRules: [FocusRule] = FocusRule.examples
  var launcherSelectionIDs: Set<String>
  var delayedSelectionIDs: Set<String>
  var isInAppReminderEnabled = true
  var isLaunchDelayEnabled = true {
    didSet { persistFocusOptions() }
  }
  var isExtensionDelayEnabled = true {
    didSet { persistFocusOptions() }
  }
  var isBlockingNowEnabled = false {
    didSet { persistFocusOptions() }
  }
  var activitySelection = FamilyActivitySelection()

  init() {
    let defaults = Self.sharedDefaults
    let savedLauncherIDs = defaults.array(forKey: Self.launcherSelectionKey) as? [String]
    let savedDelayedIDs = defaults.array(forKey: Self.delayedSelectionKey) as? [String]

    launcherSelectionIDs = Set(savedLauncherIDs ?? LauncherItem.defaults.map(\.id))
    delayedSelectionIDs = Set(savedDelayedIDs ?? LauncherItem.defaults.filter { $0.frictionLevel != .none }.map(\.id))
    activitySelection = Self.loadActivitySelection(from: defaults)
    isLaunchDelayEnabled = defaults.object(forKey: Self.launchDelayEnabledKey) as? Bool ?? true
    isExtensionDelayEnabled = defaults.object(forKey: Self.extensionDelayEnabledKey) as? Bool ?? true
    isBlockingNowEnabled = defaults.object(forKey: Self.blockingNowEnabledKey) as? Bool ?? false

    if let launchTab = Self.launchArgumentValue(for: "-AGRInitialTab") {
      selectedTab = AppTab(rawValue: launchTab) ?? .home
    }

    if let launchID = Self.launchArgumentValue(for: "-AGRPendingLaunch") {
      pendingLaunch = launcherItems.first { $0.id == launchID }
    }
  }

  var launcherWidgetItems: [LauncherItem] {
    launcherItems.filter { launcherSelectionIDs.contains($0.id) }
  }

  var delayedItems: [LauncherItem] {
    launcherItems.filter { delayedSelectionIDs.contains($0.id) }
  }

  var selectedActivityCount: Int {
    activitySelection.applicationTokens.count + activitySelection.categoryTokens.count + activitySelection.webDomainTokens.count
  }

  func isInLauncher(_ item: LauncherItem) -> Bool {
    launcherSelectionIDs.contains(item.id)
  }

  func setLauncher(_ item: LauncherItem, isSelected: Bool) {
    update(&launcherSelectionIDs, item: item, isSelected: isSelected)
    persistSelections()
  }

  func isDelayed(_ item: LauncherItem) -> Bool {
    delayedSelectionIDs.contains(item.id)
  }

  func setDelayed(_ item: LauncherItem, isSelected: Bool) {
    update(&delayedSelectionIDs, item: item, isSelected: isSelected)
    persistSelections()
  }

  func setActivitySelection(_ selection: FamilyActivitySelection) {
    activitySelection = selection
    persistActivitySelection()
  }

  func route(_ url: URL) {
    guard url.scheme == AttentionGuardRailURL.scheme else { return }

    switch AttentionGuardRailURL.Route(url: url) {
    case .launch(let id):
      pendingLaunch = launcherItems.first { $0.id == id }
    case .focus:
      selectedTab = .focus
    case .settings:
      selectedTab = .settings
    case .home:
      selectedTab = .home
    case .unknown:
      break
    }
  }

  private func update(_ selection: inout Set<String>, item: LauncherItem, isSelected: Bool) {
    if isSelected {
      selection.insert(item.id)
    } else {
      selection.remove(item.id)
    }
  }

  private func persistSelections() {
    let defaults = Self.sharedDefaults
    defaults.set(launcherItems.map(\.id).filter { launcherSelectionIDs.contains($0) }, forKey: Self.launcherSelectionKey)
    defaults.set(launcherItems.map(\.id).filter { delayedSelectionIDs.contains($0) }, forKey: Self.delayedSelectionKey)
    WidgetCenter.shared.reloadAllTimelines()
  }

  private func persistActivitySelection() {
    guard let data = try? PropertyListEncoder().encode(activitySelection) else { return }
    Self.sharedDefaults.set(data, forKey: Self.activitySelectionKey)
  }

  private func persistFocusOptions() {
    let defaults = Self.sharedDefaults
    defaults.set(isLaunchDelayEnabled, forKey: Self.launchDelayEnabledKey)
    defaults.set(isExtensionDelayEnabled, forKey: Self.extensionDelayEnabledKey)
    defaults.set(isBlockingNowEnabled, forKey: Self.blockingNowEnabledKey)
  }

  private static var sharedDefaults: UserDefaults {
    UserDefaults(suiteName: appGroupID) ?? .standard
  }

  private static func loadActivitySelection(from defaults: UserDefaults) -> FamilyActivitySelection {
    guard
      let data = defaults.data(forKey: activitySelectionKey),
      let selection = try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data)
    else {
      return FamilyActivitySelection()
    }
    return selection
  }

  private static func launchArgumentValue(for key: String) -> String? {
    let arguments = ProcessInfo.processInfo.arguments
    guard let index = arguments.firstIndex(of: key), arguments.indices.contains(index + 1) else {
      return nil
    }
    return arguments[index + 1]
  }
}

enum AppTab: String, Hashable {
  case home
  case focus
  case settings
}

enum AttentionGuardRailURL {
  static let scheme = "attentionguardrail"

  enum Route {
    case home
    case focus
    case launch(String)
    case settings
    case unknown

    init(url: URL) {
      guard url.scheme == AttentionGuardRailURL.scheme else {
        self = .unknown
        return
      }

      if url.host == "launch" {
        let id = URLComponents(url: url, resolvingAgainstBaseURL: false)?
          .queryItems?
          .first(where: { $0.name == "target" })?
          .value
        self = id.map(Route.launch) ?? .unknown
        return
      }

      switch url.host {
      case "focus":
        self = .focus
      case "settings":
        self = .settings
      case "home", "setup":
        self = .home
      default:
        self = .unknown
      }
    }
  }

  static func launchURL(for id: String) -> URL {
    URL(string: "\(scheme)://launch?target=\(id)")!
  }
}
