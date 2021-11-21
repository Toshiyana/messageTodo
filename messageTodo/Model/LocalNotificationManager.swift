//
//  NotificationManager.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/13.
//

import Foundation
import UserNotifications
import UIKit

enum LocalNotificationManagerConstants {
    static let timeBasedNotificationThreadId =
      "TimeBasedNotificationThreadId"
    static let calendarBasedNotificationThreadId =
      "CalendarBasedNotificationThreadId"
}

class LocalNotificationManager: ObservableObject {
    static let shared = LocalNotificationManager()
    @Published var settings: UNNotificationSettings?

    // 通知許可の要求
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // ユーザが承認を付与
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            // ユーザが承認を付与した後に通知設定を取得
            self.fetchNotificationSettings()
            completion(granted)
        }
    }

    // 通知設定を取得
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }

    func removeScheduledNotification(item: Item) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id])
    }
    
    func removeScheduleAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 1: 通知スケジュールの作成
    func scheduleNotification(item: Item) {
        guard let itemReminder = item.reminder else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = itemReminder.wordBody
        content.sound = UNNotificationSound.default
//        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = ["itemID": item.id] // 通知を識別するID

        // 通知の配信をトリガーする抽象クラス
        var trigger: UNNotificationTrigger?
        switch itemReminder.reminderTypeEnum {
        case .time:
            if let timeInterval = item.reminder?.timeInterval, timeInterval != 0{
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: itemReminder.repeats)
            }
            content.threadIdentifier = LocalNotificationManagerConstants.timeBasedNotificationThreadId
            
        case .calender:
            if let date = itemReminder.date {
                trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date), repeats: itemReminder.repeats)
            }
            content.threadIdentifier = LocalNotificationManagerConstants.calendarBasedNotificationThreadId
        case .none:
            return
        }
        
        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }

}
