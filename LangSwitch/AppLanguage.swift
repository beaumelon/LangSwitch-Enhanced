//
//  AppLanguage.swift
//  LangSwitch
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case en
    case zhHans = "zh-Hans"
    case fr
    case ja
    case ko
    case de
    case es

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: return "English"
        case .zhHans: return "简体中文"
        case .fr: return "Français"
        case .ja: return "日本語"
        case .ko: return "한국어"
        case .de: return "Deutsch"
        case .es: return "Español"
        }
    }

    static var `default`: AppLanguage { .en }

    static func from(stored value: String?) -> AppLanguage {
        guard let value, let language = AppLanguage(rawValue: value) else {
            return .default
        }
        return language
    }
}
