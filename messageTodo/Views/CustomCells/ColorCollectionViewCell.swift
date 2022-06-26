//
//  ColorCollectionViewCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/18.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var colorButton: UIButton!
    @IBOutlet weak var colorName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        colorButton.layer.cornerRadius = colorButton.frame.width / 2
        colorButton.layer.masksToBounds = true
        // colorButton.layer.borderWidth = 3.0

        //        contentView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        NSLayoutConstraint.activate([
        //                   contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
        //                   contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        //                   contentView.topAnchor.constraint(equalTo: topAnchor),
        //                   contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        //               ])
    }

    func configure(color: UIColor, name: String?) {
        colorButton.backgroundColor = color
        colorName.text = name ?? ""

        if colorButton.backgroundColor == DefaultsManager.shared.getColor() {
            colorButton.layer.borderWidth = 3.0
        } else {
            colorButton.layer.borderWidth = 0.0
        }
    }
}
