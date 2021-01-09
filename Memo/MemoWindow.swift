//
//  MemoWindow.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa


class MemoWindow: NSWindow {
    
    var memoScrollView:MemoScrollView?
    var memoTextView:MemoTextView?
    
    init(contentRect: NSRect, contentView: MemoScrollView) {
        super.init(contentRect: contentRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        self.level = .statusBar
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.contentView = contentView
        self.memoScrollView = contentView
        guard let textView = contentView.memoTextView else { return }
        self.memoTextView = textView
        
    }

    override func resignKey() {
        super.resignKey()
        guard let textView = self.memoTextView else { return }
        textView.deactive()
    }
}
