//
//  ColorCollectionViewCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/18.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var colorName: UILabel!
    
    override func awakeFromNib() {
        colorButton.layer.cornerRadius = colorButton.frame.width / 2
        colorButton.layer.masksToBounds = true
        //colorButton.layer.borderWidth = 3.0
        
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//                   contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//                   contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
//                   contentView.topAnchor.constraint(equalTo: topAnchor),
//                   contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
//               ])
    }
    
    
}
