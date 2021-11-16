//
//  ItemDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/16.
//

import Foundation

protocol ItemDelegate {
    func itemValueAdded(title: String, memo: String)
    func itemValueEdited(title: String, memo: String)
}
