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
        
        nameTextField.delegate = self
        contentTextField.delegate = self
                
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

extension MessagePopupViewController: UITextFieldDelegate {
    
    // keyboardのreturnを押した時の処理を記述
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Returnを押した時にkeyboardを閉じる（Popup上の全てのtextFieldを対象）
        // 指定のtextFieldに対して行う場合は、IBOutletで命名した名前を利用（ex: nameTextField.endEditing(true)）
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true // keyboardを閉じる
        } else {
            textField.placeholder = "文字を入力してください"
            return false // keyboardを開いたまま
        }
    }
}
