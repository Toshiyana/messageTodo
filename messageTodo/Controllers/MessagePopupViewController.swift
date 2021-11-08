//
//  MessagePopupViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/04.
//

import UIKit
import ChameleonFramework

class MessagePopupViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    var showEditPopup: Bool = false
    var titleColor: UIColor?
    var name: String?
    var content: String?
    
    var delegate: MessagePopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        popupView.layer.cornerRadius = 15
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.masksToBounds = true
        
        titleLabel.backgroundColor = titleColor
        titleLabel.textColor = ContrastColorOf(titleColor!, returnFlat: true)

        if showEditPopup {
            titleLabel.text = "言葉の編集"
            nameTextField.text = name
            contentTextField.text = content
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let name = nameTextField.text!
        let content = contentTextField.text!
        
        if showEditPopup {
            delegate?.popupValueEdited(name: name, content: content)
        } else {
            delegate?.popupValueAdded(name: name, content: content)
        }
        
        dismiss(animated: false)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
}
