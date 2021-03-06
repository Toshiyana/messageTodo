//
//  TextFieldCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/19.
//

import UIKit

final class TextFieldCell: UITableViewCell {
    static let identifier = "TextFieldCell"

    @IBOutlet weak var field: UITextField!

    static func nib() -> UINib {
        return UINib(nibName: "TextFieldCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        field.delegate = self
        field.placeholder = "タイトルを入力してください"
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 5
    }

    func configure(text: String) {
        field.text = text
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        return true
    }
}
