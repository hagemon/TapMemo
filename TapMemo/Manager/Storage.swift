//
//  Storage.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/11.
//

import Cocoa
import HotKey

class Storage: NSObject {
    static func getKey() -> Key {
        guard let keyCode = UserDefaults.standard.value(forKey: "keyCode") as? UInt32 else {
            print("Using default hotkey")
            return .d
        }
        return Key(carbonKeyCode: keyCode)!
    }
    
    static func getModifierFlags() -> NSEvent.ModifierFlags {
        guard let modifiersFlags = UserDefaults.standard.value(forKey: "modifiersFlags") as? UInt32 else {
            print("Using default modifierFlags")
            return [.command, .shift]
        }
        return NSEvent.ModifierFlags(carbonFlags: modifiersFlags)
    }
    
    static func saveKey(key: Key) {
        UserDefaults.standard.setValue(key.carbonKeyCode, forKey: "keyCode")
    }
    
    static func saveModifierFlags(modifiers: NSEvent.ModifierFlags) {
        UserDefaults.standard.setValue(modifiers.carbonFlags, forKey: "modifiersFlags")
    }
    
    static func saveMemo(memo: Memo) {
        let key = memo.storedKey()
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: memo, requiringSecureCoding: false)
            UserDefaults.standard.setValue(data, forKey: key)
        }
        catch {
            print(error)
            return
        }
    }
    
    static func removeMemo(memo: Memo) {
        let key = memo.storedKey()
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func removeAllMemos() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            guard key.starts(with: "memo-") else {continue}
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    
    static func getMemos() -> [Memo] {
        var memos: [Memo] = []
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            guard key.starts(with: "memo-") else {continue}
            do {
                guard let data = UserDefaults.standard.object(forKey: key) as? Data,
                      let memo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Memo
                else { return [] }
                memos.append(memo)
            }
            catch {
                print(error)
                return []
            }
        }
        memos.sort(by: {
            m1, m2 in
            return m1.date > m2.date
        })
        return memos
    }
}
