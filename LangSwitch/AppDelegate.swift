//
//  AppDelegate.swift
//  LangSwitch
//

import SwiftUI
import Foundation
import AppKit
import ApplicationServices

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var statusBarItem: NSStatusItem?
    private var todaySummaryMenuItem: NSMenuItem?
    private var weekSummaryMenuItem: NSMenuItem?
    private var viewTrendsMenuItem: NSMenuItem?
    private var settingsMenuItem: NSMenuItem?
    private var quitMenuItem: NSMenuItem?

    private static let hideIconHintShownKey = "didShowHideIconHint"
    private var lastStatusBarVisible = true
    private(set) var globalMonitor: Any?
    private var localMonitor: Any?
    private var lastSwitchTime = Date.distantPast

    var hasGlobalMonitor: Bool {
        globalMonitor != nil
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        EventMonitorStatus.register(self)
        setupStatusBar()
        NSApp.setActivationPolicy(.accessory)
        NSApp.hide(nil)

        lastStatusBarVisible = AppSettings.shared.statusBarVisible
        applySettings()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applySettings),
            name: AppSettings.didChangeNotification,
            object: nil
        )

        installEventMonitors()
        registerForSystemNotifications()
        registerForAppWindowClose()
    }

    func applicationWillTerminate(_ notification: Notification) {
        removeEventMonitors()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        AppSettings.shared.statusBarVisible = true
        NSApp.activate(ignoringOtherApps: true)
        return true
    }

    private func setupStatusBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem?.button?.image = NSImage(systemSymbolName: "globe", accessibilityDescription: nil)

        let menu = NSMenu()
        menu.delegate = self

        let todaySummary = NSMenuItem()
        todaySummary.isEnabled = false
        todaySummaryMenuItem = todaySummary
        menu.addItem(todaySummary)

        let weekSummary = NSMenuItem()
        weekSummary.isEnabled = false
        weekSummaryMenuItem = weekSummary
        menu.addItem(weekSummary)

        let viewTrendsItem = NSMenuItem(title: "", action: #selector(showStatisticsPanel), keyEquivalent: "t")
        viewTrendsMenuItem = viewTrendsItem
        menu.addItem(viewTrendsItem)

        menu.addItem(.separator())

        let settingsItem = NSMenuItem(title: "", action: #selector(openSettings), keyEquivalent: ",")
        settingsMenuItem = settingsItem
        menu.addItem(settingsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "", action: #selector(exitAction), keyEquivalent: "q")
        quitMenuItem = quitItem
        menu.addItem(quitItem)

        configureMenuActions(menu)
        statusBarItem?.menu = menu
        updateMenuTitles()
    }

    private func configureMenuActions(_ menu: NSMenu) {
        for item in menu.items where item.action != nil {
            item.target = self
        }
    }

    @objc private func applySettings() {
        let newVisible = AppSettings.shared.statusBarVisible
        if lastStatusBarVisible && !newVisible {
            showHideIconHintIfNeeded()
        }
        lastStatusBarVisible = newVisible
        setStatusBarVisible(newVisible)
        updateMenuTitles()
    }

    private func updateMenuTitles() {
        updateStatisticsSummaryItems()

        viewTrendsMenuItem?.title = L10n.t(.menuViewTrends)
        settingsMenuItem?.title = L10n.t(.menuSettings)
        quitMenuItem?.title = L10n.t(.menuQuit)
    }

    private func updateStatisticsSummaryItems() {
        let stats = InputSourceStatistics.shared
        todaySummaryMenuItem?.title = L10n.format(.menuSummaryToday, stats.todaySwitches)
        weekSummaryMenuItem?.title = L10n.format(.menuSummaryWeek, stats.last7DaysTotal)
    }

    func menuWillOpen(_ menu: NSMenu) {
        updateStatisticsSummaryItems()
    }

    @objc private func showStatisticsPanel() {
        StatisticsWindowController.shared.show()
    }

    private func registerForSystemNotifications() {
        let center = NSWorkspace.shared.notificationCenter
        center.addObserver(self, selector: #selector(reconnectMonitors), name: NSWorkspace.didWakeNotification, object: nil)
        center.addObserver(self, selector: #selector(reconnectMonitors), name: NSWorkspace.screensDidWakeNotification, object: nil)
        center.addObserver(self, selector: #selector(reconnectMonitors), name: NSWorkspace.sessionDidBecomeActiveNotification, object: nil)
    }

    private func registerForAppWindowClose() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWindowWillClose),
            name: NSWindow.willCloseNotification,
            object: nil
        )
    }

    @objc private func appWindowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              Self.isManagedAppWindow(window) else {
            return
        }
        DispatchQueue.main.async {
            Self.restoreAccessoryPolicyIfNeeded()
        }
    }

    private static func isManagedAppWindow(_ window: NSWindow) -> Bool {
        let id = window.identifier?.rawValue
        return id == SettingsWindowController.windowIdentifier
            || id == StatisticsWindowController.windowIdentifier
    }

    private static func restoreAccessoryPolicyIfNeeded() {
        let hasVisibleWindow = NSApp.windows.contains { window in
            window.isVisible && isManagedAppWindow(window)
        }
        if !hasVisibleWindow {
            NSApp.setActivationPolicy(.accessory)
        }
    }

    @objc func openSettings() {
        SettingsWindowController.shared.show()
    }

    @objc private func reconnectMonitors() {
        installEventMonitors()
    }

    private func installEventMonitors() {
        removeEventMonitors()

        let handler: (NSEvent) -> Void = { [weak self] event in
            self?.handleGlobeKeyEvent(event)
        }

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: handler)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
            handler(event)
            return event
        }

        if globalMonitor == nil {
            promptForAccessibilityIfNeeded()
        }
        AccessibilityPermissionMonitor.shared.refresh()
    }

    private func removeEventMonitors() {
        if let globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
        if let localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
        globalMonitor = nil
        localMonitor = nil
    }

    private func handleGlobeKeyEvent(_ event: NSEvent) {
        guard event.keyCode == 63 else {
            return
        }

        let isPressed = event.modifierFlags
            .intersection(.deviceIndependentFlagsMask)
            .contains(.function)
        guard isPressed else {
            return
        }

        let hasOtherModifiers = !event.modifierFlags
            .intersection([.shift, .control, .option, .command])
            .isEmpty
        guard !hasOtherModifiers else {
            return
        }

        let now = Date()
        guard now.timeIntervalSince(lastSwitchTime) >= AppSettings.shared.switchDebounce else {
            return
        }
        lastSwitchTime = now
        switchKeyboardLanguage()
    }

    private func promptForAccessibilityIfNeeded() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    private func setStatusBarVisible(_ visible: Bool) {
        statusBarItem?.button?.isHidden = !visible
        statusBarItem?.isVisible = visible
        updateMenuTitles()
    }

    private func showHideIconHintIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: Self.hideIconHintShownKey) else {
            return
        }
        UserDefaults.standard.set(true, forKey: Self.hideIconHintShownKey)

        let alert = NSAlert()
        alert.messageText = L10n.t(.alertHideIconTitle)
        alert.informativeText = L10n.t(.alertHideIconMessage)
        alert.addButton(withTitle: L10n.t(.alertOK))
        alert.runModal()
    }

    @objc func exitAction() {
        NSApplication.shared.terminate(nil)
    }

    func switchKeyboardLanguage() {
        InputSourceHotkey.selectNextInputSource()
        InputSourceStatistics.shared.recordSwitchAfterGlobeKey()
    }
}

final class SettingsWindowController: NSObject, NSWindowDelegate {
    static let shared = SettingsWindowController()
    static let windowIdentifier = "LangSwitchSettingsWindow"
    static let settingsDidRefreshNotification = Notification.Name("SettingsDidRefresh")

    private var window: NSWindow?
    private var refreshTimer: Timer?

    private override init() {
        super.init()
    }

    func show() {
        if window == nil {
            window = makeWindow()
        }
        guard let window else {
            return
        }

        NSApp.setActivationPolicy(.regular)
        NSApp.unhide(nil)
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        AccessibilityPermissionMonitor.shared.refresh()
    }

    private func makeWindow() -> NSWindow {
        let hostingView = NSHostingView(
            rootView: ScrollView {
                SettingsView()
            }
        )

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 560, height: 640),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.identifier = NSUserInterfaceItemIdentifier(Self.windowIdentifier)
        window.title = L10n.t(.menuSettings).replacingOccurrences(of: "…", with: "")
        window.contentView = hostingView
        window.delegate = self
        window.center()
        window.setFrameAutosaveName(Self.windowIdentifier)
        window.isReleasedWhenClosed = false
        window.minSize = NSSize(width: 520, height: 520)
        return window
    }

    func windowDidBecomeKey(_ notification: Notification) {
        startAccessibilityRefreshTimer()
    }

    func windowDidResignKey(_ notification: Notification) {
        stopAccessibilityRefreshTimer()
    }

    private func startAccessibilityRefreshTimer() {
        stopAccessibilityRefreshTimer()
        AccessibilityPermissionMonitor.shared.refresh()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            AccessibilityPermissionMonitor.shared.refresh()
            NotificationCenter.default.post(
                name: SettingsWindowController.settingsDidRefreshNotification,
                object: nil
            )
        }
    }

    private func stopAccessibilityRefreshTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
