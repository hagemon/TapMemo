//
//  HelpViewController.swift
//  TapMemo
//
//  Created by 一折 on 2021/1/24.
//

import Cocoa
import WebKit

class HelpViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let url = URL(string: "https://hagemon.github.io/TapMemo/")
        self.webView.load(URLRequest(url: url!))
    }
    
    override func viewWillDisappear() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.helpWindowController = nil
    }
    
}
