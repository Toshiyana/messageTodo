//
//  TimeSettingCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/20.
//

import UIKit

class TimeSettingCell: UITableViewCell {

    static let identifier = "TimeSettingCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TimeSettingCell", bundle: nil)
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(timeText: String) {
        timeLabel.text = timeText
    }
    
}
