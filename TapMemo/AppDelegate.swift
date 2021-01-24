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
    var memoSplitWindowController: MemoSplitWindowController?
    var preferenceWindowController: NSWindowController?
    var helpWindowController: NSWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        KeyManager.shared.register(key: Storage.getKey(), modifiers: Storage.getModifierFlags())
        
        guard let button = self.statusItem.button else { return }
        button.image = NSImage(named: NSImage.Name("StatusBarItem"))
        
        self.statusItem.menu = NSMenu(title: "Touch Memo")
        guard let menu = self.statusItem.menu else { return }
        menu.addItem(withTitle: "Memos", action: #selector(self.openMemos), keyEquivalent: "m")
        menu.addItem(withTitle: "Preferences", action: #selector(self.openPreferences), keyEquivalent: "p")
        menu.addItem(withTitle: "Help", action: #selector(self.openHelp), keyEquivalent: "h")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(self.exit), keyEquivalent: "q")
        // Storage.removeAllMemos()
//        self.openMemos()
        
        if Storage.loadFirstFlag() {
            Storage.saveFirstFlag()
            let alert = NSAlert()
            alert.messageText = "Show usage of our help? Press YES to open the support page: https://hagemon.github.io/TapMemo"
            alert.addButton(withTitle: "YES")
            alert.addButton(withTitle: "NO")
            if alert.runModal() == .alertFirstButtonReturn {
                self.openHelp()
            }
        }        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func exit() {
        NSApp.terminate(nil)
    }
    
    @objc func openPreferences() {
        if self.preferenceWindowController == nil {
            let controller = NSWindowController(windowNibName: "Preferences")
            self.preferenceWindowController = controller
            controller.showWindow(nil)
        }
        NSApplication.shared.activate(ignoringOtherApps: true)

    }
    
    @objc func openMemos() {
        if self.memoSplitWindowController == nil {
            guard let storyboard = NSStoryboard.main else {return}
            let windowController = storyboard.instantiateController(withIdentifier: "Memos") as! MemoSplitWindowController
            self.memoSplitWindowController = windowController
            windowController.showWindow(nil)
        }
        NSApplication.shared.activate(ignoringOtherApps: true)

    }
    
    @objc func openHelp() {
        if self.helpWindowController == nil {
            guard let storyboard = NSStoryboard.main else { return }
            let helpWindowController = storyboard.instantiateController(withIdentifier: "Help") as! NSWindowController
            self.helpWindowController = helpWindowController
            helpWindowController.showWindow(nil)
        }
        NSApplication.shared.activate(ignoringOtherApps: true)

    }
}

