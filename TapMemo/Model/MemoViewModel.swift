//
//  MemoViewModel.swift
//  TapMemo
//
//  Created by 一折 on 2021/2/10.
//

import Cocoa

class MemoViewModel: NSObject {
    let memo: CoreMemo
    init(memo: CoreMemo) {
        self.memo = memo
    }
}
