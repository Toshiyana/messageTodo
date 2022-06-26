//
//  ItemDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/16.
//

import Foundation

protocol ItemDelegate: AnyObject {
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
