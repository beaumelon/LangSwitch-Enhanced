//
//  StatisticsQuickPanel.swift
//  LangSwitch
//

import AppKit
import SwiftUI

struct StatisticsQuickView: View {
    @ObservedObject private var statistics = InputSourceStatistics.shared
    @State private var showResetConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                summaryCard(title: L10n.t(.todaySwitches), value: statistics.todaySwitches)
                summaryCard(title: L10n.t(.last7DaysTrend), value: statistics.last7DaysTotal)
                summaryCard(title: L10n.t(.monthTrend), value: statistics.monthSwitches)
            }

            SettingsLabeledRow(
                title: L10n.t(.totalSwitches),
                value: "\(statistics.totalSwitches)"
            )

            TrendSectionView(
                title: L10n.t(.last7DaysTrend),
                points: statistics.last7DaysTrend,
                scrollable: false,
                barWidth: 32,
                chartHeight: 80
            )

            TrendSectionView(
                title: L10n.t(.monthTrend),
                subtitle: statistics.monthTitle,
                points: statistics.monthTrend,
                scrollable: true,
                barWidth: 14,
                chartHeight: 64
            )

            if statistics.todayBreakdown.isEmpty {
                Text(L10n.t(.noStatisticsYet))
                    .font(.caption)
                    .secondaryForeground()
            } else {
                Text(L10n.t(.todayBreakdown))
                    .font(.caption)
                    .secondaryForeground()

                ForEach(statistics.todayBreakdown) { item in
                    usageRow(item)
                }
            }

            Button(L10n.t(.resetStatistics)) {
                showResetConfirmation = true
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(20)
        .frame(minWidth: 500)
        .alert(isPresented: $showResetConfirmation) {
            Alert(
                title: Text(L10n.t(.resetStatisticsTitle)),
                message: Text(L10n.t(.resetStatisticsMessage)),
                primaryButton: .destructive(Text(L10n.t(.resetStatistics))) {
                    statistics.resetAll()
                },
                secondaryButton: .cancel(Text(L10n.t(.alertOK)))
            )
        }
    }

    private func summaryCard(title: String, value: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .secondaryForeground()
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text("\(value)")
                .font(.title2.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func usageRow(_ item: InputSourceUsage) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(item.name)
                    .lineLimit(1)
                Spacer()
                Text("\(item.count) · \(Int(item.share * 100))%")
                    .secondaryForeground()
            }
            ProgressView(value: item.share)
                .progressViewStyle(.linear)
        }
    }
}

struct TrendSectionView: View {
    let title: String
    var subtitle: String? = nil
    let points: [DailyTrendPoint]
    let scrollable: Bool
    var barWidth: CGFloat = 24
    var chartHeight: CGFloat = 56

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.caption)
                    .secondaryForeground()
                Spacer()
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .secondaryForeground()
                }
            }

            if points.allSatisfy({ $0.count == 0 }) {
                Text(L10n.t(.trendNoData))
                    .font(.caption)
                    .tertiaryForeground()
            } else if scrollable {
                ScrollView(.horizontal, showsIndicators: true) {
                    TrendBarChart(points: points, barWidth: barWidth, chartHeight: chartHeight)
                        .padding(.vertical, 2)
                }
            } else {
                TrendBarChart(points: points, barWidth: barWidth, chartHeight: chartHeight)
            }
        }
    }
}

struct TrendBarChart: View {
    let points: [DailyTrendPoint]
    let barWidth: CGFloat
    var chartHeight: CGFloat = 56

    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(points) { point in
                VStack(spacing: 4) {
                    Text("\(point.count)")
                        .font(.caption2)
                        .secondaryForeground()
                        .frame(minHeight: 12)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.accentColor.opacity(point.count == 0 ? 0.25 : 1))
                        .frame(
                            width: barWidth,
                            height: max(4, CGFloat(point.normalizedValue) * chartHeight)
                        )

                    Text(point.label)
                        .font(.caption2)
                        .secondaryForeground()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(width: barWidth + 8)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

final class StatisticsWindowController: NSObject, NSWindowDelegate {
    static let shared = StatisticsWindowController()
    static let windowIdentifier = "LangSwitchStatisticsWindow"

    private var window: NSWindow?

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
    }

    private func makeWindow() -> NSWindow {
        let hostingView = NSHostingView(
            rootView: ScrollView {
                StatisticsQuickView()
            }
        )

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 540, height: 620),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.identifier = NSUserInterfaceItemIdentifier(Self.windowIdentifier)
        window.title = L10n.t(.quickTrendsTitle)
        window.contentView = hostingView
        window.delegate = self
        window.center()
        window.setFrameAutosaveName(Self.windowIdentifier)
        window.isReleasedWhenClosed = false
        window.minSize = NSSize(width: 500, height: 480)
        return window
    }
}
