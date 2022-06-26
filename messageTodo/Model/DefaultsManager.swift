//
//  DefaultsManager.swift
//  messageTodo
//
//  Created by Toshiyana on 2022/06/26.
//

import Foundation
import UIKit

final class DefaultsManager {
    // MARK: - Singleton Implementation
    static let shared = DefaultsManager()

    let defaults = UserDefaults.standard

    func getColor() -> UIColor? {
        defaults.getColorForKey(key: K.navbarColor)
    }

    func saveColor(color: UIColor?) {
        defaults.saveColor(color: color, key: K.navbarColor)
    }
}
