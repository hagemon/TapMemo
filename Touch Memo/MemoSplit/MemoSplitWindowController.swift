//
//  MemoSplitWindowController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/15.
//

import Cocoa

class MemoSplitWindowController: NSWindowController {

    @IBOutlet weak var addButton: NSToolbarItem!
    override func windowDidLoad() {
        super.windowDidLoad()
        MemoListManager.shared.loadMemos()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
}
