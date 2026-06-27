import SwiftUI

struct HomeView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        HomeHeader()

        SetupCard(title: "Home screen", systemImage: "rectangle.grid.1x2") {
          SetupRow(status: .ready, title: "Guard Time", detail: "Top widget: time and day.")
          SetupRow(status: .ready, title: "Guard Launcher", detail: "\(appState.launcherWidgetItems.count) selected rows.")
        }

        SetupCard(title: "Launcher rows", systemImage: "text.justify") {
          ForEach(appState.launcherWidgetItems) { item in
            HStack(spacing: 12) {
              Image(systemName: item.systemImage)
                .frame(width: 22)
              Text(item.title)
                .font(.body.weight(.medium))
              Spacer()
              Text(appState.isDelayed(item) ? "Delay" : "Direct")
                .font(.caption.weight(.medium))
                .foregroundStyle(appState.isDelayed(item) ? .yellow : .secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
          }
        }

        SetupCard(title: "Setup checklist", systemImage: "checklist") {
          SetupRow(status: .manual, title: "Add both widgets", detail: "Place Guard Time above Guard Launcher on the iPhone home screen.")
          SetupRow(status: .manual, title: "Choose protected apps", detail: "Use Focus to pick reminder and blocking apps.")
          SetupRow(status: .ready, title: "Screen Time picker", detail: "Focus opens the native picker and stores its selection in the App Group.")
        }
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(.white)
    }
    .navigationTitle("Home")
    .background(Color.black.ignoresSafeArea())
  }
}

private struct HomeHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Attention Guard Rail")
        .font(.title.weight(.semibold))
      Text("Your iPhone home screen stays minimal. The app only configures widgets, delays, and blocking rules.")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct SetupCard<Content: View>: View {
  var title: String
  var systemImage: String
  @ViewBuilder var content: Content

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Label(title, systemImage: systemImage)
        .font(.headline)
      content
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(14)
    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
  }
}

private struct SetupRow: View {
  var status: SetupStatus
  var title: String
  var detail: String

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: status.systemImage)
        .foregroundStyle(status.color)
        .frame(width: 20)
      VStack(alignment: .leading, spacing: 3) {
        Text(title)
          .font(.subheadline.weight(.semibold))
        Text(detail)
          .font(.footnote)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 2)
  }
}

private enum SetupStatus {
  case ready
  case manual
  case pending

  var systemImage: String {
    switch self {
    case .ready: "checkmark.circle.fill"
    case .manual: "hand.tap.fill"
    case .pending: "circle.dashed"
    }
  }

  var color: Color {
    switch self {
    case .ready: .green
    case .manual: .white
    case .pending: .secondary
    }
  }
}

#Preview {
  HomeView()
    .environment(AppState())
}
