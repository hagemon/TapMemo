//
//  MemoDetailViewController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/13.
//

import Cocoa

class MemoDetailViewController: NSViewController, NSTextViewDelegate, MemoSideViewControllerDelegate {

    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateContent(_:)), name: .detailViewShouldUpdate, object: nil)
        NotificationCenter.default.post(name: .detailViewDidLaunch, object: nil, userInfo: ["controller":self])
    }
    
    @objc func updateContent(_ notification: Notification) {
        guard let info = notification.userInfo,
              let content = info["content"] as? String
        else { return }
        self.textView.string = content
    }
    
    func currentMemoContent() -> String {
        return self.textView.string
    }
    
    func textDidChange(_ notification: Notification) {
        NotificationCenter.default.post(name: .detailViewTextDidChange, object: nil, userInfo: ["content":self.textView.string])
    }
    
    @IBAction func createMemo(_ sender:Any) {
        NotificationCenter.default.post(name: .detailViewDidCreateMemo, object: nil)
    }
    
    @IBAction func pinMemo(_ sender:Any) {
        NotificationCenter.default.post(name: .detailViewDidPinMemo, object: nil)
    }
    
}
