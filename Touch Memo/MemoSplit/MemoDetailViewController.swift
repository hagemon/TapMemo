//
//  MemoDetailViewController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/13.
//

import Cocoa

class MemoDetailViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var textView: MemoDetailTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateContent()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateContent), name: .detailViewShouldUpdate, object: nil)
    }
    
    @objc func updateContent() {
        guard let memo = MemoListManager.shared.selectedMemo() else {
            self.textView.string = ""
            return
        }
        self.textView.string = memo.content
    }
    
    func textDidChange(_ notification: Notification) {
        MemoListManager.shared.updateSelectedMemo(content: self.textView.string)
    }
    
    @IBAction func createMemo(_ sender:Any) {
        NotificationCenter.default.post(name: .detailViewDidCreateMemo, object: nil)
    }
    
    @IBAction func pinMemo(_ sender:Any) {
        NotificationCenter.default.post(name: .detailViewDidPinMemo, object: nil)
    }
    
}
