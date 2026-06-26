import SwiftUI

struct FocusView: View {
  @Environment(AppState.self) private var appState
  @State private var screenTimeService = ScreenTimeService()

  var body: some View {
    List {
      Section("Permission") {
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("Screen Time")
            Text(screenTimeService.authorizationState.title)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Button("Allow") {
            Task { await screenTimeService.requestAuthorization() }
          }
          .buttonStyle(.bordered)
        }
      }

      Section("Blocked apps") {
        Button {
          screenTimeService.applyShield()
        } label: {
          Label("Apply current shield", systemImage: "lock.fill")
        }

        Text("The production version should present FamilyActivityPicker here so you can select apps and categories directly from iOS.")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }

      Section("Schedules") {
        ForEach(appState.focusRules) { rule in
          VStack(alignment: .leading, spacing: 6) {
            HStack {
              Text(rule.name)
                .font(.headline)
              Spacer()
              Text(rule.isEnabled ? "On" : "Off")
                .font(.caption)
                .foregroundStyle(rule.isEnabled ? .green : .secondary)
            }
            Text("\(formattedTime(rule.startHour, rule.startMinute)) - \(formattedTime(rule.endHour, rule.endMinute))")
              .font(.subheadline)
              .foregroundStyle(.secondary)
            Text(rule.days.map(\.shortTitle).joined(separator: " "))
              .font(.caption)
              .foregroundStyle(.tertiary)
          }
          .padding(.vertical, 4)
        }
      }
    }
    .navigationTitle("Focus")
    .scrollContentBackground(.hidden)
    .background(Color.black)
  }

  private func formattedTime(_ hour: Int, _ minute: Int) -> String {
    "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
  }
}

#Preview {
  FocusView()
    .environment(AppState())
}

