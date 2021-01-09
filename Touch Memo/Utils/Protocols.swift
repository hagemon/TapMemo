//
//  Delegates.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/9.
//

import Foundation

protocol MemoDelegate: class {
    func drag(from startPoint: NSPoint, to endPoint: NSPoint)
}
