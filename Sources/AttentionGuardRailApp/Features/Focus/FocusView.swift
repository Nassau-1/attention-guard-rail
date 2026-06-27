import FamilyControls
import SwiftUI

@MainActor
struct FocusView: View {
  @Environment(AppState.self) private var appState
  @State private var screenTimeService = ScreenTimeService()
  @State private var focusMode: FocusMode = FocusMode.initialValue
  @State private var blockingMode: BlockingMode = BlockingMode.initialValue
  @State private var activeSheet: FocusSheet? = FocusSheet.initialValue

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 18) {
        FocusModeHeader(selection: $focusMode)

        switch focusMode {
        case .reminder:
          ReminderConfiguration(
            launchDelayEnabled: Binding(
              get: { appState.isLaunchDelayEnabled },
              set: { appState.isLaunchDelayEnabled = $0 }
            ),
            extensionDelayEnabled: Binding(
              get: { appState.isExtensionDelayEnabled },
              set: { appState.isExtensionDelayEnabled = $0 }
            ),
            items: appState.delayedItems,
            selectedActivityCount: appState.selectedActivityCount,
            addAction: { activeSheet = .activityPicker },
            optionsAction: { activeSheet = .delayOptions },
            sessionEndedPreviewAction: { activeSheet = .sessionEnded }
          )
        case .blocking:
          BlockingConfiguration(
            mode: $blockingMode,
            isBlockingNowEnabled: Binding(
              get: { appState.isBlockingNowEnabled },
              set: { appState.isBlockingNowEnabled = $0 }
            ),
            items: appState.delayedItems,
            selectedActivityCount: appState.selectedActivityCount,
            rules: appState.focusRules,
            addAction: {
              activeSheet = blockingMode == .blockNow ? .activityPicker : .scheduleEditor
            },
            requestPermissionAction: {
              Task { await screenTimeService.requestAuthorization() }
            },
            applyShieldAction: {
              screenTimeService.applyShield(selection: appState.activitySelection)
              appState.isBlockingNowEnabled = true
            },
            clearShieldAction: {
              screenTimeService.clearShield()
              appState.isBlockingNowEnabled = false
            },
            authorizationTitle: screenTimeService.authorizationState.title
          )
        }
      }
      .padding(20)
      .padding(.bottom, 90)
    }
    .navigationTitle("Focus")
    .background(Color.black.ignoresSafeArea())
    .familyActivityPicker(
      isPresented: Binding(
        get: { activeSheet == .activityPicker },
        set: { isPresented in
          if !isPresented, activeSheet == .activityPicker {
            activeSheet = nil
          }
        }
      ),
      selection: Binding(
        get: { appState.activitySelection },
        set: { appState.setActivitySelection($0) }
      )
    )
    .sheet(item: Binding(
      get: { activeSheet == .activityPicker ? nil : activeSheet },
      set: { activeSheet = $0 }
    )) { sheet in
      switch sheet {
      case .activityPicker:
        EmptyView()
      case .scheduleEditor:
        ScheduleEditorMockView(items: appState.delayedItems)
          .presentationDetents([.large])
      case .delayOptions:
        DelayOptionsView(
          launchDelayEnabled: Binding(
            get: { appState.isLaunchDelayEnabled },
            set: { appState.isLaunchDelayEnabled = $0 }
          ),
          extensionDelayEnabled: Binding(
            get: { appState.isExtensionDelayEnabled },
            set: { appState.isExtensionDelayEnabled = $0 }
          )
        )
        .presentationDetents([.medium])
      case .sessionEnded:
        SessionEndedView(item: appState.delayedItems.first ?? LauncherItem.defaults[1])
          .presentationDetents([.large])
      }
    }
  }
}

private enum FocusMode: String, CaseIterable, Identifiable {
  case reminder = "In-app reminder"
  case blocking = "Blocking"

  var id: String { rawValue }

  static var initialValue: FocusMode {
    #if DEBUG
    if let value = ProcessInfo.processInfo.argumentValue(for: "-AGRFocusMode"), let mode = FocusMode(rawValue: value) {
      return mode
    }
    #endif

    return .reminder
  }
}

private enum BlockingMode: String, CaseIterable, Identifiable {
  case blockNow = "Block now"
  case schedules = "Schedules"

  var id: String { rawValue }

  static var initialValue: BlockingMode {
    #if DEBUG
    if let value = ProcessInfo.processInfo.argumentValue(for: "-AGRBlockingMode"), let mode = BlockingMode(rawValue: value) {
      return mode
    }
    #endif

    return .blockNow
  }
}

private enum FocusSheet: String, Identifiable {
  case activityPicker
  case scheduleEditor
  case delayOptions
  case sessionEnded

  var id: String { rawValue }

  static var initialValue: FocusSheet? {
    #if DEBUG
    if let value = ProcessInfo.processInfo.argumentValue(for: "-AGRFocusSheet") {
      return FocusSheet(rawValue: value)
    }
    #endif

    return nil
  }
}

private struct FocusModeHeader: View {
  @Binding var selection: FocusMode

  var body: some View {
    Picker("Focus mode", selection: $selection) {
      ForEach(FocusMode.allCases) { mode in
        Text(mode.rawValue).tag(mode)
      }
    }
    .pickerStyle(.segmented)
  }
}

private struct ReminderConfiguration: View {
  @Binding var launchDelayEnabled: Bool
  @Binding var extensionDelayEnabled: Bool
  var items: [LauncherItem]
  var selectedActivityCount: Int
  var addAction: () -> Void
  var optionsAction: () -> Void
  var sessionEndedPreviewAction: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      InfoBanner(text: "Set a time limit when you open an app. Soft reminders and delays keep the launch intentional.")

      VStack(spacing: 12) {
        if items.isEmpty {
          EmptyStateRow(title: "No apps selected", detail: "Add apps that should ask before opening.")
        } else {
          ForEach(items) { item in
            Toggle(isOn: .constant(true)) {
              Text(item.title)
                .font(.title3)
            }
            .toggleStyle(.switch)
            .padding(14)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
          }
        }
      }

      FloatingAddButton(action: addAction)

      if selectedActivityCount < 4 {
        WarningCard(title: "Add at least 4 activities", detail: "Select more apps, categories, or websites from the native Screen Time picker.")
      }

      Button(action: optionsAction) {
        Label("Options", systemImage: "slider.horizontal.3")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bordered)
      .controlSize(.large)

      Button(action: sessionEndedPreviewAction) {
        Label("Preview session end", systemImage: "timer")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bordered)
      .controlSize(.large)
    }
  }
}

private struct BlockingConfiguration: View {
  @Binding var mode: BlockingMode
  @Binding var isBlockingNowEnabled: Bool
  var items: [LauncherItem]
  var selectedActivityCount: Int
  var rules: [FocusRule]
  var addAction: () -> Void
  var requestPermissionAction: () -> Void
  var applyShieldAction: () -> Void
  var clearShieldAction: () -> Void
  var authorizationTitle: String

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Picker("Blocking mode", selection: $mode) {
        ForEach(BlockingMode.allCases) { mode in
          Text(mode.rawValue).tag(mode)
        }
      }
      .pickerStyle(.segmented)

      FocusCard {
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("Screen Time permission")
            Text(authorizationTitle)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Button("Allow", action: requestPermissionAction)
            .buttonStyle(.bordered)
        }
      }

      switch mode {
      case .blockNow:
        BlockNowView(
          items: items,
          isEnabled: $isBlockingNowEnabled,
          applyShieldAction: applyShieldAction,
          clearShieldAction: clearShieldAction
        )
      case .schedules:
        ScheduleListView(rules: rules)
      }

      FloatingAddButton(action: addAction)

      if selectedActivityCount < 4 {
        WarningCard(title: "Add at least 4 activities", detail: "Select more apps, categories, or websites from the native Screen Time picker.")
      }

      if mode == .blockNow {
        Button(action: applyShieldAction) {
          Text("Block now")
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
      }

      if isBlockingNowEnabled {
        Button(action: clearShieldAction) {
          Label("Stop blocking", systemImage: "lock.open")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
      }
    }
  }
}

private struct BlockNowView: View {
  var items: [LauncherItem]
  @Binding var isEnabled: Bool
  var applyShieldAction: () -> Void
  var clearShieldAction: () -> Void

  var body: some View {
    FocusCard {
      VStack(alignment: .leading, spacing: 16) {
        Text("Apps")
          .font(.caption)
          .foregroundStyle(.secondary)
        ForEach(items) { item in
          HStack {
            Text(item.title)
              .font(.title3)
            Spacer()
            Toggle("", isOn: Binding(
              get: { isEnabled },
              set: { newValue in
                newValue ? applyShieldAction() : clearShieldAction()
              }
            ))
            .labelsHidden()
          }
        }
      }
    }
  }
}

private struct ScheduleListView: View {
  var rules: [FocusRule]

  var body: some View {
    VStack(spacing: 12) {
      ForEach(rules) { rule in
        FocusCard {
          HStack(spacing: 14) {
            Image(systemName: "clock")
              .font(.title3)
            VStack(alignment: .leading, spacing: 5) {
              Text(rule.name)
                .font(.headline)
              Text(rule.days.map(\.shortTitle).joined(separator: " "))
                .font(.caption.weight(.medium))
              Text("\(formattedTime(rule.startHour, rule.startMinute)) - \(formattedTime(rule.endHour, rule.endMinute))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: .constant(rule.isEnabled))
              .labelsHidden()
          }
        }
      }
    }
  }

  private func formattedTime(_ hour: Int, _ minute: Int) -> String {
    "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
  }
}

private struct ActivityPickerMockView: View {
  @Environment(\.dismiss) private var dismiss

  private let categories = [
    ("square.stack.3d.up.fill", "All apps and categories"),
    ("bubble.left.and.heart.fill", "Social media"),
    ("paperplane.fill", "Games"),
    ("popcorn.fill", "Entertainment"),
    ("bag.fill", "Shopping and food"),
    ("paintpalette.fill", "Creativity"),
    ("book.fill", "Information and reading"),
    ("chart.line.uptrend.xyaxis", "Productivity and finance")
  ]

  var body: some View {
    NavigationStack {
      List {
        Section {
          VStack(alignment: .leading, spacing: 10) {
            Text("Choose Activities to Limit")
              .font(.title.weight(.semibold))
            Text("Select distracting apps, categories, and websites.")
              .font(.body)
              .foregroundStyle(.secondary)
          }
          .listRowBackground(Color.clear)
        }

        Section("Select up to 50 apps and 50 websites") {
          ForEach(categories, id: \.1) { category in
            HStack(spacing: 12) {
              Image(systemName: "circle")
                .foregroundStyle(.secondary)
              Image(systemName: category.0)
                .frame(width: 24)
              Text(category.1)
              Spacer()
              Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
            }
          }
        }
      }
      .scrollContentBackground(.hidden)
      .background(Color.black)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "checkmark")
          }
        }
      }
      .preferredColorScheme(.dark)
    }
  }
}

private struct ScheduleEditorMockView: View {
  @Environment(\.dismiss) private var dismiss
  var items: [LauncherItem]

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Text("New schedule")
            .font(.largeTitle.weight(.semibold))
            .foregroundStyle(.secondary)

          FocusCard {
            ScheduleTimeRow(title: "Start", value: "06:30")
            Divider()
            ScheduleTimeRow(title: "End", value: "09:00")
            HStack {
              ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                Text(day)
                  .font(.headline)
                  .frame(width: 38, height: 38)
                  .background(.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 10))
              }
            }
          }

          FocusCard {
            VStack(alignment: .leading, spacing: 14) {
              Text("Block activities")
                .font(.headline)
              FlowChips(items: items)
              Button {
              } label: {
                Label("Select activities", systemImage: "plus.circle")
              }
              .buttonStyle(.bordered)
            }
          }
        }
        .padding(20)
      }
      .background(Color.black)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "checkmark")
          }
        }
      }
      .preferredColorScheme(.dark)
    }
  }
}

private struct DelayOptionsView: View {
  @Environment(\.dismiss) private var dismiss
  @Binding var launchDelayEnabled: Bool
  @Binding var extensionDelayEnabled: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 22) {
      Capsule()
        .frame(width: 42, height: 5)
        .foregroundStyle(.secondary.opacity(0.5))
        .frame(maxWidth: .infinity)

      Toggle("Mindful launch delay", isOn: $launchDelayEnabled)
      Toggle("Mindful extension delay", isOn: $extensionDelayEnabled)

      Spacer()
    }
    .font(.title3)
    .padding(24)
    .background(Color.black)
    .preferredColorScheme(.dark)
  }
}

private struct ScheduleTimeRow: View {
  var title: String
  var value: String

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(value)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.white.opacity(0.22), in: RoundedRectangle(cornerRadius: 10))
    }
    .font(.headline)
  }
}

private struct FlowChips: View {
  var items: [LauncherItem]

  var body: some View {
    HStack {
      ForEach(items.prefix(3)) { item in
        HStack(spacing: 8) {
          Text(item.title)
          Image(systemName: "checkmark.circle")
        }
        .font(.subheadline.weight(.medium))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.white, in: Capsule())
        .foregroundStyle(.black)
      }
    }
  }
}

private struct FocusCard<Content: View>: View {
  @ViewBuilder var content: Content

  var body: some View {
    content
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(16)
      .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
  }
}

private struct InfoBanner: View {
  var text: String

  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      Image(systemName: "info.circle")
      Text(text)
      Spacer()
      Image(systemName: "xmark")
    }
    .font(.subheadline)
    .foregroundStyle(.secondary)
    .padding(12)
    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
  }
}

private struct WarningCard: View {
  var title: String
  var detail: String

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: "exclamationmark.circle")
        .foregroundStyle(.yellow)
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.headline)
        Text(detail)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(.secondary)
    }
    .padding(16)
    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
  }
}

private struct EmptyStateRow: View {
  var title: String
  var detail: String

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.headline)
      Text(detail)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
  }
}

private struct FloatingAddButton: View {
  var action: () -> Void

  var body: some View {
    HStack {
      Spacer()
      Button(action: action) {
        Image(systemName: "plus")
          .font(.title2)
          .frame(width: 54, height: 54)
      }
      .buttonStyle(.bordered)
      .clipShape(RoundedRectangle(cornerRadius: 16))
    }
  }
}

private extension ProcessInfo {
  func argumentValue(for key: String) -> String? {
    guard let index = arguments.firstIndex(of: key), arguments.indices.contains(index + 1) else {
      return nil
    }
    return arguments[index + 1]
  }
}

#Preview {
  FocusView()
    .environment(AppState())
}
