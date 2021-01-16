//
//  MemoDetailTextView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/15.
//

import Cocoa
import Carbon

class MemoDetailTextView: NSTextView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func keyDown(with event: NSEvent) {
        let code = event.keyCode
        let flags = event.modifierFlags
        if (code == kVK_Escape) || (flags.contains(.command) && code == kVK_ANSI_S) {
            guard !self.hasMarkedText() && self.string.count > 0 else {
                super.keyDown(with: event)
                return
            }
            MemoListManager.shared.saveSelectedMemo()
        }
        super.keyDown(with: event)
    }
    
    override var isEditable: Bool {
        get {
            return !MemoListManager.shared.isEmpty
        }
        set {
            super.isEditable = !MemoListManager.shared.isEmpty
        }
    }
    
    override var isSelectable: Bool {
        get {
            return !MemoListManager.shared.isEmpty
        }
        set {
            super.isEditable = !MemoListManager.shared.isEmpty
        }
    }
    
}
