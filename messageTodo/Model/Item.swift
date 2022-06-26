//
//  Item.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var orderOfItem: Int = 0
    @objc dynamic var reminderEnabled: Bool = false
    @objc dynamic var reminder: Reminder?

    // プライマリーキー：プライマリキーにidを設定した場合、idが一意の値のときのみデータベースに保存される。
    // UUID().uuidStringは一意の値を生成
    override class func primaryKey() -> String? {
        return "id"
    }
}

enum ReminderType: String {
    case none
    case time
    case calender
}

class Reminder: Object {
    @objc dynamic var wordEnabled: Bool = false
    @objc dynamic var wordBody: String = ""
    @objc dynamic var timeInterval: TimeInterval = 0
    @objc dynamic var date: Date?
    @objc dynamic var repeats: Bool = false
    @objc dynamic var reminderType = ReminderType.none.rawValue
    var reminderTypeEnum: ReminderType {
        get {
            return ReminderType(rawValue: reminderType)!
        }
        set {
            reminderType = newValue.rawValue
        }
    }
}
