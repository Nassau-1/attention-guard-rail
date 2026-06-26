import Foundation
import SwiftUI

struct LauncherItem: Identifiable, Hashable, Codable {
  var id: String
  var title: String
  var systemImage: String
  var primaryURL: URL
  var fallbackURL: URL?
  var frictionLevel: FrictionLevel

  static let defaults: [LauncherItem] = [
    LauncherItem(
      id: "linkedin",
      title: "LinkedIn",
      systemImage: "briefcase",
      primaryURL: URL(string: "linkedin://")!,
      fallbackURL: URL(string: "https://www.linkedin.com")!,
      frictionLevel: .light
    ),
    LauncherItem(
      id: "instagram",
      title: "Instagram",
      systemImage: "camera",
      primaryURL: URL(string: "instagram://app")!,
      fallbackURL: URL(string: "https://www.instagram.com")!,
      frictionLevel: .strict
    ),
    LauncherItem(
      id: "youtube",
      title: "YouTube",
      systemImage: "play.rectangle",
      primaryURL: URL(string: "youtube://")!,
      fallbackURL: URL(string: "https://www.youtube.com")!,
      frictionLevel: .strict
    ),
    LauncherItem(
      id: "mail",
      title: "Mail",
      systemImage: "envelope",
      primaryURL: URL(string: "message://")!,
      fallbackURL: nil,
      frictionLevel: .none
    )
  ]
}

enum FrictionLevel: String, Codable, CaseIterable, Identifiable {
  case none
  case light
  case strict

  var id: String { rawValue }

  var title: String {
    switch self {
    case .none: "No delay"
    case .light: "Ask first"
    case .strict: "15-second delay"
    }
  }
}

