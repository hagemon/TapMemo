//
//  MemoWindowController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa

class MemoWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var pinButton: NSToolbarItem!
    var isMoved = false
    

    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowWillClose(_ notification: Notification) {
        MemoManager.shared.controllers.remove(
            at:MemoManager.shared.controllers.firstIndex(of: self)!
        )
    }
    
    @IBAction func pin(_ sender:Any) {
        guard let button = self.pinButton,
              let window = self.window
        else { return }
        if window.level == .statusBar {
            window.level = .normal
            button.image = NSImage(systemSymbolName: "pin.slash", accessibilityDescription: nil)
        } else {
            window.level = .statusBar
            button.image = NSImage(systemSymbolName: "pin", accessibilityDescription: nil)
        }
    }

}
