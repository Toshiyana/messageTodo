//
//  SchedulerDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/17.
//

import Foundation

protocol TimeSettingDelegate {
    func setTimeInterval(timeInv: TimeInterval, timeType: ReminderType, timeRepeats: Bool)
    func setDate(timeDate: Date, timeType: ReminderType)
}
