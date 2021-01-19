//
//  MemoTextView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa
import Carbon

class MemoTextView: NSTextView {
    
    var memo: Memo? {
        didSet {
            self.refresh()
        }
    }
    
    var isActive = true {
        didSet {
            self.isEditable = self.isActive
            self.isSelectable = self.isActive
        }
    }
            
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func refresh() {
        guard let storage = self.textStorage,
              let memo = self.memo
        else {return}
        self.string = memo.content
        storage.setAttributedString(MDParser.renderAll(storage: storage))
    }
        
    func activate() {
        self.isActive = true
    }
    
    func deactivate() {
        self.isActive = false
        self.save()
        self.setSelectedRange(NSRange(location: self.string.count, length: 0))
    }
    
    func save() {
        guard let memo = self.memo,
              self.string.count > 0
        else { return }
        if memo.changed {
            memo.update(content: self.string)
            Storage.saveMemo(memo: memo)
            memo.changed = false
            // tell memo list memo saved
            NotificationCenter.default.post(name: .memoListShouldSync, object: nil, userInfo: ["memo":memo])
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if event.clickCount == 2 {
            self.activate()
        }
        guard !self.isActive,
              let window = self.window
        else { return }
        window.performDrag(with: event)
    }
    
    override func keyDown(with event: NSEvent) {
        let code = event.keyCode
        let flags = event.modifierFlags
        if !self.hasMarkedText() && (code == kVK_Escape || (flags.contains(.command) && code == kVK_ANSI_S)) {
            self.deactivate()
        } else {
            guard let memo = self.memo else { return }
            memo.changed = true
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
    }
    
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
}
