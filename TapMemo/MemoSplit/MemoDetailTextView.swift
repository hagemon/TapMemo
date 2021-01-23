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
            guard !self.hasMarkedText() else {
                super.keyDown(with: event)
                return
            }
            MemoListManager.shared.updateSelectedMemo(content: self.string)
            MemoListManager.shared.saveSelectedMemo()
            guard let memo = MemoListManager.shared.selectedMemo() else { return }
            NotificationCenter.default.post(name: .memoListShouldSync, object: nil, userInfo: ["memo":memo])
            if memo.changed {
                memo.changed = false
                NotificationCenter.default.post(name: .memoListStatusDidChange, object: nil, userInfo: ["memo": memo])
            }
            
        }
        else {
            super.keyDown(with: event)
        }
    }
    
    override func didChangeText() {
        let selectedRange = self.selectedRange()
        for replaced in MDParser.autoOrder(content: self.string) {
            self.string.replaceSubrange(replaced.range, with: replaced.string)
        }
        guard let textStorage = self.textStorage
        else { return }
        textStorage.setAttributedString(MDParser.renderAll(storage: textStorage))
        self.setSelectedRange(selectedRange)
        // MemoListManager.shared.updateSelectedMemo(content: self.string)
        guard let memo = MemoListManager.shared.selectedMemo() else { return }
        if !memo.changed {
            memo.changed = true
            NotificationCenter.default.post(name: .memoListStatusDidChange, object: nil, userInfo: ["memo":memo])
        }
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
