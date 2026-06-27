import SwiftUI

struct SettingsView: View {
  var body: some View {
    List {
      Section("Home screen") {
        NavigationLink {
          SetupInstructionsView()
        } label: {
          Text("Setup instructions")
        }
      }

      Section("More") {
        NavigationLink {
          Text("Support email will be wired later.")
            .foregroundStyle(.secondary)
            .navigationTitle("Contact support")
        } label: {
          VStack(alignment: .leading, spacing: 3) {
            Text("Contact support")
            Text("Open email client")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }

        VStack(alignment: .leading, spacing: 3) {
          Text("Version")
          Text("0.1.0")
            .font(.caption)
            .foregroundStyle(.secondary)
        }

        NavigationLink {
          Text("No account is required for the MVP.")
            .foregroundStyle(.secondary)
            .navigationTitle("Account")
        } label: {
          Text("Account")
        }
      }
    }
    .navigationTitle("Settings")
    .scrollContentBackground(.hidden)
    .background(Color.black.ignoresSafeArea())
  }
}

private struct SetupInstructionsView: View {
  var body: some View {
    List {
      Section("Widgets") {
        InstructionRow(number: "1", title: "Add Guard Time", detail: "Place it at the top of the first home screen.")
        InstructionRow(number: "2", title: "Add Guard Launcher", detail: "Place it below the time widget.")
      }

      Section("iPhone cleanup") {
        InstructionRow(number: "3", title: "Keep the dock intentional", detail: "Leave only tools you are comfortable opening directly.")
        InstructionRow(number: "4", title: "Hide noisy pages", detail: "Move distracting apps away from the first home screen.")
        InstructionRow(number: "5", title: "Reduce badges", detail: "Use iOS notification settings for apps that trigger checking loops.")
      }
    }
    .navigationTitle("Setup")
    .scrollContentBackground(.hidden)
    .background(Color.black.ignoresSafeArea())
  }
}

private struct InstructionRow: View {
  var number: String
  var title: String
  var detail: String

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Text(number)
        .font(.headline)
        .frame(width: 30, height: 30)
        .background(.white.opacity(0.16), in: Circle())
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
        Text(detail)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .padding(.vertical, 3)
  }
}

#Preview {
  NavigationStack {
    SettingsView()
  }
}
