//
//  Message.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import Foundation
import RealmSwift

final class Message: Object {
    @objc dynamic var content: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var imageData: Data?
}
