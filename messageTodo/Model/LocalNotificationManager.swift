//
//  NotificationManager.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/13.
//

import Foundation
import UserNotifications
import UIKit
import SwiftUI

struct LocalNotification {
    var id: String
    var title: String
    var body: String
}

enum LocalNotificationDurationType {
    case days
    case hours
    case minutes
    case seconds
}

struct LocalNotificationManager {
    
    static private var notifications = [LocalNotification]()
    
    static private func requestPermission() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
            if granted == true && error == nil {
                // we have permission
            }
        }
    }
    
    static private func addNotification(title: String, body: String) -> Void {
        notifications.append(LocalNotification(id: UUID().uuidString, title: title, body: body))
    }
    
    static private func scheduleNotifications(_ durationInSeconds: Int, repeats: Bool, userInfo: [AnyHashable: Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
            content.userInfo = userInfo
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(durationInSeconds),
                repeats: repeats
            )
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
        notifications.removeAll()
    }
    
    static private func scheduleNotifications(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, userInfo: [AnyHashable: Any]) {
        var seconds = 0
        switch type {
        case .seconds:
            seconds = duration
        case .minutes:
            seconds = duration * 60
        case .hours:
            seconds = duration * 60 * 60
        case .days:
            seconds = duration * 60 * 60 * 24
        }
        scheduleNotifications(seconds, repeats: repeats, userInfo: userInfo)
    }
    
    static func cancel() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String, userInfo: [AnyHashable: Any]) {
        requestPermission()
        addNotification(title: title, body: body)
        scheduleNotifications(duration, of: type, repeats: repeats, userInfo: userInfo)
    }    
}

//enum LocalNotificationManagerConstants {
//    static let timeBasedNotificationThreadId =
//      "TimeBasedNotificationThreadId"
//    static let calendarBasedNotificationThreadId =
//      "CalendarBasedNotificationThreadId"
//}
//
//class LocalNotificationManager: ObservableObject {
//    static let shared = LocalNotificationManager()
//    @Published var settings: UNNotificationSettings?
//
//    // 通知許可の要求
//    func requestAuthorization(completion: @escaping (Bool) -> Void) {
//        // ユーザが承認を付与
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
//            // ユーザが承認を付与した後に通知設定を取得
//            self.fetchNotificationSettings()
//            completion(granted)
//        }
//    }
//
//    // 通知設定を取得
//    func fetchNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            DispatchQueue.main.async {
//                self.settings = settings
//            }
//        }
//    }
//
//    // 1: 通知スケジュールの作成
//    func scheduleNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "残りのタスク数は〇個です"
//        content.body = "名言"
////        content.categoryIdentifier = ""
////        content.userInfo = ""
//
//        // 通知の配信をトリガーする抽象クラス
//        var trigger: UNNotificationTrigger?
//
//    }
//
//    func removeScheduledNotification() {
//
//    }
//}
