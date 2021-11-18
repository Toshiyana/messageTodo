//
//  ItemDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/16.
//

import Foundation

protocol ItemDelegate {
    func itemValueAdded(itemValue: Item?)
    func itemValueEdited(itemValue: Item?)

//    func itemValueAdded(title: String, memo: String, reminderEnabled: Bool, reminder: Reminder?)
//    func itemValueEdited(title: String, memo: String, reminderEnabled: Bool, reminder: Reminder?)
}
