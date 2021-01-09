//
//  AppDelegate.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa
import HotKey

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let hotKey = HotKey(key: .d, modifiers: [.command, .shift])

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        self.hotKey.keyDownHandler = {
            MemoManager.shared.createMemo()
        }
        
        guard let button = self.statusItem.button else { return }
        button.image = NSImage(named: NSImage.Name("StatusBarItem"))
        
        self.statusItem.menu = NSMenu(title: "Touch Memo")
        guard let menu = self.statusItem.menu else { return }
        menu.addItem(NSMenuItem(title: "Memos", action: nil, keyEquivalent: "m"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(exit), keyEquivalent: "q"))
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func exit() {
        NSApp.terminate(nil)
    }


}

