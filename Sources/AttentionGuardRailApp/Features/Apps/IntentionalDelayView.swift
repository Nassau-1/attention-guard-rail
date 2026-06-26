import SwiftUI

struct IntentionalDelayView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.openURL) private var openURL

  var item: LauncherItem

  @State private var progress: Double = 0
  @State private var selectedMinutes = 5
  @State private var isReady = false

  private let delaySeconds = 15.0
  private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

  var body: some View {
    VStack(spacing: 24) {
      Spacer()

      Image(systemName: item.systemImage)
        .font(.system(size: 44, weight: .medium))

      VStack(spacing: 8) {
        Text(item.title)
          .font(.largeTitle.weight(.semibold))
        Text("Choose a session length before opening.")
          .font(.body)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
      }

      ProgressRing(progress: progress)
        .frame(width: 124, height: 124)

      Picker("Minutes", selection: $selectedMinutes) {
        Text("5 min").tag(5)
        Text("10 min").tag(10)
        Text("15 min").tag(15)
      }
      .pickerStyle(.segmented)

      Button {
        openURL(item.primaryURL) { accepted in
          if !accepted, let fallbackURL = item.fallbackURL {
            openURL(fallbackURL)
          }
          dismiss()
        }
      } label: {
        Label(isReady ? "Open for \(selectedMinutes) min" : "Wait", systemImage: isReady ? "arrow.up.right" : "hourglass")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .disabled(!isReady)

      Button("Cancel") {
        dismiss()
      }
      .buttonStyle(.plain)
      .foregroundStyle(.secondary)

      Spacer()
    }
    .padding(24)
    .preferredColorScheme(.dark)
    .presentationDetents([.large])
    .onReceive(timer) { _ in
      guard !isReady else { return }
      progress = min(1, progress + 0.1 / delaySeconds)
      isReady = progress >= 1
    }
  }
}

private struct ProgressRing: View {
  var progress: Double

  var body: some View {
    ZStack {
      Circle()
        .stroke(.white.opacity(0.16), lineWidth: 10)
      Circle()
        .trim(from: 0, to: progress)
        .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
        .rotationEffect(.degrees(-90))
        .animation(.linear(duration: 0.1), value: progress)
    }
  }
}

#Preview {
  IntentionalDelayView(item: LauncherItem.defaults[1])
}

