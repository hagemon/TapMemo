//
//  MemoTextView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa
import Carbon

class MemoTextView: NSTextView, NSTextViewDelegate {
    
//    weak var memoDelegate: MemoDelegate?
    weak var superScrollView: MemoScrollView?
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
        
    func active() {
        self.isActive = true
    }
    
    func deactive() {
        self.isActive = false
    }
    
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.lastPoint = event.locationInWindow
        if event.clickCount == 2 {
            self.active()
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if !self.hasMarkedText() && event.keyCode == kVK_Escape {
            self.deactive()
        }else{
            super.keyDown(with: event)
        }
    }
}
