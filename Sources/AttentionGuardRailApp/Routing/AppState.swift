import Foundation
import SwiftUI

@MainActor
@Observable
final class AppState {
  var selectedTab: AppTab = .home
  var pendingLaunch: LauncherItem?
  var launcherItems: [LauncherItem] = LauncherItem.defaults
  var focusRules: [FocusRule] = FocusRule.examples

  func route(_ url: URL) {
    guard url.scheme == AttentionGuardRailURL.scheme else { return }

    switch AttentionGuardRailURL.Route(url: url) {
    case .launch(let id):
      pendingLaunch = launcherItems.first { $0.id == id }
    case .focus:
      selectedTab = .focus
    case .home:
      selectedTab = .home
    case .unknown:
      break
    }
  }
}

enum AppTab: Hashable {
  case home
  case apps
  case focus
}

enum AttentionGuardRailURL {
  static let scheme = "attentionguardrail"

  enum Route {
    case home
    case focus
    case launch(String)
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
      case "home":
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

