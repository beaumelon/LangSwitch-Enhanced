//
//  SettingsView.swift
//  LangSwitch
//

import AppKit
import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared
    @ObservedObject private var accessibility = AccessibilityPermissionMonitor.shared
    @State private var globeKeyNeedsSetup = GlobeKeyConfigurator.needsConfiguration
    @State private var inputSourceShortcutDisabled = InputSourceHotkey.isNextInputSourceHotkeyDisabled

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            settingsHeader

            permissionsSection

            if globeKeyNeedsSetup {
                globeKeySetupBanner
            }

            if inputSourceShortcutDisabled {
                inputSourceShortcutBanner
            }

            SettingsSectionCard(title: L10n.t(.sectionLanguage), systemImage: "character.bubble") {
                HStack {
                    Text(L10n.t(.appLanguage))
                    Spacer()
                    Picker("", selection: $settings.appLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(maxWidth: 180)
                }
            }

            SettingsSectionCard(title: L10n.t(.sectionGeneral), systemImage: "slider.horizontal.3") {
                VStack(alignment: .leading, spacing: 6) {
                    Toggle(L10n.t(.showStatusBarIcon), isOn: $settings.statusBarVisible)
                    SettingsHelpText(text: L10n.t(.statusBarIconHelp))
                }
                Toggle(L10n.t(.launchAtLogin), isOn: $settings.launchAtLogin)
            }

            SettingsSectionCard(title: L10n.t(.sectionSwitching), systemImage: "globe") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(L10n.t(.switchDebounce))
                        Spacer()
                        SettingsValueBadge(
                            text: "\(Int(settings.switchDebounceMs)) \(L10n.t(.timeUnitMs))"
                        )
                    }
                    Slider(value: $settings.switchDebounceMs, in: 50...300, step: 10)
                        .tint(.accentColor)
                    SettingsHelpText(text: L10n.t(.debounceHelp))
                }

                Divider().opacity(0.5)

                Toggle(L10n.t(.showSwitchHUD), isOn: $settings.showSwitchHUD)

                Divider().opacity(0.5)

                VStack(alignment: .leading, spacing: 6) {
                    Toggle(L10n.t(.syncMenuBarIcon), isOn: $settings.syncMenuBarIcon)
                    SettingsHelpText(text: L10n.t(.syncHelp))
                }
            }

            SettingsSectionCard(title: L10n.t(.sectionAbout), systemImage: "info.circle") {
                HStack {
                    Text(L10n.t(.version))
                    Spacer()
                    Text(appVersion)
                        .font(.callout.weight(.medium).monospacedDigit())
                        .secondaryForeground()
                }
            }
        }
        .padding(24)
        .frame(minWidth: 500, maxWidth: .infinity, alignment: .leading)
        .onAppear {
            accessibility.refresh()
            refreshKeyboardSetupStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            refreshKeyboardSetupStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: SettingsWindowController.settingsDidRefreshNotification)) { _ in
            refreshKeyboardSetupStatus()
        }
    }

    private var permissionsSection: some View {
        SettingsSectionCard(title: L10n.t(.sectionPermissions), systemImage: "lock.shield") {
            if accessibility.isGranted {
                HStack(alignment: .center, spacing: 12) {
                    SettingsStatusBadge(
                        granted: true,
                        grantedText: L10n.t(.accessibilityGranted),
                        deniedText: L10n.t(.accessibilityDenied)
                    )
                    Spacer()
                }
                SettingsHelpText(text: L10n.t(.accessibilityHelp))
            } else {
                SettingsWarningBanner(
                    title: L10n.t(.accessibilityRequiredTitle),
                    message: L10n.t(.accessibilityDeniedWarning),
                    actionTitle: L10n.t(.openSystemSettings),
                    action: {
                        accessibility.refreshAfterOpeningSystemSettings()
                        openPrivacySettings()
                    }
                )
                SettingsHelpText(text: L10n.t(.accessibilitySetupSteps))
            }
        }
    }

    private var globeKeySetupBanner: some View {
        SettingsWarningBanner(
            title: L10n.t(.globeKeySetupTitle),
            message: L10n.t(.globeKeySetupMessage),
            actionTitle: L10n.t(.globeKeySetupOpenKeyboard),
            action: {
                GlobeKeyConfigurator.openKeyboardSettings()
                refreshKeyboardSetupStatus()
            }
        )
    }

    private var inputSourceShortcutBanner: some View {
        SettingsWarningBanner(
            title: L10n.t(.inputSourceShortcutDisabledTitle),
            message: L10n.t(.inputSourceShortcutDisabledMessage),
            actionTitle: L10n.t(.globeKeySetupOpenKeyboard),
            action: {
                GlobeKeyConfigurator.openKeyboardSettings()
                refreshKeyboardSetupStatus()
            }
        )
    }

    private func refreshKeyboardSetupStatus() {
        globeKeyNeedsSetup = GlobeKeyConfigurator.needsConfiguration
        inputSourceShortcutDisabled = InputSourceHotkey.isNextInputSourceHotkeyDisabled
    }

    private var settingsHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor.opacity(0.22), Color.accentColor.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(Color.accentColor)
            }

            Text("LangSwitch")
                .font(.title2.weight(.semibold))

            Spacer()
        }
        .padding(.bottom, 4)
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private func openPrivacySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
}

#Preview {
    ScrollView {
        SettingsView()
    }
}
