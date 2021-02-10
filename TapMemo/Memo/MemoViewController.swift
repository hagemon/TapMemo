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
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncMemo(_:)), name: .memoListContentDidChange, object: nil)
    }
    
    @objc func syncMemo(_ notification:NSNotification) {
        guard let info = notification.userInfo,
              let string = info["string"] as? String,
              let memo = info["memo"] as? CoreMemo,
              let textViewMemo = self.textView.memo,
              textViewMemo == memo
        else { return }
        self.textView.string = string
        self.textView.refresh()
    }
    
}
