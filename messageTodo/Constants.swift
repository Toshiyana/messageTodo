//
//  Constants.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import Foundation

struct K {
    // Cell
    static let todoCellIdentifier = "TodoCell"
    static let messageCellIdentifier = "MessageCell"
    static let colorCollectionCellIdentifier = "ColorCollectionCell"
    
    // Setting
    struct Setting {
        static let staticCellIdentifier = "SettingStaticCell"
        static let iconCellIdentifier = "SettingIconCell"
        static let colorCellIdentifier = "SettingColorCell"
        static let versionCellIdentifier = "SettingVersionCell"
    }
    
    // Segue
    static let settingToColorSegue = "goToColor"
    
    // UserDefault
    static let messagesOrder = "MessagesOrder"
    static let navbarColor = "NavBarColor"
}
