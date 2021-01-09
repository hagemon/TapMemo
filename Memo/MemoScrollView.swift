//
//  MemoScrollView.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa

class MemoScrollView: NSScrollView, NSTextViewDelegate {
    
    var memoTextView: MemoTextView?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    init(frame frameRect: NSRect, textView: MemoTextView) {
        super.init(frame: frameRect)
        self.documentView = textView
        textView.superScrollView = self
        self.memoTextView = textView
        self.hasVerticalScroller = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
