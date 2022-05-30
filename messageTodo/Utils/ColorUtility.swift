//
//  ColorUtility.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/12/08.
//

import Foundation
import UIKit

struct ColorUtility {
        
    static let colors: [UIColor] = [
        UIColor(red: 1.00, green: 0.76, blue: 0.07, alpha: 1.00),
        UIColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.00),
        UIColor(red: 0.93, green: 0.35, blue: 0.14, alpha: 1.00),
        UIColor(red: 0.92, green: 0.13, blue: 0.15, alpha: 1.00),
        
        UIColor(red: 0.77, green: 0.90, blue: 0.22, alpha: 1.00),
        UIColor(red: 0.64, green: 0.80, blue: 0.22, alpha: 1.00),
        UIColor(red: 0.00, green: 0.58, blue: 0.20, alpha: 1.00),
        UIColor(red: 0.00, green: 0.38, blue: 0.40, alpha: 1.00),
        
        UIColor(red: 0.07, green: 0.80, blue: 0.77, alpha: 1.00),
        UIColor(red: 0.07, green: 0.54, blue: 0.65, alpha: 1.00),
        UIColor(red: 0.02, green: 0.32, blue: 0.87, alpha: 1.00),
        UIColor(red: 0.11, green: 0.08, blue: 0.39, alpha: 1.00),
        
        UIColor(red: 0.99, green: 0.65, blue: 0.87, alpha: 1.00),
        UIColor(red: 0.85, green: 0.50, blue: 0.98, alpha: 1.00),
        UIColor(red: 0.60, green: 0.50, blue: 0.98, alpha: 1.00),
        UIColor(red: 0.34, green: 0.35, blue: 0.73, alpha: 1.00),
        
        UIColor(red: 0.93, green: 0.30, blue: 0.40, alpha: 1.00),
        UIColor(red: 0.71, green: 0.20, blue: 0.44, alpha: 1.00),
        UIColor(red: 0.51, green: 0.20, blue: 0.44, alpha: 1.00),
        UIColor(red: 0.44, green: 0.12, blue: 0.32, alpha: 1.00),
        
        UIColor(red: 0.87, green: 0.90, blue: 0.91, alpha: 1.00),
        UIColor(red: 0.70, green: 0.75, blue: 0.76, alpha: 1.00),
        UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00),
        UIColor(red: 0.18, green: 0.20, blue: 0.21, alpha: 1.00)
    ]

    static let defaultColor: UIColor = colors[1]
    
    static func changeNabBarColor(navBar: UINavigationBar, color: UIColor) {
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        } else {
            navBar.barTintColor = color
            navBar.isTranslucent = false
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]// change title's color on navbar
        }
                
        navBar.tintColor = UIColor.white//change Button's color on navBar
    }
}

