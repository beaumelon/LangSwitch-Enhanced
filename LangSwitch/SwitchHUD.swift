//
//  SwitchHUD.swift
//  LangSwitch
//

import AppKit

enum SwitchHUD {
    private static var panel: NSPanel?
    private static var textLabel: NSTextField?
    private static var hideWorkItem: DispatchWorkItem?
    private static var displayGeneration: UInt = 0

    private enum Metrics {
        static let fontSize: CGFloat = 12
        static let horizontalPadding: CGFloat = 10
        static let verticalPadding: CGFloat = 5
        static let cornerRadius: CGFloat = 8
        static let cursorOffset: CGFloat = 28
        static let displayDuration: TimeInterval = 0.75
    }

    static func show(text: String) {
        guard AppSettings.shared.showSwitchHUD, !text.isEmpty else {
            return
        }

        DispatchQueue.main.async {
            displayGeneration &+= 1
            let generation = displayGeneration

            hideWorkItem?.cancel()
            hideWorkItem = nil

            let panel = panel ?? makePanel()
            Self.panel = panel

            guard let label = textLabel, let container = panel.contentView else {
                return
            }

            label.stringValue = text
            container.layoutSubtreeIfNeeded()
            panel.setContentSize(container.fittingSize)
            position(panel)

            panel.orderFrontRegardless()
            panel.alphaValue = 1

            let work = DispatchWorkItem {
                guard generation == displayGeneration else {
                    return
                }
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.2
                    context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                    guard generation == displayGeneration else {
                        return
                    }
                    panel.animator().alphaValue = 0
                }, completionHandler: {
                    guard generation == displayGeneration else {
                        return
                    }
                    panel.orderOut(nil)
                })
            }
            hideWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + Metrics.displayDuration, execute: work)
        }
    }

    private static func makePanel() -> NSPanel {
        let label = NSTextField(labelWithString: "")
        label.font = .systemFont(ofSize: Metrics.fontSize, weight: .regular)
        label.textColor = .labelColor
        label.alignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.maximumNumberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        textLabel = label

        let effectView = NSVisualEffectView()
        effectView.material = .hudWindow
        effectView.state = .active
        effectView.blendingMode = .behindWindow
        effectView.wantsLayer = true
        effectView.layer?.cornerRadius = Metrics.cornerRadius
        effectView.layer?.cornerCurve = .continuous
        effectView.layer?.borderWidth = 0.5
        effectView.layer?.borderColor = NSColor.separatorColor.withAlphaComponent(0.35).cgColor
        effectView.translatesAutoresizingMaskIntoConstraints = false

        effectView.addSubview(label)

        let container = NSView(frame: NSRect(x: 0, y: 0, width: 100, height: 26))
        container.addSubview(effectView)

        NSLayoutConstraint.activate([
            effectView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            effectView.topAnchor.constraint(equalTo: container.topAnchor),
            effectView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            label.leadingAnchor.constraint(equalTo: effectView.leadingAnchor, constant: Metrics.horizontalPadding),
            label.trailingAnchor.constraint(equalTo: effectView.trailingAnchor, constant: -Metrics.horizontalPadding),
            label.topAnchor.constraint(equalTo: effectView.topAnchor, constant: Metrics.verticalPadding),
            label.bottomAnchor.constraint(equalTo: effectView.bottomAnchor, constant: -Metrics.verticalPadding),
        ])

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 26),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.contentView = container
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        return panel
    }

    private static func position(_ panel: NSPanel) {
        let mouse = NSEvent.mouseLocation
        let size = panel.frame.size
        let x = mouse.x - size.width / 2
        let y = mouse.y + Metrics.cursorOffset
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
