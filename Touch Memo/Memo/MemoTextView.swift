//
//  MemoTextView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa
import Carbon

class MemoTextView: NSTextView {
    
    var memo: Memo?
    
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
    
    init(frame frameRect:NSRect, memo:Memo) {
        super.init(frame: frameRect)
        self.font = .systemFont(ofSize: FONT_LEVELS[0])
        self.memo = memo
        self.string = memo.content
        guard let storage = self.textStorage else { return }
        storage.setAttributedString(MDParser.renderAll(storage: storage))
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func shouldChangeText(in affectedCharRange: NSRange, replacementString: String?) -> Bool {
        guard let rep = replacementString,
              let storage = self.textStorage
        else {return false}
        storage.replaceCharacters(in: affectedCharRange, with: rep)
        guard let range = Range(self.selectedRange(), in: self.string) else {return false}
        let paraRange = storage.string.paragraphRange(for: range)
        let attr = MDParser.render(content: self.string, with: paraRange)
        storage.setAttributes(attr, range: NSRange(paraRange, in: self.string))
        return false
    }
    
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
}
