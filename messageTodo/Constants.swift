//
//  Constants.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import Foundation

struct K {
    // URL
    struct Url {
        static let appStore = "https://www.google.com"
        static let requestForm = "https://forms.gle/ngjNFq8cLZw9xCaV9"
        static let appMaunual = "https://lightning-lan-4b9.notion.site/3f3fd3c9ea95424ab33b83403db9aa80"
    }
    
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
    static let messageListTomessagePopup = "goToMessagePopup"
    static let itemListToItemContent = "goToItemContent"
    static let itemContentToTimeSetting = "goToTimeSetting"
    
    // UserDefault
    static let messagesOrder = "MessagesOrder"
    static let navbarColor = "NavBarColor"
}
