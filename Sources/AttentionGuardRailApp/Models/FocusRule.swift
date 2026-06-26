import Foundation

struct FocusRule: Identifiable, Hashable, Codable {
  var id: UUID
  var name: String
  var days: Set<Weekday>
  var startHour: Int
  var startMinute: Int
  var endHour: Int
  var endMinute: Int
  var isEnabled: Bool

  static let examples: [FocusRule] = [
    FocusRule(
      id: UUID(),
      name: "Work block",
      days: [.monday, .tuesday, .wednesday, .thursday, .friday],
      startHour: 9,
      startMinute: 0,
      endHour: 12,
      endMinute: 30,
      isEnabled: true
    ),
    FocusRule(
      id: UUID(),
      name: "Evening cutoff",
      days: Set(Weekday.allCases),
      startHour: 22,
      startMinute: 0,
      endHour: 7,
      endMinute: 0,
      isEnabled: false
    )
  ]
}

enum Weekday: Int, CaseIterable, Codable, Hashable, Identifiable {
  case sunday = 1
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday

  var id: Int { rawValue }

  var shortTitle: String {
    switch self {
    case .sunday: "Sun"
    case .monday: "Mon"
    case .tuesday: "Tue"
    case .wednesday: "Wed"
    case .thursday: "Thu"
    case .friday: "Fri"
    case .saturday: "Sat"
    }
  }
}

