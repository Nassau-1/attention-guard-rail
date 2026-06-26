import Foundation

#if canImport(DeviceActivity) && canImport(FamilyControls) && canImport(ManagedSettings)
import DeviceActivity
import FamilyControls
import ManagedSettings
#endif

@MainActor
@Observable
final class ScreenTimeService {
  var authorizationState: ScreenTimeAuthorizationState = .unknown

  func requestAuthorization() async {
    #if canImport(FamilyControls)
    do {
      try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
      authorizationState = .approved
    } catch {
      authorizationState = .denied(error.localizedDescription)
    }
    #else
    authorizationState = .unavailable("FamilyControls is only available on iOS.")
    #endif
  }

  func applyShield() {
    #if canImport(ManagedSettings) && canImport(FamilyControls)
    let store = ManagedSettingsStore()
    // TODO: Load the persisted FamilyActivitySelection and assign its tokens.
    store.shield.applications = []
    #endif
  }

  func startSchedule(for rule: FocusRule) throws {
    #if canImport(DeviceActivity)
    let schedule = DeviceActivitySchedule(
      intervalStart: DateComponents(hour: rule.startHour, minute: rule.startMinute),
      intervalEnd: DateComponents(hour: rule.endHour, minute: rule.endMinute),
      repeats: true
    )
    try DeviceActivityCenter().startMonitoring(
      DeviceActivityName(rule.id.uuidString),
      during: schedule
    )
    #endif
  }
}

enum ScreenTimeAuthorizationState: Equatable {
  case unknown
  case approved
  case denied(String)
  case unavailable(String)

  var title: String {
    switch self {
    case .unknown: "Not requested"
    case .approved: "Approved"
    case .denied: "Denied"
    case .unavailable: "Unavailable"
    }
  }
}

