//
//  ImageMessageCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/25.
//

import UIKit
import SwipeCellKit

final class ImageMessageCell: SwipeTableViewCell {
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet private weak var messageImgView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        messageView.layer.cornerRadius = messageView.frame.height / 4
        messageView.layer.shadowColor = UIColor.black.cgColor
        messageView.layer.shadowOpacity = 1
        messageView.layer.shadowRadius = 4
        messageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        messageImgView.layer.cornerRadius = messageImgView.frame.height / 2
    }

    func configure(image: UIImage?, message: String, name: String) {
        messageImgView.image = image
        messageLabel.text = message
        nameLabel.text = name
    }
}
