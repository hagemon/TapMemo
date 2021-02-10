//
//  CoreUtil.swift
//  TapMemo
//
//  Created by 一折 on 2021/2/10.
//

import Cocoa
import CoreData

final class CoreUtil: NSObject {
    static let container = (NSApplication.shared.delegate as! AppDelegate).persistentContainer
    static let context = container.viewContext
    static var lastToken: NSPersistentHistoryToken? = nil {
        didSet{
            guard let token = lastToken,
                  let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
            else { return }
            do {
                try data.write(to: tokenFile)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static var tokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("TapMemo", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    static func createMemo(title: String="", content: String="# ", date: Date=Date.now()) -> CoreMemo {
        let entity = NSEntityDescription.entity(forEntityName: "CoreMemo", in: self.context)
        let memo = NSManagedObject(entity: entity!, insertInto: self.context) as! CoreMemo
        memo.setValue(UUID().uuidString, forKey: "uuid")
        memo.setValue(title, forKey: "title")
        memo.setValue(content, forKey: "content")
        memo.setValue(date.toString(), forKey: "date")
        return memo
    }
    
    
    static func save() {
        do {
            try self.context.save()
        } catch {
            print("Store failed")
            print(error)
        }
    }
    
    static func removeMemo(memo: CoreMemo) {
        do {
            self.context.delete(memo)
            try self.context.save()
        } catch {
            print("Delete \(memo.title ?? "nil") failed")
            print(error)
        }
    }
    
    static func getCoreMemos(handler: ()->()={}) -> [CoreMemo] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreMemo")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.returnsObjectsAsFaults = false
        do {
            print("------")
            let result = try context.fetch(request) as! [CoreMemo]
            for data in result {
               print(data.value(forKey: "uuid") as! String, data.value(forKey: "date") as! String)
            }
            handler()
            return result
            
        } catch {
            print("Load Failed")
            return []
        }
    }
    
}
