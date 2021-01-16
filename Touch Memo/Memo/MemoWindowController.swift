//
//  MemoWindowController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa

class MemoWindowController: NSWindowController, NSWindowDelegate {
    
    var memoWindow: MemoWindow?
    var memoScrollView: MemoScrollView?
    var memoTextView: MemoTextView?
    var isMoved = false
    
    init(window: MemoWindow) {
        super.init(window: window)
        self.memoWindow = window
        window.delegate = self
        self.memoScrollView = window.memoScrollView
        self.memoTextView = window.memoTextView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowDidResize(_ notification: Notification) {
        guard let textView = self.memoTextView,
              let scrollView = self.memoScrollView,
              let window = self.memoWindow
        else {
            print("Could not get views when window resize")
            return
        }
        textView.setFrameSize(scrollView.contentSize)
        window.resetToolRect()
    }
    
    func windowWillClose(_ notification: Notification) {
        MemoManager.shared.controllers.remove(
            at:MemoManager.shared.controllers.firstIndex(of: self)!
        )
    }
    
    func textDidChange(_ notification: Notification) {
        
    }

}
