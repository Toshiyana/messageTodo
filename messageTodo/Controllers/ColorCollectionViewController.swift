//
//  ColorCollectionViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/17.
//

import UIKit
import ChameleonFramework

class ColorCollectionViewController: UICollectionViewController {

    let defaults = UserDefaults.standard
    
    private let colors: [UIColor] = [FlatBlue(), FlatRed(), FlatOrange(), FlatYellow(), FlatSand(), FlatNavyBlue(), FlatBlack(), FlatMagenta(), FlatTeal(), FlatSkyBlue(), FlatGreen(), FlatMint(), FlatWhite(), FlatGray(), FlatForestGreen(), FlatPurple(), FlatBrown(), FlatPlum(), FlatWatermelon(), FlatLime(), FlatPink(), FlatMaroon(), FlatCoffee(), FlatPowderBlue()]
    
    private let colorNames: [String] = ["Blue", "Red", "Orange", "Yellow", "Sand", "NavyBlue", "Black", "Magenta", "Teal", "SkyBlue", "Green", "Mint", "White", "Gray", "ForestGreen", "Purple", "Brown", "Plum", "Watermelon", "Lime", "Pink", "Maroon", "Coffee", "PowderBlue"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        
        navBar.barTintColor = defaults.getColorForKey(key: K.navbarColor) ?? FlatBlue()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.colorCollectionCellIdentifier, for: indexPath) as! ColorCollectionViewCell
        
        cell.colorButton.backgroundColor = colors[indexPath.row]
        cell.colorName.text = colorNames[indexPath.row]
        
        // make the border with selected color button
        if cell.colorButton.backgroundColor == defaults.getColorForKey(key: "NavBarColor") {
            cell.colorButton.layer.borderWidth = 3.0
        } else {
            cell.colorButton.layer.borderWidth = 0.0
        }
        
        return cell
    }
   
    // MARK: Save Color Method
    private func saveNavColor(color: UIColor) {
        defaults.saveColor(color: color, key: K.navbarColor)
    }

    @IBAction func colorButtonPressed(_ sender: UIButton) {
        let selectedColor = sender.backgroundColor
        defaults.saveColor(color: selectedColor, key: K.navbarColor)
        
        // NavBarを選択した色に更新するためには、.barTintColorに再度アクセスする必要あり
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        
        navBar.barTintColor = defaults.getColorForKey(key: K.navbarColor) ?? FlatBlue()

        // reload the border with selected color button
        collectionView.reloadData()
    }
    

}
