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
            MemoListManager.shared.saveSelectedMemo()
            guard let memo = MemoListManager.shared.selectedMemo() else { return }
            NotificationCenter.default.post(name: .memoListShouldSync, object: nil, userInfo: ["memo":memo])
        }
        else {
            super.keyDown(with: event)
        }
    }
    
    override func didChangeText() {
        guard let storage = self.textStorage
        else { return }
        guard let range = Range(self.selectedRange(), in: self.string) else { return }
        let paraRange = storage.string.paragraphRange(for: range)
        let attr = MDParser.render(content: self.string, with: paraRange)
        storage.setAttributes(attr, range: NSRange(paraRange, in: self.string))
        MemoListManager.shared.updateSelectedMemo(content: self.string)
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
