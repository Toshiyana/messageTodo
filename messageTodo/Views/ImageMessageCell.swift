//
//  ImageMessageCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/25.
//

import UIKit
import SwipeCellKit

class ImageMessageCell: SwipeTableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImgView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        messageView.layer.cornerRadius = messageView.frame.height / 4
        messageImgView.layer.cornerRadius = messageImgView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
