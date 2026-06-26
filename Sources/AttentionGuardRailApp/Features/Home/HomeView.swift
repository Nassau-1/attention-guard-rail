import SwiftUI

struct HomeView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 8) {
          Text(Date.now, style: .time)
            .font(.system(size: 56, weight: .semibold, design: .rounded))
            .monospacedDigit()
          Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
            .font(.title3)
            .foregroundStyle(.secondary)
        }

        VStack(alignment: .leading, spacing: 12) {
          Text("Widgets")
            .font(.headline)
          WidgetInstructionRow(title: "Top", detail: "Add the Guard Time widget above the dock.")
          WidgetInstructionRow(title: "Launcher", detail: "Add the Guard Launcher widget below it.")
        }

        VStack(alignment: .leading, spacing: 12) {
          Text("Default launcher")
            .font(.headline)

          ForEach(appState.launcherItems) { item in
            Label(item.title, systemImage: item.systemImage)
              .font(.body)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.vertical, 6)
          }
        }
      }
      .padding(20)
    }
    .navigationTitle("Attention Guard Rail")
    .background(Color.black)
  }
}

private struct WidgetInstructionRow: View {
  var title: String
  var detail: String

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.subheadline.weight(.semibold))
      Text(detail)
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(12)
    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
  }
}

#Preview {
  HomeView()
    .environment(AppState())
}

