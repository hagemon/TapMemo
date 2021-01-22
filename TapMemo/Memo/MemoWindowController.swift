//
//  MemoWindowController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa

class MemoWindowController: NSWindowController, NSWindowDelegate {
    
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
        guard let button = sender as? NSToolbarItem,
              let window = self.window
        else { return }
        let config = NSImage.SymbolConfiguration(scale: .small)
        if window.level == .statusBar {
            window.level = .normal
            let image = NSImage(systemSymbolName: "pin.slash", accessibilityDescription: nil)
            button.image = image?.withSymbolConfiguration(config)
                        
        } else {
            window.level = .statusBar
            let image = NSImage(systemSymbolName: "pin", accessibilityDescription: nil)
            button.image = image?.withSymbolConfiguration(config)
        }
    }

}
