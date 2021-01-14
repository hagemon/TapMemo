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
    var pinButton: NSButton?
    
    init(contentRect: NSRect, contentView: MemoScrollView) {
        super.init(contentRect: contentRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        self.level = .statusBar
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.contentView = contentView
        self.memoScrollView = contentView
        guard let textView = contentView.memoTextView else { return }
        self.memoTextView = textView
        self.addTools()
    }

    override func resignKey() {
        super.resignKey()
        guard let textView = self.memoTextView else { return }
        textView.deactivate()
    }
    
    func addTools() {
        guard let image = NSImage(systemSymbolName: "pin", accessibilityDescription: nil) else {
            print("Could not get pin tool image")
            return
        }
        self.pinButton = NSButton(image: image, target: self, action: #selector(self.pin))
        guard let button = self.pinButton,
              let titleView = self.standardWindowButton(.closeButton)?.superview
        else {
            print("Could not get button view")
            return
        }
        button.isBordered = false
        self.resetToolRect()
        titleView.addSubview(button)
    }
    
    @objc func pin() {
        guard let button = self.pinButton else { return }
        if self.level == .statusBar {
            self.level = .normal
            button.image = NSImage(systemSymbolName: "pin.slash", accessibilityDescription: nil)
        } else {
            self.level = .statusBar
            button.image = NSImage(systemSymbolName: "pin", accessibilityDescription: nil)
        }
    }
    
    func resetToolRect() {
        guard let button = self.pinButton,
              let titleView = self.standardWindowButton(.closeButton)?.superview
        else {
            print("Could not get button view when reset tool rect")
            return
        }
        let radius: CGFloat = titleView.frame.height/2
        let frame = NSRect(x: titleView.frame.width-radius*2-10, y: 0, width: radius*2, height: radius*2)
        button.frame = frame
    }
    
}
