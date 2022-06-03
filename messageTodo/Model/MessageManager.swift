//
//  MessageManager.swift
//  messageTodo
//
//  Created by Toshiyana on 2022/06/03.
//

import Foundation
import RealmSwift

class MessageManager {
    static let shared = MessageManager()
    
    func loadMessages(in order: String?) -> Results<Message>? {
        guard let realm = try? Realm() else { return nil }
        switch order {
        case "DateOrder":
            return realm.objects(Message.self).sorted(byKeyPath: "dateCreated", ascending: true)
        case "TitleOrder":
            return realm.objects(Message.self).sorted(byKeyPath: "content", ascending: true)
        case "NameOrder":
            return realm.objects(Message.self).sorted(byKeyPath: "name", ascending: true)
        default:
            return realm.objects(Message.self).sorted(byKeyPath: "dateCreated", ascending: true) //defaultは実行されない
        }
    }
    
    func save(message: Message) {
        guard let realm = try? Realm() else { return }
        do {
            try realm.write {
                realm.add(message)
            }
        } catch {
            print("Error saving message. \(error)")
        }
    }
    
    func delete(message: Message) {
        guard let realm = try? Realm() else { return }
        do {
            try realm.write {
                realm.delete(message)
            }
        } catch {
            print("Error deleting the message, \(error)")
        }
    }
    
    func deleteAllMessage() {
        guard let realm = try? Realm() else { return }
        let allMessages = realm.objects(Message.self)
        do {
            try realm.write {
                realm.delete(allMessages)
            }
        } catch {
            print("Error deleting All Messages, \(error)")
        }
    }
    
    func edit(message: Message, name: String, content: String, imageData: Data?) {
        guard let realm = try? Realm() else { return }
        do {
            try realm.write {
                message.name = name
                message.content = content
                message.dateCreated = Date()
                message.imageData = imageData
            }
        } catch {
            print("Error editing message. \(error)")
        }
    }
    
    func sort(by order: String) -> Results<Message>? {
        guard let realm = try? Realm() else { return nil }
        return realm.objects(Message.self).sorted(byKeyPath: order, ascending: true)
    }
}
