//
//  SwipeTableViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - SwipeCell Delegate Method
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }//swipeの始まりが右の場合
        
        let deleteAction = SwipeAction(style: .destructive, title: "削除") { [weak self] (action, indexPath) in
            // handle action by updating model with deletion
            self?.updateModel(at: indexPath) // 継承先でoverrideしたものが呼び出される
        }
        return [deleteAction]
    }
    
    //MARK: - SwipeCell Method About Action
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    //MARK: - Delete Data by Swipe
    func updateModel(at indexPath: IndexPath) {
        // update data model.
    }
    

}
