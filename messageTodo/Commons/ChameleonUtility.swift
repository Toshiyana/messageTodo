//
//  ChameleonUtility.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/23.
//

import UIKit
import ChameleonFramework

struct ChameleonUtility {
    static func changeNabBarColor(navBar: UINavigationBar, color: UIColor) {
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(color, returnFlat: true)]
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        } else {
            navBar.barTintColor = color
            navBar.isTranslucent = false
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(color, returnFlat: true)]// change title's color on navbar
        }
                
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)//change Button's color on navBar
    }
}
