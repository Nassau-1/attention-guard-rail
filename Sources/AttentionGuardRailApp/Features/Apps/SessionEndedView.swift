import SwiftUI

struct SessionEndedView: View {
  @Environment(\.dismiss) private var dismiss
  var item: LauncherItem

  @State private var progress: Double = 0.18
  @State private var selectedExtension = 1
  @State private var canReturn = false

  private let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

  var body: some View {
    VStack(alignment: .leading, spacing: 28) {
      VStack(alignment: .leading, spacing: 10) {
        Text(item.title)
          .font(.title2)
        Text(canReturn ? "You can now return to the app." : "The time you decided to spend here is up.")
          .font(.title)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }

      Spacer()

      if !canReturn {
        ProgressRing(progress: progress)
          .frame(width: 190, height: 190)
          .frame(maxWidth: .infinity)
      }

      Spacer()

      if !canReturn {
        Button {
          dismiss()
        } label: {
          Text("Take me out of here")
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)

        VStack(alignment: .leading, spacing: 12) {
          Text("More time")
            .foregroundStyle(.secondary)
          HStack {
            ExtensionChip(minutes: 15, selectedMinutes: $selectedExtension)
            Spacer()
            ExtensionChip(minutes: 5, selectedMinutes: $selectedExtension)
            Spacer()
            ExtensionChip(minutes: 1, selectedMinutes: $selectedExtension)
          }
        }
      }
    }
    .padding(24)
    .background(Color.black.ignoresSafeArea())
    .preferredColorScheme(.dark)
    .onReceive(timer) { _ in
      guard !canReturn else { return }
      progress += 0.01
      if progress >= 1 {
        canReturn = true
      }
    }
  }
}

private struct ExtensionChip: View {
  var minutes: Int
  @Binding var selectedMinutes: Int

  var body: some View {
    Button {
      selectedMinutes = minutes
    } label: {
      Text("\(minutes) min")
        .font(.title3.weight(.medium))
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.white.opacity(0.10), in: Capsule())
        .overlay {
          if selectedMinutes == minutes {
            Capsule()
              .stroke(.white, lineWidth: 2)
              .shadow(color: .yellow.opacity(0.8), radius: 12)
          }
        }
    }
    .foregroundStyle(.white)
  }
}

private struct ProgressRing: View {
  var progress: Double

  var body: some View {
    ZStack {
      Circle()
        .stroke(.white.opacity(0.08), lineWidth: 10)
      Circle()
        .trim(from: 0.08, to: max(0.08, progress))
        .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
        .rotationEffect(.degrees(-90))
        .animation(.linear(duration: 0.03), value: progress)
    }
  }
}

#Preview {
  SessionEndedView(item: LauncherItem.defaults[1])
}
