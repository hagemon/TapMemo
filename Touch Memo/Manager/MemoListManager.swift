//
//  MemoListManager.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/16.
//

import Cocoa

class MemoListManager: NSObject {
    static let shared = MemoListManager()
    var memos: [Memo] = []
    var index = 0
    
    func clearMemos() {
        self.memos = []
    }
    
    func loadMemos() {
        self.memos = Storage.getMemos()
    }
    
    func selectedMemo() -> Memo? {
        guard memos.count > 0 else {
            return nil
        }
        return self.memos[index]
    }
    
    func updateSelectedMemo(content: String) {
        guard let memo = self.selectedMemo() else { return }
        memo.update(content: content)
    }
}
