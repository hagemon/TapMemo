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
        if self.is24Hour() {
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss a"
        }
        let string = dateFormatter.string(from: self)
        return string
    }
    
    func is24Hour() -> Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") == nil
    }
}

extension Notification.Name {
    static let detailViewShouldUpdate = Notification.Name(rawValue: "detailViewShouldUpdate")
    static let detailViewDidLaunch = Notification.Name(rawValue: "detailViewDidLaunch")
    static let detailViewDidSave = Notification.Name(rawValue: "detailViewDidSave")
    static let detailViewDidCreateMemo = Notification.Name(rawValue: "detailViewDidCreateMemo")
    static let detailViewDidPinMemo = Notification.Name(rawValue: "detailViewDidPinMemo")
    static let detailViewTextDidChange = Notification.Name(rawValue: "detailViewTextDidChange")
    static let memoListShouldSync = Notification.Name(rawValue: "memoListShouldSync")
    static let memoStatusDidChange = Notification.Name(rawValue: "memoStatusDidChange")
    static let memoListStatusDidChange = Notification.Name(rawValue: "memoListStatusDidChange")
}
