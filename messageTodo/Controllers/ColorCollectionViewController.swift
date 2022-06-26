//
//  ColorCollectionViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/17.
//

import UIKit

class ColorCollectionViewController: UICollectionViewController {
    private let colors: [UIColor] = ColorUtility.colors

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "テーマカラーの選択"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }

        let themeColor = DefaultsManager.shared.getColor() ?? ColorUtility.defaultColor
        ColorUtility.changeNabBarColor(navBar: navBar, color: themeColor)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.colorCollectionCellIdentifier, for: indexPath) as! ColorCollectionViewCell
        cell.configure(color: colors[indexPath.row], name: nil)
        return cell
    }

    // MARK: Save Color Method
    private func saveNavColor(color: UIColor) {
        DefaultsManager.shared.saveColor(color: color)
    }

    @IBAction private func colorButtonPressed(_ sender: UIButton) {
        let selectedColor = sender.backgroundColor
        DefaultsManager.shared.saveColor(color: selectedColor)

        // NavBarを選択した色に更新するためには、.barTintColorに再度アクセスする必要あり
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        let themeColor = DefaultsManager.shared.getColor() ?? ColorUtility.defaultColor
        ColorUtility.changeNabBarColor(navBar: navBar, color: themeColor)

        // reload the border with selected color button
        collectionView.reloadData()
    }
}
