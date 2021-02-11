//
//  MemoSideViewController.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/13.
//

import Cocoa

class MemoSideViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.selectFirstCell()
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncStoredMemo(_:)), name: .memoListShouldSync, object: nil)
        // common notification for tool bar item
        NotificationCenter.default.addObserver(self, selector: #selector(self.commonCreateMemo), name: .detailViewDidCreateMemo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.commonPinMemo), name: .detailViewDidPinMemo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateStatus), name: .memoStatusDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncRemote(_:)), name: .NSPersistentStoreRemoteChange, object: (NSApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator)
    }
    
    override func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Datasource and Delegate
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MemoListManager.shared.memos.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) as? NSTableCellView else {
            print("Could not load cells")
            return nil
        }
        let name = cell.viewWithTag(1) as! NSTextField
        let date = cell.viewWithTag(2) as! NSTextField
        let status = cell.viewWithTag(3) as! NSTextField
        let memo = MemoListManager.shared.memos[row]
        name.stringValue = memo.title!
        date.stringValue = memo.date!
        status.stringValue = MemoListManager.shared.memoStatus[row] ? "*" : ""
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        MemoListManager.shared.storeSelectedMemo()
        MemoListManager.shared.index = row
        self.updateDetailContent()
        return true
    }
    
    func tableView(_ tableView: NSTableView, shouldTypeSelectFor event: NSEvent, withCurrentSearch searchString: String?) -> Bool {
        return false
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        guard edge == .trailing else {return []}
        let action = NSTableViewRowAction(style: .destructive, title: "Delete", handler: {
            _, row in
            if let memo = MemoListManager.shared.removeMemo(at: row) {
                MemoManager.shared.removeMemo(memo: memo)
            }
            self.tableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
            self.selectFirstCell()
        })
        action.backgroundColor = .red
        return [action]
    }
    
    func selectFirstCell() {
        self.updateDetailContent()
        guard !MemoListManager.shared.isEmpty else {return}
        MemoListManager.shared.index = 0
        self.tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }
    
    @objc func updateStatus(_ notification:NSNotification) {
        guard let info = notification.userInfo,
              let memo = info["memo"] as? CoreMemo,
              let index = MemoListManager.shared.indexOfMemo(memo: memo)
        else { return }
        self.tableView.reloadData(forRowIndexes: IndexSet(integer: index), columnIndexes: IndexSet(integer: 0))
    }
    
    // MARK: - Notifications
    
    func updateDetailContent() {
        NotificationCenter.default.post(name: .detailViewShouldUpdate, object: nil)
    }
    
    // Called after storage
    @objc func syncStoredMemo(_ notification:Notification) {
        guard let info = notification.userInfo,
              let memo = info["memo"] as? CoreMemo
        else {
            print("Could not load info when memo saved")
            return
        }
        MemoListManager.shared.syncMemo(memo: memo)
        self.selectFirstCell()
        self.tableView.reloadData()
    }
    
    @objc func syncRemote(_ notification:Notification) {
        guard let info = notification.userInfo,
              let token = info["historyToken"] as? NSPersistentHistoryToken,
              token != CoreUtil.lastToken
        else {
            return
        }
        let fetchHistoryRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: CoreUtil.lastToken)
        CoreUtil.lastToken = token
        let context = CoreUtil.container.viewContext
        guard
            let historyResult = try? context.execute(fetchHistoryRequest)
                as? NSPersistentHistoryResult,
            let history = historyResult.result as? [NSPersistentHistoryTransaction]
            else {
                fatalError("Could not convert history result to transactions.")
        }
        guard history.count > 0,
              let trans = history.last
        else {
            return
        }
        context.perform {
            context.mergeChanges(fromContextDidSave: trans.objectIDNotification())
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView.reloadData()
                self.updateDetailContent()
                guard let memo = MemoListManager.shared.selectedMemo() else { return }
                NotificationCenter.default.post(name: .memoListContentDidChange, object: nil, userInfo: ["memo": memo, "string": memo.content!])
            }
        }
    }

    
    // MARK: - Toolbar Actions
    
    @IBAction func createMemo(_ sender: Any) {
        self.commonCreateMemo()
    }
    
    @IBAction func pinMemo(_ sender: Any) {
        self.commonPinMemo()
    }
    
    @objc func commonCreateMemo() {
        if MemoListManager.shared.memos.count > 0 {
            if MemoListManager.shared.memos[0].content!.count == 0 {
                return
            } else {
                MemoListManager.shared.storeSelectedMemo()
            }
        }
        MemoListManager.shared.addMemo(memo: CoreUtil.createMemo())
        self.selectFirstCell()
        self.tableView.reloadData()
    }
    
    @objc func commonPinMemo() {
        guard let memo = MemoListManager.shared.selectedMemo() else { return }
        MemoListManager.shared.storeSelectedMemo()
        MemoManager.shared.postMemo(memo: memo)
    }
    
}
