import SwiftUI

struct AppView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    @Bindable var appState = appState

    TabView(selection: $appState.selectedTab) {
      NavigationStack {
        HomeView()
      }
      .tabItem { Label("Home", systemImage: "iphone") }
      .tag(AppTab.home)

      NavigationStack {
        FocusView()
      }
      .tabItem { Label("Focus", systemImage: "brain.head.profile") }
      .tag(AppTab.focus)

      NavigationStack {
        SettingsView()
      }
      .tabItem { Label("Settings", systemImage: "gearshape") }
      .tag(AppTab.settings)
    }
    .tint(.white)
    .toolbarBackground(.black, for: .tabBar)
    .toolbarBackground(.visible, for: .tabBar)
    .preferredColorScheme(.dark)
    .sheet(item: $appState.pendingLaunch) { item in
      IntentionalDelayView(item: item)
    }
  }
}
