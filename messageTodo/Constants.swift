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
        static let appStore = "https://apps.apple.com/app/wordstodo/id1598603193"
        static let requestForm = "https://forms.gle/ngjNFq8cLZw9xCaV9"
        static let appMaunual = "https://lightning-lan-4b9.notion.site/3f3fd3c9ea95424ab33b83403db9aa80"
    }

    // Cell
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

    struct Admob {
        static let myId = "ca-app-pub-3271463287204513/2391554920"
        static let testId = "ca-app-pub-3940256099942544/2934735716"
    }
}
