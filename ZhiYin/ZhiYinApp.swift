//
//  ZhiYinApp.swift
//  ZhiYin
//
//  Created by 王小劣 on 2023/1/9.
//  Collaborator: W-Mai

import SwiftUI

// TODO: 动态加载
var imageSet = [
    ImageSetInfo(id: 0, dark: .yes, name: "zhiyin",num: 17, desp: "只因铁山靠⛰️"),
    ImageSetInfo(id: 1, dark: .yes, name: "zhiyinbas", num: 17, desp: "只因篮球🏀"),
    ImageSetInfo(id: 2, light: .yes, name: "cat_", num: 20, desp: "猫砸键盘🐱"),
    ImageSetInfo(id: 3, name: "pink_cat", num: 14, desp: "猫砸🐱"),
    ImageSetInfo(id: 4, name: "ship", num: 18, desp: "跳跃的🐑"),
    ImageSetInfo(id: 5, name: "big_mouse_frog", num: 22, desp: "大嘴🐸"),
    ImageSetInfo(id: 6, name: "kakashi", num: 20, desp: "卡卡西"),
    ImageSetInfo(id: 7, name: "karby", num: 8, desp: "星之卡比"),
    ImageSetInfo(id: 8, name: "rabit_run", num: 17, desp: "奔跑的🐰"),
    ImageSetInfo(id: 9, name: "xiaolan_turn", num: 23, desp: "小蓝转圈圈"),
]

@main
struct ZhiYinApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

import AppKit
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    
    @objc func exitApp() {
        NSApplication.shared.terminate(nil)
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
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
        
        let contentView = ZYView(width: 22, height: 22)
        let mainView = NSHostingView(rootView: contentView)
        mainView.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.menu = menu
        statusBarItem?.button?.title = " "
        statusBarItem?.button?.addSubview(mainView)
        statusBarItem?.button?.action = #selector(exitApp)
    }
}
