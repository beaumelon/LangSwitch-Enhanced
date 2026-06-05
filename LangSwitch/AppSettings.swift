//
//  AppSettings.swift
//  LangSwitch
//

import Combine
import Foundation
import ServiceManagement

final class AppSettings: ObservableObject {
    static let shared = AppSettings()
    static let didChangeNotification = Notification.Name("AppSettingsDidChange")

    private enum Keys {
        static let statusBarVisible = "statusBarIconVisible"
        static let launchAtLogin = "launchAtLogin"
        static let switchDebounceMs = "switchDebounceMs"
        static let showSwitchHUD = "showSwitchHUD"
        static let syncMenuBarIcon = "syncMenuBarIcon"
        static let appLanguage = "appLanguage"
    }

    @Published var statusBarVisible: Bool {
        didSet {
            guard statusBarVisible != oldValue else { return }
            UserDefaults.standard.set(statusBarVisible, forKey: Keys.statusBarVisible)
            notifyChange()
        }
    }

    @Published var launchAtLogin: Bool {
        didSet {
            guard launchAtLogin != oldValue else { return }
            UserDefaults.standard.set(launchAtLogin, forKey: Keys.launchAtLogin)
            applyLaunchAtLogin(launchAtLogin)
            notifyChange()
        }
    }

    @Published var switchDebounceMs: Double {
        didSet {
            let clamped = min(max(switchDebounceMs, 50), 300)
            if clamped != switchDebounceMs {
                switchDebounceMs = clamped
                return
            }
            UserDefaults.standard.set(switchDebounceMs, forKey: Keys.switchDebounceMs)
            notifyChange()
        }
    }

    @Published var showSwitchHUD: Bool {
        didSet {
            guard showSwitchHUD != oldValue else { return }
            UserDefaults.standard.set(showSwitchHUD, forKey: Keys.showSwitchHUD)
            notifyChange()
        }
    }

    @Published var syncMenuBarIcon: Bool {
        didSet {
            guard syncMenuBarIcon != oldValue else { return }
            UserDefaults.standard.set(syncMenuBarIcon, forKey: Keys.syncMenuBarIcon)
            notifyChange()
        }
    }

    @Published var appLanguage: AppLanguage {
        didSet {
            guard appLanguage != oldValue else { return }
            UserDefaults.standard.set(appLanguage.rawValue, forKey: Keys.appLanguage)
            notifyChange()
        }
    }

    var switchDebounce: TimeInterval {
        switchDebounceMs / 1000
    }

    private init() {
        let defaults = UserDefaults.standard
        statusBarVisible = defaults.object(forKey: Keys.statusBarVisible) as? Bool ?? true
        switchDebounceMs = defaults.object(forKey: Keys.switchDebounceMs) as? Double ?? 60
        showSwitchHUD = defaults.object(forKey: Keys.showSwitchHUD) as? Bool ?? false
        syncMenuBarIcon = defaults.object(forKey: Keys.syncMenuBarIcon) as? Bool ?? true
        appLanguage = AppLanguage.from(stored: defaults.string(forKey: Keys.appLanguage))

        if let savedLaunch = defaults.object(forKey: Keys.launchAtLogin) as? Bool {
            launchAtLogin = savedLaunch
        } else {
            launchAtLogin = Self.systemLaunchAtLoginEnabled()
        }
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
    }

    private static func systemLaunchAtLoginEnabled() -> Bool {
        SMAppService.mainApp.status == .enabled
    }

    private func applyLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Launch at login failed: \(error)")
            DispatchQueue.main.async {
                self.launchAtLogin = Self.systemLaunchAtLoginEnabled()
            }
        }
    }
}
