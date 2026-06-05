//
//  GlobeKeyConfigurator.swift
//  LangSwitch
//

import AppKit
import Foundation

enum GlobeKeyUsageType: Int {
    case doNothing = 0
    case changeInputSource = 1
    case showEmojiAndSymbols = 2
    case startDictation = 3
}

enum GlobeKeyConfigurator {
    private static let preferencesDomain = "com.apple.HIToolbox" as CFString
    private static let usageTypeKey = "AppleFnUsageType" as CFString
    private static let keyboardSettingsURL =
        URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension")

    static func currentUsageType() -> GlobeKeyUsageType? {
        guard let value = CFPreferencesCopyValue(
            usageTypeKey,
            preferencesDomain,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        ) else {
            return nil
        }

        guard CFGetTypeID(value) == CFNumberGetTypeID() else {
            return nil
        }

        var intValue: Int32 = 0
        guard CFNumberGetValue((value as! CFNumber), .sInt32Type, &intValue) else {
            return nil
        }
        return GlobeKeyUsageType(rawValue: Int(intValue))
    }

    static var needsConfiguration: Bool {
        guard let current = currentUsageType() else {
            return false
        }
        return current != .doNothing
    }

    static func openKeyboardSettings() {
        guard let keyboardSettingsURL else {
            return
        }
        NSWorkspace.shared.open(keyboardSettingsURL)
    }
}
