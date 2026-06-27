import SwiftUI

struct LauncherListView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    List {
      Section("Launcher widget") {
        ForEach(appState.launcherItems) { item in
          Toggle(isOn: Binding(
            get: { appState.isInLauncher(item) },
            set: { appState.setLauncher(item, isSelected: $0) }
          )) {
            LauncherRow(item: item, detail: appState.isDelayed(item) ? "Widget row, delayed opening" : "Widget row, direct opening")
          }
        }
      }

      Section("Delayed opening") {
        ForEach(appState.launcherItems) { item in
          HStack(spacing: 12) {
            Toggle(isOn: Binding(
              get: { appState.isDelayed(item) },
              set: { appState.setDelayed(item, isSelected: $0) }
            )) {
              LauncherRow(item: item, detail: item.frictionLevel.title)
            }

            Button {
              appState.pendingLaunch = item
            } label: {
              Image(systemName: "hourglass")
                .frame(width: 30, height: 30)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Test \(item.title) delay")
          }
        }
      }

      Section("Current limit") {
        Label("Native app selection will use the iOS Screen Time picker. This build uses curated app rows so the widget and delay flow can be tested first.", systemImage: "info.circle")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
    }
    .navigationTitle("Apps")
    .scrollContentBackground(.hidden)
    .background(Color.black)
  }
}

private struct LauncherRow: View {
  var item: LauncherItem
  var detail: String

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: item.systemImage)
        .frame(width: 24)
      VStack(alignment: .leading, spacing: 3) {
        Text(item.title)
        Text(detail)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      Spacer()
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  LauncherListView()
    .environment(AppState())
}
