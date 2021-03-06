//
//  UserDefaults+UIColor.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/16.
//

import UIKit

extension UserDefaults {
    // Save theme color selected in ColorSettingView.
    // UIColor must be changed to NSData for saving with UserDefautls.
    func saveColor(color: UIColor?, key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Error saving selected color as NSData with UserDefaults. \(error)")
            }
        }
        set(colorData, forKey: key)
    }

    // Get saved color with UserDefaults.
    // Saved color changes the type from NSData to UIColor.
    func getColorForKey(key: String) -> UIColor? {
        var colorReturned: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor { colorReturned = color }
            } catch {
                print("Error getting Color with UserDefaults. \(error)")
            }
        }
        return colorReturned
    }
}
