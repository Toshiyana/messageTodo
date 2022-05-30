//
//  SwitchCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/12/08.
//

import UIKit

class SwitchCell: UITableViewCell {
    
    static let identifier = "SwitchCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SwitchCell", bundle: nil)
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }
    
    func configure(text: String, isOn: Bool) {
        label.text = text
        mySwitch.isOn = isOn
    }
}
