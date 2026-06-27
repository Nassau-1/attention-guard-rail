import SwiftUI

@main
@MainActor
struct AttentionGuardRailApp: App {
  @State private var appState = AppState()

  var body: some Scene {
    WindowGroup {
      AppView()
        .environment(appState)
        .onOpenURL { url in
          appState.route(url)
        }
    }
  }
}
