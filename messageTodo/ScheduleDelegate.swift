//
//  ScheduleDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/17.
//

import Foundation

protocol ScheduleDelegate {
    func scheduleValueAdded(itemSchedule: Item?)
    func scheduleValueSaved(itemSchedule: Item?)
}
