//
//  LangSwitchApp.swift
//  LangSwitch
//

import SwiftUI

@main
struct LangSwitchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
