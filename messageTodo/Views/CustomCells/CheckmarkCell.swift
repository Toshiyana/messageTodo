//
//  CheckmarkCell.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/25.
//

import UIKit
import SwipeCellKit

class CheckmarkCell: SwipeTableViewCell {
    static let identifier = "CheckmarkCell"

    static func nib() -> UINib {
        return UINib(nibName: "CheckmarkCell", bundle: nil)
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        // 選択のアニメーションにおいて、 TodoListViewControllerのdidSelectRowAtでtableView.deselectRow()を実行すると、itemValueEdited()でtableView.indexPathForSelectedRowにアクセスできなくなる。なので、選択のアニメーションそのものを除去。
        selectionStyle = .none

        // change SF symbol size (pointSize: buttonの半径)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "checkmark.circle.fill", withConfiguration: largeConfig)
        checkButton.setImage(largeBoldDoc, for: .normal)
    }

    func configure(text: String, isDone: Bool, buttonColor: UIColor, buttonTag: Int) {
        label.text = text
        checkButton.isSelected = isDone
        checkButton.tintColor = checkButton.isSelected ? buttonColor : UIColor.lightGray
        checkButton.tag = buttonTag // tagをつけて、どのcellのbuttonが押されたかを識別
    }
}
