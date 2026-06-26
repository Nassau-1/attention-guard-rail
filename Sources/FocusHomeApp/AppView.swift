import SwiftUI

struct AppView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    @Bindable var appState = appState

    TabView(selection: $appState.selectedTab) {
      NavigationStack {
        HomeView()
      }
      .tabItem { Label("Home", systemImage: "rectangle.grid.1x2") }
      .tag(AppTab.home)

      NavigationStack {
        LauncherListView()
      }
      .tabItem { Label("Apps", systemImage: "text.justify") }
      .tag(AppTab.apps)

      NavigationStack {
        FocusView()
      }
      .tabItem { Label("Focus", systemImage: "lock.shield") }
      .tag(AppTab.focus)
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
    .sheet(item: $appState.pendingLaunch) { item in
      IntentionalDelayView(item: item)
    }
  }
}

