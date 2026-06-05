//
//  InputSourceHotkey.swift
//  LangSwitch
//

import Carbon
import CoreGraphics
import Foundation

/// Posts the system "Select next source in Input menu" shortcut (symbolichotkeys key 61).
/// TISSelectInputSource only updates the menu bar icon for CJK IMEs; the system shortcut
/// activates the input method in the focused app.
enum InputSourceHotkey {
    private static let nextInputSourceHotkeyID = 61
    private static let menuBarSyncRetryStep: TimeInterval = 0.04
    private static let menuBarSyncMaxAttempt = 4
    private static let hudRetryDelay: TimeInterval = 0.05

    static func selectNextInputSource() {
        let beforeID = InputSourceList.currentID()
        let expectedNext = InputSourceList.next(after: beforeID)
        post(nextInputSourceShortcut())
        if AppSettings.shared.syncMenuBarIcon {
            scheduleMenuBarSync(beforeID: beforeID, expectedNext: expectedNext, attempt: 0) {
                presentSwitchHUD(beforeID: beforeID, expectedNext: expectedNext)
            }
        } else {
            scheduleSwitchHUD(beforeID: beforeID, expectedNext: expectedNext, attempt: 0)
        }
    }

    /// CGEvent updates typing; a follow-up TIS select refreshes the menu bar icon.
    private static func scheduleMenuBarSync(
        beforeID: String?,
        expectedNext: TISInputSource?,
        attempt: Int,
        completion: @escaping () -> Void
    ) {
        let delay = TimeInterval(attempt) * menuBarSyncRetryStep
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let synced = syncMenuBarIcon(beforeID: beforeID, expectedNext: expectedNext, attempt: attempt)
            if !synced, attempt < menuBarSyncMaxAttempt {
                scheduleMenuBarSync(
                    beforeID: beforeID,
                    expectedNext: expectedNext,
                    attempt: attempt + 1,
                    completion: completion
                )
            } else {
                completion()
            }
        }
    }

    private static func scheduleSwitchHUD(
        beforeID: String?,
        expectedNext: TISInputSource?,
        attempt: Int
    ) {
        let delay = TimeInterval(attempt) * menuBarSyncRetryStep
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let current = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue(),
               beforeID == nil || current.id != beforeID {
                presentSwitchHUD(beforeID: beforeID, expectedNext: expectedNext)
                return
            }
            if attempt < menuBarSyncMaxAttempt {
                scheduleSwitchHUD(beforeID: beforeID, expectedNext: expectedNext, attempt: attempt + 1)
            } else {
                presentSwitchHUD(beforeID: beforeID, expectedNext: expectedNext)
            }
        }
    }

    private static func presentSwitchHUD(beforeID: String?, expectedNext: TISInputSource?) {
        let name = resolvedSwitchDisplayName(beforeID: beforeID, expectedNext: expectedNext)
        if !name.isEmpty {
            SwitchHUD.show(text: name)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + hudRetryDelay) {
            let retryName = resolvedSwitchDisplayName(beforeID: beforeID, expectedNext: expectedNext)
            if !retryName.isEmpty {
                SwitchHUD.show(text: retryName)
            }
        }
    }

    private static func resolvedSwitchDisplayName(
        beforeID: String?,
        expectedNext: TISInputSource?
    ) -> String {
        if let current = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue(),
           beforeID == nil || current.id != beforeID {
            let name = current.localizedName
            if !name.isEmpty {
                return name
            }
        }
        if let expectedNext {
            return expectedNext.localizedName
        }
        if let current = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() {
            return current.localizedName
        }
        return ""
    }

    @discardableResult
    private static func syncMenuBarIcon(
        beforeID: String?,
        expectedNext: TISInputSource?,
        attempt: Int
    ) -> Bool {
        if let active = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue(),
           beforeID == nil || active.id != beforeID {
            TISSelectInputSource(active)
            return true
        }
        // CGEvent may still be pending; on the last attempt align the menu bar to the expected target.
        if attempt >= menuBarSyncMaxAttempt, let expectedNext {
            TISSelectInputSource(expectedNext)
            return true
        }
        return false
    }

    static func nextInputSourceShortcut() -> KeyboardShortcut {
        guard let shortcut = loadSymbolicHotkey(id: nextInputSourceHotkeyID) else {
            // Default on many macOS installs: Control+Option+Space
            return KeyboardShortcut(
                keyCode: CGKeyCode(kVK_Space),
                modifiers: [.maskControl, .maskAlternate]
            )
        }
        return shortcut
    }

    static func post(_ shortcut: KeyboardShortcut) {
        guard let source = CGEventSource(stateID: .hidSystemState) else {
            return
        }

        let tap = CGEventTapLocation.cghidEventTap
        let modifierKeys = modifierVirtualKeys(for: shortcut.modifiers)

        for key in modifierKeys {
            guard let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true) else {
                continue
            }
            event.flags = shortcut.modifiers
            event.post(tap: tap)
        }

        guard let keyDown = CGEvent(
            keyboardEventSource: source,
            virtualKey: shortcut.keyCode,
            keyDown: true
        ),
        let keyUp = CGEvent(
            keyboardEventSource: source,
            virtualKey: shortcut.keyCode,
            keyDown: false
        ) else {
            return
        }

        keyDown.flags = shortcut.modifiers
        keyUp.flags = shortcut.modifiers
        keyDown.post(tap: tap)
        keyUp.post(tap: tap)

        for key in modifierKeys.reversed() {
            guard let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false) else {
                continue
            }
            event.flags = shortcut.modifiers
            event.post(tap: tap)
        }
    }

    private static func isHotkeyEnabled(_ value: Any?) -> Bool {
        if let enabled = value as? Bool {
            return enabled
        }
        if let enabled = value as? Int {
            return enabled != 0
        }
        return false
    }

    private static func loadSymbolicHotkey(id: Int) -> KeyboardShortcut? {
        let plistURL = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Preferences/com.apple.symbolichotkeys.plist")

        guard let plist = NSDictionary(contentsOf: plistURL),
              let hotkeys = plist["AppleSymbolicHotKeys"] as? [String: Any],
              let entry = hotkeys[String(id)] as? [String: Any],
              isHotkeyEnabled(entry["enabled"]),
              let value = entry["value"] as? [String: Any],
              let parameters = value["parameters"] as? [Int],
              parameters.count >= 3 else {
            return nil
        }

        let keyCode = CGKeyCode(resolveVirtualKeyCode(parameters[0], parameters[1]))
        let modifiers = cgEventFlags(fromSymbolicModifiers: parameters[2])
        return KeyboardShortcut(keyCode: keyCode, modifiers: modifiers)
    }

    private static func resolveVirtualKeyCode(_ param0: Int, _ param1: Int) -> Int {
        if param0 == 65535 || param0 == -1 {
            return param1
        }
        // When param0 is the ASCII code (e.g. 32 for space), param1 is the virtual key.
        if param1 == kVK_Space {
            return param1
        }
        return param0 == 0 ? param1 : param0
    }

    private static func cgEventFlags(fromSymbolicModifiers value: Int) -> CGEventFlags {
        var flags: CGEventFlags = []
        if value & 131_072 != 0 { flags.insert(.maskShift) }
        if value & 262_144 != 0 { flags.insert(.maskControl) }
        if value & 524_288 != 0 { flags.insert(.maskAlternate) }
        if value & 1_048_576 != 0 { flags.insert(.maskCommand) }
        return flags
    }

    private static func modifierVirtualKeys(for flags: CGEventFlags) -> [CGKeyCode] {
        var keys: [CGKeyCode] = []
        if flags.contains(.maskControl) { keys.append(CGKeyCode(kVK_Control)) }
        if flags.contains(.maskAlternate) { keys.append(CGKeyCode(kVK_Option)) }
        if flags.contains(.maskShift) { keys.append(CGKeyCode(kVK_Shift)) }
        if flags.contains(.maskCommand) { keys.append(CGKeyCode(kVK_Command)) }
        return keys
    }
}

struct KeyboardShortcut {
    let keyCode: CGKeyCode
    let modifiers: CGEventFlags
}

private enum InputSourceList {
    static func currentID() -> String? {
        guard let current = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else {
            return nil
        }
        return current.id
    }

    static func next(after currentID: String?) -> TISInputSource? {
        let sources = enabledKeyboardSources()
        guard !sources.isEmpty else {
            return nil
        }
        guard let currentID,
              let index = sources.firstIndex(where: { $0.id == currentID }) else {
            return sources.first
        }
        return sources[(index + 1) % sources.count]
    }

    static func enabledKeyboardSources() -> [TISInputSource] {
        let list = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray as! [TISInputSource]
        return list.filter {
            $0.category == (kTISCategoryKeyboardInputSource as String) &&
            $0.isSelectable &&
            $0.isEnabled
        }
    }
}

private extension TISInputSource {
    var id: String {
        guard let value = TISGetInputSourceProperty(self, kTISPropertyInputSourceID) else {
            return ""
        }
        return Unmanaged<CFString>.fromOpaque(value).takeUnretainedValue() as String
    }

    var localizedName: String {
        if let value = TISGetInputSourceProperty(self, kTISPropertyLocalizedName) {
            let name = Unmanaged<CFString>.fromOpaque(value).takeUnretainedValue() as String
            if !name.isEmpty {
                return name
            }
        }
        return id
    }

    var category: String {
        guard let value = TISGetInputSourceProperty(self, kTISPropertyInputSourceCategory) else {
            return ""
        }
        return Unmanaged<CFString>.fromOpaque(value).takeUnretainedValue() as String
    }

    var isSelectable: Bool {
        guard let value = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsSelectCapable) else {
            return false
        }
        return Unmanaged<CFBoolean>.fromOpaque(value).takeUnretainedValue() == kCFBooleanTrue
    }

    var isEnabled: Bool {
        guard let value = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsEnabled) else {
            return false
        }
        return Unmanaged<CFBoolean>.fromOpaque(value).takeUnretainedValue() == kCFBooleanTrue
    }
}
