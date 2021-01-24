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
    var isEmpty: Bool {
        get {
            return self.memos.count == 0
        }
    }
    
    func clearMemos() {
        self.memos = []
    }
    
    func loadMemos() {
        self.memos = Storage.getMemos()
    }
    
    func addMemo(memo: Memo) {
        self.memos.insert(memo, at: 0)
    }
    
    func selectedMemo() -> Memo? {
        guard memos.count > self.index else {
            return nil
        }
        return self.memos[self.index]
    }
    
    func updateSelectedMemo(content: String) {
        guard let memo = self.selectedMemo() else { return }
        memo.update(content: content)
    }
    
    func storeSelectedMemo() {
        guard let memo = self.selectedMemo() else { return }
        if memo.changed {
            Storage.saveMemo(memo: memo)
        }
    }
    
    func indexOfMemo(memo: Memo) -> Int? {
        return self.memos.firstIndex(of: memo)
    }
    
    func syncMemo(memo: Memo) {
        if self.memos.contains(memo) {
            guard let index = self.memos.firstIndex(of: memo) else {return}
            self.memos.remove(at: index)
            self.memos.insert(memo, at: 0)
        }
        else {
            if self.isEmpty {
                self.memos.insert(memo, at: 0)
            } else {
                if self.memos[0].content.count == 0 {
                    self.memos[0] = memo
                }
                else {
                    self.memos.insert(memo, at: 0)
                }
            }
        }
        self.index = 0
    }
    
    func removeSelectedMemo() {
        guard let memo = self.selectedMemo() else { return }
        Storage.removeMemo(memo: memo)
        self.memos.remove(at: self.index)
        self.index = 0
    }
    
    func removeMemo(at index:Int) {
        guard index < self.memos.count && index >= 0 else {return}
        let memo = self.memos[index]
        Storage.removeMemo(memo: memo)
        self.memos.remove(at: index)
        self.index = 0
    }
}
