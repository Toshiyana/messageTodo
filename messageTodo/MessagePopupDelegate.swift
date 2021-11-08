//
//  MessagePopupDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/05.
//

import Foundation

protocol MessagePopupDelegate {
    func popupValueAdded(name: String, content: String)
    func popupValueEdited(name: String, content: String)
}
