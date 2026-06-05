//
//  AccessibilityPermissionMonitor.swift
//  LangSwitch
//

import AppKit
import ApplicationServices
import Combine

enum EventMonitorStatus {
    private static weak var appDelegate: AppDelegate?

    static func register(_ delegate: AppDelegate) {
        appDelegate = delegate
    }

    static var isGlobalMonitorActive: Bool {
        appDelegate?.hasGlobalMonitor ?? false
    }
}

final class AccessibilityPermissionMonitor: ObservableObject {
    static let shared = AccessibilityPermissionMonitor()

    private static let accessibilityAPIName = "com.apple.accessibility.api" as CFString
    private static let accessibilityAPINotification = CFNotificationName(accessibilityAPIName)

    @Published private(set) var isGranted = AccessibilityPermissionMonitor.evaluate()

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: NSApplication.didBecomeActiveNotification,
            object: nil
        )

        let center = CFNotificationCenterGetDistributedCenter()
        CFNotificationCenterAddObserver(
            center,
            Unmanaged.passUnretained(self).toOpaque(),
            { _, observer, _, _, _ in
                guard let observer else {
                    return
                }
                let monitor = Unmanaged<AccessibilityPermissionMonitor>
                    .fromOpaque(observer)
                    .takeUnretainedValue()
                DispatchQueue.main.async {
                    monitor.refresh()
                }
            },
            Self.accessibilityAPIName,
            nil,
            .deliverImmediately
        )
    }

    deinit {
        let center = CFNotificationCenterGetDistributedCenter()
        CFNotificationCenterRemoveObserver(
            center,
            Unmanaged.passUnretained(self).toOpaque(),
            Self.accessibilityAPINotification,
            nil
        )
    }

    @objc func refresh() {
        isGranted = Self.evaluate()
    }

    func refreshAfterOpeningSystemSettings() {
        refresh()
        for delay in [0.5, 1.0, 2.0, 3.0] {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.refresh()
            }
        }
    }

    private static func evaluate() -> Bool {
        AXIsProcessTrusted() && EventMonitorStatus.isGlobalMonitorActive
    }
}
