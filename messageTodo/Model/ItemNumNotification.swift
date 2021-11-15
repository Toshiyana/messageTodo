//
//  ItemNumNotification.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/13.
//

import Foundation
import RealmSwift

class ItemNumNotification: Object {
    @objc dynamic var reminderEnabled = false
//    @objc dynamic var reminder: Reminder
    var timeInterval: TimeInterval?
}
