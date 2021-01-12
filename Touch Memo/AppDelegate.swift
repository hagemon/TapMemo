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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        KeyManager.shared.register(key: Storage.getKey(), modifiers: Storage.getModifierFlags())
        
        guard let button = self.statusItem.button else { return }
        button.image = NSImage(named: NSImage.Name("StatusBarItem"))
        
        self.statusItem.menu = NSMenu(title: "Touch Memo")
        guard let menu = self.statusItem.menu else { return }
        menu.addItem(withTitle: "Memos", action: nil, keyEquivalent: "m")
        menu.addItem(withTitle: "Preferences", action: #selector(openPreferences), keyEquivalent: "p")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(exit), keyEquivalent: "q")
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func exit() {
        NSApp.terminate(nil)
    }
    
    @objc func openPreferences() {
        let controller = NSWindowController(windowNibName: "Preferences")
        NSApplication.shared.activate(ignoringOtherApps: true)
        controller.showWindow(nil)
    }


}

