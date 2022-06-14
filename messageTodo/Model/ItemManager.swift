//
//  ItemManager.swift
//  messageTodo
//
//  Created by Toshiyana on 2022/06/03.
//

import Foundation
import RealmSwift

class ItemManager {
    // MARK: - Singleton Implementation
    static let shared = ItemManager()
    
    let realm = try? Realm()
    
    func loadItems() -> Results<Item>? {
        return realm?.objects(Item.self).sorted(byKeyPath: "orderOfItem")
    }
    
    func save(item: Item) {
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            print("Error saving item. \(error)")
        }
    }
    
    func delete(item: Item) {
        do {
            try realm?.write {
                realm?.delete(item)
            }
        } catch {
            print("Error deleting the item, \(error)")
        }
    }
    
    func deleteAllItem() {
        guard let allItems = realm?.objects(Item.self) else { return }
        do {
            try realm?.write {
                realm?.delete(allItems)
            }
        } catch {
            print("Error deleting All item, \(error)")
        }
    }
    
    func edit(item: Item, title: String, memo: String, reminderEnabled: Bool, wordEnabled: Bool, wordBody: String, timeInterval: TimeInterval, date: Date?, repeats: Bool, reminderType: String) {
        do {
            try realm?.write {
                item.title = title
                item.memo = memo
                item.reminderEnabled = reminderEnabled
                // About reminder
                item.reminder?.wordEnabled = wordEnabled
                item.reminder?.wordBody = wordBody
                item.reminder?.timeInterval = timeInterval
                item.reminder?.date = date
                item.reminder?.repeats = repeats
                item.reminder?.reminderType = reminderType

            }
        } catch {
            print("Error editing item. \(error)")
        }
    }
    
    func check(item: Item) {
        do {
            try realm?.write {
                //realm.delete(item)//tapした時にitemの除去
                item.isDone = !item.isDone
            }
        } catch {
            print("Error saving done status, \(error)")
        }
    }
    
    func sort(todoItems: Results<Item>?, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        // move cell in Editing mode
        do {
            try realm?.write {
                let sourceItem = todoItems?[sourceIndexPath.row]
                let destinationItem = todoItems?[destinationIndexPath.row]

                let destinationItemOrder = destinationItem?.orderOfItem

                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in sourceIndexPath.row ... destinationIndexPath.row {
                        todoItems?[index].orderOfItem -= 1
                    }
                } else {
                    for index in (destinationIndexPath.row ..< sourceIndexPath.row).reversed() {
                        todoItems?[index].orderOfItem += 1
                    }
                }

                guard let destOrder = destinationItemOrder else {
                    fatalError("destinationItemOrder does not exist.")
                }
                sourceItem?.orderOfItem = destOrder
            }
        } catch {
            print("Error moving the cell. \(error)")
        }
    }
    
}
