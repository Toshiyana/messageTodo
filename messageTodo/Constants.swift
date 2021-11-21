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
    static let messageImageCellIdentifier = "ImageMessageCell"
    static let colorCollectionCellIdentifier = "ColorCollectionCell"
    
    // Setting
    struct Setting {
        static let staticCellIdentifier = "SettingStaticCell"
        static let iconCellIdentifier = "SettingIconCell"
        static let colorCellIdentifier = "SettingColorCell"
        static let versionCellIdentifier = "SettingVersionCell"
    }
    struct Scheduler {
        static let notificationCellIdentifier = "NotificationCell"
        static let wordCellIdentifier = "WordCell"
        static let timeCellIdentifier = "TimeCell"
    }
    
    // Segue
    static let settingToColorSegue = "goToColor"
//    static let settingToScheduler = "goToScheduler"
    static let messageListTomessagePopup = "goToMessagePopup"
    static let itemListToItemContent = "goToItemContent"
    static let itemContentToTimeSetting = "goToTimeSetting"

//    static let itemListToitem = "goToItem"
//    static let itemToScheduler = "goToScheduler"
//    static let schedulerToTimeSetting = "goToTimeSetting"
    
    // UserDefault
    static let messagesOrder = "MessagesOrder"
    static let navbarColor = "NavBarColor"
}
