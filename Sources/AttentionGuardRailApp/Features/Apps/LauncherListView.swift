import SwiftUI

struct LauncherListView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    List {
      Section("Launcher") {
        ForEach(appState.launcherItems) { item in
          LauncherRow(item: item)
            .contentShape(Rectangle())
            .onTapGesture {
              appState.pendingLaunch = item
            }
        }
      }

      Section("Notes") {
        Text("iOS only opens apps that expose URL schemes or universal links. Keep this launcher curated instead of trying to enumerate every installed app.")
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

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: item.systemImage)
        .frame(width: 24)
      VStack(alignment: .leading, spacing: 3) {
        Text(item.title)
        Text(item.frictionLevel.title)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      Spacer()
      Image(systemName: "chevron.right")
        .font(.caption)
        .foregroundStyle(.tertiary)
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  LauncherListView()
    .environment(AppState())
}

