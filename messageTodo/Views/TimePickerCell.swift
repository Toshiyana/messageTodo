//
//  TimePickerCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit

class TimePickerCell: UITableViewCell {

    @IBOutlet weak var timeOptionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
