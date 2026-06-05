//
//  InputSourceStatistics.swift
//  LangSwitch
//

import Carbon
import Combine
import Foundation

struct InputSourceUsage: Identifiable {
    let id: String
    let name: String
    let count: Int
    let share: Double
}

struct DailyTrendPoint: Identifiable {
    let id: String
    let label: String
    let count: Int
    let normalizedValue: Double
}

final class InputSourceStatistics: ObservableObject {
    static let shared = InputSourceStatistics()

    private enum Keys {
        static let storage = "inputSourceStatistics"
    }

    private struct DailyRecord: Codable {
        var switches: Int
        var bySource: [String: Int]
    }

    private struct Storage: Codable {
        var totalSwitches: Int = 0
        var currentDayKey: String = ""
        var todaySwitches: Int = 0
        var todayBySource: [String: Int] = [:]
        var sourceNames: [String: String] = [:]
        var dailyHistory: [String: DailyRecord] = [:]
    }

    @Published private(set) var todaySwitches: Int = 0
    @Published private(set) var totalSwitches: Int = 0
    @Published private(set) var monthSwitches: Int = 0
    @Published private(set) var monthTitle: String = ""
    @Published private(set) var todayBreakdown: [InputSourceUsage] = []
    @Published private(set) var last7DaysTotal: Int = 0
    @Published private(set) var last7DaysTrend: [DailyTrendPoint] = []
    @Published private(set) var monthTrend: [DailyTrendPoint] = []

    private var storage = Storage()
    private let calendar = Calendar.current

    private init() {
        load()
        migrateLegacyTodayIfNeeded()
        rollDayIfNeeded()
        publish()
    }

    func recordSwitchAfterGlobeKey() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.recordResolvedSource()
        }
    }

    func resetAll() {
        storage = Storage()
        storage.currentDayKey = Self.dayKey(for: Date(), calendar: calendar)
        save()
        publish()
    }

    private func recordResolvedSource() {
        guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else {
            return
        }
        let id = source.inputSourceID
        let name = source.localizedName
        guard !id.isEmpty else {
            return
        }

        rollDayIfNeeded()
        storage.totalSwitches += 1
        storage.todaySwitches += 1
        storage.todayBySource[id, default: 0] += 1
        storage.sourceNames[id] = name
        syncTodayToHistory()
        pruneHistory()
        save()
        publish()
    }

    private func rollDayIfNeeded() {
        let todayKey = Self.dayKey(for: Date(), calendar: calendar)
        guard storage.currentDayKey != todayKey else {
            return
        }

        if !storage.currentDayKey.isEmpty {
            archiveDay(key: storage.currentDayKey)
        }

        storage.currentDayKey = todayKey
        storage.todaySwitches = 0
        storage.todayBySource = [:]
    }

    private func archiveDay(key: String) {
        storage.dailyHistory[key] = DailyRecord(
            switches: storage.todaySwitches,
            bySource: storage.todayBySource
        )
    }

    private func syncTodayToHistory() {
        let todayKey = storage.currentDayKey.isEmpty
            ? Self.dayKey(for: Date(), calendar: calendar)
            : storage.currentDayKey
        storage.currentDayKey = todayKey
        storage.dailyHistory[todayKey] = DailyRecord(
            switches: storage.todaySwitches,
            bySource: storage.todayBySource
        )
    }

    private func migrateLegacyTodayIfNeeded() {
        guard storage.dailyHistory.isEmpty, storage.todaySwitches > 0 else {
            return
        }
        let todayKey = storage.currentDayKey.isEmpty
            ? Self.dayKey(for: Date(), calendar: calendar)
            : storage.currentDayKey
        storage.currentDayKey = todayKey
        storage.dailyHistory[todayKey] = DailyRecord(
            switches: storage.todaySwitches,
            bySource: storage.todayBySource
        )
        save()
    }

    private func pruneHistory() {
        let cutoff = calendar.date(byAdding: .day, value: -120, to: Date()) ?? Date()
        let cutoffKey = Self.dayKey(for: cutoff, calendar: calendar)
        storage.dailyHistory = storage.dailyHistory.filter { $0.key >= cutoffKey }
    }

    private func publish() {
        todaySwitches = storage.todaySwitches
        totalSwitches = storage.totalSwitches
        todayBreakdown = buildBreakdown(counts: storage.todayBySource, total: storage.todaySwitches)

        let now = Date()
        monthTitle = Self.monthTitle(for: now, calendar: calendar)
        monthSwitches = switchesInCurrentMonth(referenceDate: now)
        last7DaysTrend = buildTrend(days: last7DayDates(referenceDate: now), compactLabels: true)
        last7DaysTotal = last7DaysTrend.reduce(0) { $0 + $1.count }
        monthTrend = buildTrend(days: currentMonthDayDates(referenceDate: now), compactLabels: false)
    }

    private func buildBreakdown(counts: [String: Int], total: Int) -> [InputSourceUsage] {
        let denominator = max(total, 1)
        return counts
            .map { id, count in
                InputSourceUsage(
                    id: id,
                    name: storage.sourceNames[id] ?? id,
                    count: count,
                    share: Double(count) / Double(denominator)
                )
            }
            .sorted { lhs, rhs in
                if lhs.count == rhs.count {
                    return lhs.name < rhs.name
                }
                return lhs.count > rhs.count
            }
    }

    private func switchesInCurrentMonth(referenceDate: Date) -> Int {
        currentMonthDayDates(referenceDate: referenceDate)
            .reduce(0) { partial, date in
                let key = Self.dayKey(for: date, calendar: calendar)
                return partial + (storage.dailyHistory[key]?.switches ?? 0)
            }
    }

    private func last7DayDates(referenceDate: Date) -> [Date] {
        (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: -(6 - offset), to: startOfDay(referenceDate))
        }
    }

    private func currentMonthDayDates(referenceDate: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .month, for: referenceDate) else {
            return []
        }

        var dates: [Date] = []
        var cursor = interval.start
        while cursor < interval.end {
            dates.append(cursor)
            guard let next = calendar.date(byAdding: .day, value: 1, to: cursor) else {
                break
            }
            cursor = next
        }
        return dates
    }

    private func buildTrend(days: [Date], compactLabels: Bool) -> [DailyTrendPoint] {
        let counts = days.map { date in
            let key = Self.dayKey(for: date, calendar: calendar)
            return storage.dailyHistory[key]?.switches ?? 0
        }
        let maxCount = max(counts.max() ?? 0, 1)

        return zip(days, counts).map { date, count in
            let key = Self.dayKey(for: date, calendar: calendar)
            return DailyTrendPoint(
                id: key,
                label: Self.dayLabel(for: date, compact: compactLabels, calendar: calendar),
                count: count,
                normalizedValue: Double(count) / Double(maxCount)
            )
        }
    }

    private func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Keys.storage),
              let decoded = try? JSONDecoder().decode(Storage.self, from: data) else {
            storage.currentDayKey = Self.dayKey(for: Date(), calendar: calendar)
            return
        }
        storage = decoded
        if storage.currentDayKey.isEmpty {
            storage.currentDayKey = Self.dayKey(for: Date(), calendar: calendar)
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(storage) else {
            return
        }
        UserDefaults.standard.set(data, forKey: Keys.storage)
    }

    private static func dayKey(for date: Date, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func dayLabel(for date: Date, compact: Bool, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale.current
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = compact ? "EEE" : "d"
        return formatter.string(from: date)
    }

    private static func monthTitle(for date: Date, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale.current
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = "yyyy MMM"
        return formatter.string(from: date)
    }
}

private extension TISInputSource {
    var inputSourceID: String {
        guard let value = TISGetInputSourceProperty(self, kTISPropertyInputSourceID) else {
            return ""
        }
        return Unmanaged<CFString>.fromOpaque(value).takeUnretainedValue() as String
    }

    var localizedName: String {
        guard let value = TISGetInputSourceProperty(self, kTISPropertyLocalizedName) else {
            return inputSourceID
        }
        return Unmanaged<CFString>.fromOpaque(value).takeUnretainedValue() as String
    }
}
