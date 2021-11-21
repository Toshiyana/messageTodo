//
//  TextViewCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/19.
//

import UIKit

class TextViewCell: UITableViewCell {
    
    static let identifier = "TextViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TextViewCell", bundle: nil)
    }

    @IBOutlet weak var textViewInCell: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
