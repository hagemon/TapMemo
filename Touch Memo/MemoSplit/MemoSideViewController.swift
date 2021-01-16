//
//  MemoSideViewController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/13.
//

import Cocoa

class MemoSideViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    var memos = Storage.getMemos()
    weak var MemoSideViewControllerDelegate: MemoSideViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.postTableviewCellSelected(_:)), name: .detailViewDidLaunch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addMemo(_:)), name: .didSaveMemo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMemos(_:)), name: .detailViewDidSave, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.commonCreateMemo), name: .detailViewDidCreateMemo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.commonPinMemo), name: .detailViewDidPinMemo, object: nil)
    }
    
    // MARK: - Datasource and Delegate
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.memos.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) as? NSTableCellView else {
            print("Could not load cells")
            return nil
        }
        let name = cell.viewWithTag(1) as! NSTextField
        let date = cell.viewWithTag(2) as! NSTextField
        name.stringValue = self.memos[row].title
        date.stringValue = self.memos[row].date
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        guard let delegate = self.MemoSideViewControllerDelegate else { return false }
        let oldRow = self.tableView.selectedRow
        if oldRow >= 0{
            let memo = self.memos[oldRow]
            if memo.content != delegate.currentMemoContent() {
                memo.update(content: delegate.currentMemoContent())
                Storage.saveMemo(memo: memo)
            }
        }
        self.updateDetailContent(content: self.memos[row].content)
        return true
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        guard edge == .trailing else {return []}
        let action = NSTableViewRowAction(style: .destructive, title: "Delete", handler: {
            _, row in
            Storage.removeMemo(memo: self.memos[row])
            self.memos.remove(at: row)
            self.tableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
            if self.memos.count > 0 {
                self.tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
                self.updateDetailContent(content: self.memos[0].content)
            } else {
                self.updateDetailContent(content: "")
            }
        })
        action.backgroundColor = .red
        return [action]
    }
    
    // MARK: - Notifications
    
    @objc func postTableviewCellSelected(_ notification:Notification) {
        let row = self.tableView.selectedRow
        guard row >= 0,
              let info = notification.userInfo,
              let controller = info["controller"] as? MemoDetailViewController
        else { return }
        self.MemoSideViewControllerDelegate = controller
        controller.textView.string = self.memos[row].content
    }
    
    func updateDetailContent(content: String) {
        NotificationCenter.default.post(name: .detailViewShouldUpdate, object: nil, userInfo: ["content":content])
    }
    
    @objc func addMemo(_ notification:Notification) {
        guard let info = notification.userInfo,
              let memo = info["memo"] as? Memo
        else {
            print("Could not load info when memo saved")
            return
        }
        if self.memos.contains(memo) {
            let index = self.memos.firstIndex(of: memo)!
            self.memos.remove(at: index)
        }
        self.memos.insert(memo, at: 0)
        self.tableView.reloadData()
    }
    
    @objc func updateMemos(_ notification:Notification) {
        guard let info = notification.userInfo,
              let content = info["content"] as? String
        else { return }
        let index = self.tableView.selectedRow
        guard index >= 0 else {return}
        let memo = self.memos[index]
        memo.update(content: content)
        self.memos.remove(at: index)
        self.memos.insert(memo, at: 0)
        Storage.saveMemo(memo: memo)
        
    }
    
    // MARK: - Toolbar Actions
    
    @IBAction func createMemo(_ sender: Any) {
        self.commonCreateMemo()
    }
    
    @IBAction func pinMemo(_ sender: Any) {
        self.commonPinMemo()
    }
    
    @objc func commonCreateMemo() {
        guard let delegate = self.MemoSideViewControllerDelegate else { return }
        if self.memos.count > 0 {
            if self.memos[0].content.count == 0 {
                return
            } else {
                self.memos[0].update(content: delegate.currentMemoContent())
                Storage.saveMemo(memo: self.memos[0])
            }
        }
        let memo = Memo()
        self.memos.insert(memo, at: 0)
        self.tableView.reloadData()
    }
    
    @objc func commonPinMemo() {
        
    }
}

protocol MemoSideViewControllerDelegate: class {
    func currentMemoContent() -> String
}
