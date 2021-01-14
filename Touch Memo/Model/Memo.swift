//
//  Memo.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/13.
//

import Cocoa

class Memo: NSObject, NSCoding {
    var title: String
    var date: String
    var content: String
    private let uuid: String
    
    init(title: String, date: Date, content: String) {
        self.title = title
        self.date = date.toString()
        self.content = content
        self.uuid = UUID().uuidString
    }
    
    required init?(coder: NSCoder) {
        guard let title = coder.decodeObject(forKey: "title") as? String,
              let date = coder.decodeObject(forKey: "date") as? String,
              let content = coder.decodeObject(forKey: "content") as? String,
              let uuid = coder.decodeObject(forKey: "uuid") as? String
        else {
            return nil
        }
        self.title = title
        self.date = date
        self.content = content
        self.uuid = uuid
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.date , forKey: "date")
        coder.encode(self.content, forKey: "content")
        coder.encode(self.uuid, forKey: "uuid")
    }
    
    func storedKey() -> String {
        return "memo-"+self.uuid
    }
    
    func update(content: String){
        self.content = content
        self.date = Date(timeIntervalSinceNow: 0).toString()
    }
    
}

extension Memo {
    static func == (aMemo: Memo, bMemo: Memo) -> Bool {
        return aMemo.uuid == bMemo.uuid
    }
}
