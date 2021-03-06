//
//  MemoTextView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa
import Carbon

class MemoTextView: NSTextView {
    
    var memo: CoreMemo?
    
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
        memo.update(content: self.string)
//        Storage.saveMemo(memo: memo)
        CoreUtil.save()
        memo.changed = false
//        MemoListManager.shared.setMemoStatus(memo: memo, status: false)
        NotificationCenter.default.post(name: .memoListShouldSync, object: nil, userInfo: ["memo":memo])
        NotificationCenter.default.post(name: .memoViewDidSave, object: nil, userInfo: ["memo":memo])
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
        if flags.contains(.command) && code == kVK_ANSI_W {
            guard let window = self.window else { return }
            window.close()
        }
        else if !self.hasMarkedText() && (code == kVK_Escape || (flags.contains(.command) && code == kVK_ANSI_S)) {
            self.deactivate()
        } else {
            guard self.isActive
            else { return }
            super.keyDown(with: event)
            guard let memo = self.memo else {return}
            memo.changed = true
//            MemoListManager.shared.setMemoStatus(memo: memo, status: true)
            NotificationCenter.default.post(name: .memoContentDidChange, object: nil, userInfo: ["memo":memo, "string":self.string])
        }
    }
    
    func refresh() {
        let selectedRange = self.selectedRange()
        for replaced in MDParser.autoOrder(content: self.string) {
            self.string.replaceSubrange(replaced.range, with: replaced.string)
        }
        guard let textStorage = self.textStorage
        else { return }
        textStorage.setAttributedString(MDParser.renderAll(content: textStorage.string))
        self.setSelectedRange(selectedRange)
    }
    
    override func didChangeText() {
        self.refresh()
    }
    
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
}
