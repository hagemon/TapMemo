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
    
    var lastPoint: NSPoint?
        
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    init(frame frameRect:NSRect, memo:Memo) {
        super.init(frame: frameRect)
        self.font = .systemFont(ofSize: 15)
        self.memo = memo
        self.string = memo.content
    }
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        self.font = .systemFont(ofSize: 15)
//
//    }
    
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
        guard let memo = self.memo,
              self.string.count > 0
        else { return }
        memo.update(content: self.string)
        Storage.saveMemo(memo: memo)
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
        }else{
            super.keyDown(with: event)
        }
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
}
