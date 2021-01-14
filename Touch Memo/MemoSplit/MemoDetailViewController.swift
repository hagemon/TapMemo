//
//  MemoDetailViewController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/13.
//

import Cocoa

class MemoDetailViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateContent(_:)), name: .detailViewShouldUpdate, object: nil)
        NotificationCenter.default.post(name: .detailViewLaunched, object: nil, userInfo: ["controller":self])
    }
    
    @objc func updateContent(_ notification: Notification) {
        guard let info = notification.userInfo,
              let content = info["content"] as? String
        else { return }
        self.textView.string = content
    }
    
}
