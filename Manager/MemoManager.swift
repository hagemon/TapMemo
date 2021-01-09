//
//  MemoManager.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa

class MemoManager: NSObject {
    static let shared = MemoManager()
    
    var controllers: [MemoWindowController] = []
    let offset:CGFloat = 30
    
    func createMemo() {
        guard let rect = self.defaultRect() else { return }
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        let originRect = NSRect(origin: .zero, size: rect.size)
        let view = MemoTextView(frame: originRect)
        let scrollView = MemoScrollView(frame: originRect, textView: view)
        let window = MemoWindow(contentRect: rect, contentView: scrollView)
        let controller = MemoWindowController(window: window)
        
        self.controllers.append(controller)
//        window.makeFirstResponder(view)
//        window.makeKeyAndOrderFront(view)
        controller.showWindow(nil)
    }
    
    private func defaultRect() -> NSRect? {
        guard let screen = NSScreen.main else { return nil }
        let rect = screen.frame
        let width = rect.width / 4
        let height = rect.height / 3
        let offset = self.currentOffset()
        return NSRect(
            x: rect.width-width-offset,
            y: rect.height-self.offset-height-offset,
            width: width,
            height: height
        )
    }
    
    private func currentOffset() -> CGFloat {
        var count = 0
        for controller in self.controllers {
            if !controller.isMoved {
                count += 1
            }
        }
        return self.offset * CGFloat((count + 1))
    }
    
}
