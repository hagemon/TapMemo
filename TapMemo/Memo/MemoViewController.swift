//
//  MemoViewController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/18.
//

import Cocoa

class MemoViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var textView: MemoTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncMemo(_:)), name: .memoListStatusDidChange, object: nil)
    }
    
    @objc func syncMemo(_ notification:NSNotification) {
        guard let info = notification.userInfo,
              let memo = info["memo"] as? Memo
        else { return }
        NotificationCenter.default.post(name: .memoStatusDidChange, object: nil, userInfo: ["memo":memo])
        if !memo.changed {
            self.textView.memo = memo
        }
    }
    
}
