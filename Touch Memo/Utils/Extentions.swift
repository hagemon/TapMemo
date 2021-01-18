//
//  Extentions.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Foundation

extension NSPoint {
    func offsetBy(dx:CGFloat, dy: CGFloat) -> NSPoint {
        return NSPoint(x: self.x+dx, y: self.y+dy)
    }
}

extension Date {
    func toString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        let string = dateFormatter.string(from: self)
        return string
    }
}

extension Notification.Name {
    static let detailViewShouldUpdate = Notification.Name(rawValue: "detailViewShouldUpdate")
    static let detailViewDidLaunch = Notification.Name(rawValue: "detailViewDidLaunch")
    static let detailViewDidSave = Notification.Name(rawValue: "detailViewDidSave")
    static let detailViewDidCreateMemo = Notification.Name(rawValue: "detailViewDidCreateMemo")
    static let detailViewDidPinMemo = Notification.Name(rawValue: "detailViewDidPinMemo")
    static let detailViewTextDidChange = Notification.Name(rawValue: "detailViewTextDidChange")
    static let memoDidStore = Notification.Name(rawValue: "memoDidStore")
    static let memoListShouldSync = Notification.Name(rawValue: "memoListShouldSync")
}
