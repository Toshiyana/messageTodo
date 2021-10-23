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
        navBar.barTintColor = color
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)//change Button's color on navBar
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(color, returnFlat: true)]// change title's color on navbar
    }
}
