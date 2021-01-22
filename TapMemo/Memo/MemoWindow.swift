//
//  MemoWindow.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Cocoa


class MemoWindow: NSWindow {
        
    override func awakeFromNib() {
        self.isMovableByWindowBackground = true
        self.level = .statusBar
    }
    
}
