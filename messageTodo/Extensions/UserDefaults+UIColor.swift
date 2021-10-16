//
//  UserDefaults+UIColor.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/16.
//

import UIKit

extension UserDefaults {
    
    // save theme color selected in ColorSettingView.
    // To save UIColor with UserDefautls, UIColor must be changed to NSData.
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
