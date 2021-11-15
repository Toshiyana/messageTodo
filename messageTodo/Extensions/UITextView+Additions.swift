//
//  UITextView+Additions.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/15.
//

import UIKit

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1: Create a UIToolbar
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2: Create a UIBarButtonItem of type flexibleSpace
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3: Create UIBarButtonItem using parameter title, target and action
        toolBar.setItems([flexible, barButton], animated: false)//4: Assign this two UIBarButtonItem to toolBar
        self.inputAccessoryView = toolBar//5: Set this toolBar as inputAccessoryView to the UITextView
    }
}
