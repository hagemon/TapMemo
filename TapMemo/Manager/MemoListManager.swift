//
//  MemoListManager.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/16.
//

import Cocoa

class MemoListManager: NSObject {
    static let shared = MemoListManager()
    var memos: [CoreMemo] = []
    var memoStatus: [Bool] = []
    var index = 0
    var isEmpty: Bool {
        get {
            return self.memos.count == 0
        }
    }
    
    func clearMemos() {
        self.memos = []
        self.memoStatus = []
    }
    
    func loadMemos() {
//        self.memos = Storage.getMemos()
        self.memos = CoreUtil.getCoreMemos()
        self.memoStatus = Array(repeating: false, count: self.memos.count)
    }
    
    func addMemo(memo: CoreMemo) {
        self.memos.insert(memo, at: 0)
        self.memoStatus.insert(false, at: 0)
    }
    
    func selectedMemo() -> CoreMemo? {
        guard memos.count > self.index else {
            return nil
        }
        return self.memos[self.index]
    }
    
    func setSelectedStatus(status: Bool) {
        guard self.memoStatus[self.index] != status,
              let memo = self.selectedMemo() else {return}
        self.memoStatus[self.index] = status
        NotificationCenter.default.post(name: .memoStatusDidChange, object: nil, userInfo: ["memo":memo, "changed": status])
    }
    
    func setMemoStatus(memo: CoreMemo, status: Bool) {
        guard let index = self.indexOfMemo(memo: memo),
              self.memoStatus[index] != status
        else { return }
        self.memoStatus[index] = status
        NotificationCenter.default.post(name: .memoStatusDidChange, object: nil, userInfo: ["memo":memo, "changed": status])
    }
    
    func updateSelectedMemo(content: String) {
        guard let memo = self.selectedMemo() else { return }
        memo.update(content: content)
    }
    
    func storeSelectedMemo() {
        if self.memoStatus[self.index] {
//            Storage.saveMemo(memo: memo)
            CoreUtil.save()
        }
    }
    
    func indexOfMemo(memo: CoreMemo) -> Int? {
        return self.memos.firstIndex(of: memo)
    }
    
    func syncMemo(memo: CoreMemo) {
        if self.memos.contains(memo) {
            guard let index = self.memos.firstIndex(of: memo) else {return}
            self.memos.remove(at: index)
            self.memoStatus.remove(at: index)
            self.memos.insert(memo, at: 0)
            self.memoStatus.insert(false, at: 0)
        }
        else {
            if self.isEmpty {
                self.memos.insert(memo, at: 0)
                self.memoStatus.insert(false, at: 0)
            } else {
                if self.memos[0].content!.count == 0 {
                    self.memos[0] = memo
                }
                else {
                    self.memos.insert(memo, at: 0)
                    self.memoStatus.insert(false, at: 0)
                }
            }
        }
        self.index = 0
    }
    
    func removeSelectedMemo(){
        guard let memo = self.selectedMemo() else { return }
//        Storage.removeMemo(memo: memo)
        CoreUtil.removeMemo(memo: memo)
        self.memos.remove(at: self.index)
        self.memoStatus.remove(at: self.index)
        self.index = 0
    }
    
    func removeMemo(at index:Int) -> CoreMemo?  {
        guard index < self.memos.count && index >= 0 else {return nil}
        let memo = self.memos[index]
//        Storage.removeMemo(memo: memo)
        CoreUtil.removeMemo(memo: memo)
        self.memos.remove(at: index)
        self.memoStatus.remove(at: index)
        self.index = 0
        return memo
    }
}
