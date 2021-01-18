//
//  MemoDetailTextView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/15.
//

import Cocoa
import Carbon

class MemoDetailTextView: NSTextView {

    var lineCount: Int?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func keyDown(with event: NSEvent) {
        if self.lineCount == nil {
            self.lineCount = RE.regularExpression(validateString: self.string, inRegex: "\n").count
        }
        let code = event.keyCode
        let flags = event.modifierFlags
        if (code == kVK_Escape) || (flags.contains(.command) && code == kVK_ANSI_S) {
            guard !self.hasMarkedText() else {
                super.keyDown(with: event)
                return
            }
            MemoListManager.shared.saveSelectedMemo()
        }
        else {
            super.keyDown(with: event)
        }
        let lineCount = RE.regularExpression(validateString: self.string, inRegex: "\n").count
        if lineCount != self.lineCount {
            self.lineCount = lineCount
            MemoListManager.shared.saveSelectedMemo() // This will render, which is bad
        }
    }
    
    override func shouldChangeText(in affectedCharRange: NSRange, replacementString: String?) -> Bool {
        guard let rep = replacementString,
              let storage = self.textStorage
        else {return false}
        storage.replaceCharacters(in: affectedCharRange, with: rep)
        guard let range = Range(self.selectedRange(), in: self.string) else {return false}
        let paraRange = storage.string.paragraphRange(for: range)
        let attr = MDParser.render(content: self.string, with: paraRange)
        storage.setAttributes(attr, range: NSRange(paraRange, in: self.string))
        MemoListManager.shared.updateSelectedMemo(content: self.string)
        return false
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
