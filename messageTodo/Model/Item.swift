//
//  Item.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var orderOfItem: Int = 0
}
