//
//  SwitchCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit

class SwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        titleLabel.isHidden = true
//        repeatSwitch.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
