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
    
    func postMemo(memo: CoreMemo=CoreUtil.createMemo()) {
        guard let rect = self.defaultRect() else {
            print("Could not get default rect in MemoManager.createMemo")
            return
        }
        
        for controller in self.controllers {
            if controller.memo == memo {
                return
            }
        }
        
        guard let storyboard = NSStoryboard.main,
              let controller = storyboard.instantiateController(withIdentifier: "Memo") as? MemoWindowController,
              let window = controller.window,
              let viewController = controller.contentViewController as? MemoViewController,
              let textView = viewController.textView
        else {
            return
        }
        textView.memo = memo
        textView.string = memo.content!
        textView.refresh()
        controller.memo = memo
        window.setFrameOrigin(rect.origin)
        self.controllers.append(controller)
        NSApplication.shared.activate(ignoringOtherApps: true)
        controller.showWindow(nil)
    }
    
    func removeMemo(memo: CoreMemo) {
        for controller in self.controllers {
            if memo == controller.memo {
                controller.close()
            }
        }
    }
    
    private func defaultRect() -> NSRect? {
        guard let screen = NSScreen.main else {
            print("Could not get screen in MemoManager.defaultRect")
            return nil
        }
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
