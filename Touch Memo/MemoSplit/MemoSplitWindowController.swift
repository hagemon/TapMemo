//
//  MemoSplitWindowController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/15.
//

import Cocoa

class MemoSplitWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var addButton: NSToolbarItem!
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowWillClose(_ notification: Notification) {
        MemoListManager.shared.clearMemos()
    }
    
    override func windowWillLoad() {
        MemoListManager.shared.loadMemos()
        super.windowWillLoad()
    }
    
}
