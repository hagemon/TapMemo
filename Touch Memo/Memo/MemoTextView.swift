//
//  MemoTextView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa
import Carbon

class MemoTextView: NSTextView, NSTextViewDelegate {
    
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
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.font = .systemFont(ofSize: 15)
        self.delegate = self
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
        if !self.hasMarkedText() && event.keyCode == kVK_Escape {
            self.deactivate()
        }else{
            super.keyDown(with: event)
        }
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
}
