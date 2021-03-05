//
//  CoreMemo+Extensions.swift
//  TapMemo
//
//  Created by 一折 on 2021/2/10.
//

import Cocoa


struct AssociatedKeys {
    static var changedKey = "changed"
}


extension CoreMemo {
        
    func update(content: String){
        self.setValue(content, forKey: "content")
        self.setValue(MDParser.getTitle(content: content), forKey: "title")
        self.setValue(Date.now().toString(), forKey: "date")
    }
    
    static func == (a: CoreMemo, b: CoreMemo) -> Bool {
        return a.uuid == b.uuid
    }
    
    var changed: Bool {
        set {
            guard self.changed != newValue else {return}
            objc_setAssociatedObject(self, &AssociatedKeys.changedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .memoStatusDidChange, object: nil, userInfo: ["memo":self, "changed": newValue])
        }
        get {
            guard let c = objc_getAssociatedObject(self, &AssociatedKeys.changedKey) as? Bool else {return true}
            return c
        }
    }
}
