//
//  TabBarUtility.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit

struct TabBarUtility {
    static func set(tabBar: UITabBar) {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
