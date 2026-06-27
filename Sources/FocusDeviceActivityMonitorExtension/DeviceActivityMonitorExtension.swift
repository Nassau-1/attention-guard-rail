import Foundation
import DeviceActivity
import FamilyControls
import ManagedSettings

final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
  private static let appGroupID = "group.com.enzoterrier.attentionguardrail"
  private static let activitySelectionKey = "familyActivitySelection"

  private let store = ManagedSettingsStore()

  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
    applyPersistedShield()
  }

  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
    store.clearAllSettings()
  }

  private func applyPersistedShield() {
    guard
      let defaults = UserDefaults(suiteName: Self.appGroupID),
      let data = defaults.data(forKey: Self.activitySelectionKey),
      let selection = try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data)
    else {
      return
    }

    store.shield.applications = selection.applicationTokens
    store.shield.applicationCategories = .specific(selection.categoryTokens)
    store.shield.webDomains = selection.webDomainTokens
  }
}
