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
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Memo")
        
        // get the store description
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Could not retrieve a persistent store description.")
        }

        // initialize the CloudKit schema
        let id = "iCloud.hagemon.TapMemo-for-iOS"
        let options = NSPersistentCloudKitContainerOptions(containerIdentifier: id)
        description.cloudKitContainerOptions = options
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

