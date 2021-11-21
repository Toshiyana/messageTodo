//
//  ItemDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/16.
//

import Foundation

protocol ItemDelegate {
//    func itemTableRelod()
//    func itemValueAdded(itemValue: Item?)
//    func itemValueEdited(itemValue: Item?)

//    func itemValueAdded(title: String, memo: String, reminderEnabled: Bool, reminder: Reminder?)
//    func itemValueEdited(title: String, memo: String, reminderEnabled: Bool, reminder: Reminder?)
    
    func itemValueAdded(title: String, memo: String, reminderEnabled: Bool,
                           wordEnabled: Bool,
                           wordBody: String,
                           timeInterval: TimeInterval,
                           date: Date?,
                           repeats: Bool,
                           reminderType: String)
    
    func itemValueEdited(title: String, memo: String, reminderEnabled: Bool,
                            wordEnabled: Bool,
                            wordBody: String,
                            timeInterval: TimeInterval,
                            date: Date?,
                            repeats: Bool,
                            reminderType: String)
}
