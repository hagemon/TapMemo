//
//  CoreMemo+Extensions.swift
//  TapMemo
//
//  Created by 一折 on 2021/2/10.
//

import Cocoa


extension CoreMemo {
    
    func update(content: String){
        self.setValue(content, forKey: "content")
        self.setValue(MDParser.getTitle(content: content), forKey: "title")
        self.setValue(Date.now().toString(), forKey: "date")
    }
    
}
