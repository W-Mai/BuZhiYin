//
//  ZhiYinApp.swift
//  BuZhiYin
//
//  Created by 王小劣 on 2023/1/9.
//  Collaborator: W-Mai

import SwiftUI
import LaunchAtLogin

@main
struct 🐔App: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
#if DEBUG
    let persistenceController = PersistenceController.preview
#else
    let persistenceController = PersistenceController.shared
#endif
    
    var body: some Scene {
        Settings {
            SettingsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

let iconMinWidth = CGFloat(22);

import AppKit
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    
#if DEBUG
    let persistenceController = PersistenceController.preview
#else
    let persistenceController = PersistenceController.shared
#endif
    
    @objc func exitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc func openSettings() {
        if #available(macOS 13, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menuItem = NSMenuItem()
        menuItem.title = "退出"
        menuItem.target = self
        menuItem.action = #selector(exitApp)
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "设置", action: #selector(openSettings), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "退出", action: #selector(exitApp), keyEquivalent: ""))
        
        let contentView = 🐔ViewAuto(width: iconMinWidth, height: iconMinWidth).environment(\.managedObjectContext, persistenceController.container.viewContext)
        let mainView = NSHostingView(rootView: contentView)
        mainView.frame = NSRect(x: 0, y: 0, width: iconMinWidth, height: iconMinWidth)
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength < iconMinWidth ? iconMinWidth : NSStatusItem.variableLength)
        statusBarItem?.menu = menu
        statusBarItem?.button?.title = " "
        statusBarItem?.button?.addSubview(mainView)
        statusBarItem?.button?.action = #selector(exitApp)
        
        if !LaunchAtLogin.isEnabled {
            openSettings()
        }
    }
}
