//
//  TodoListViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    private var addButton: FloatingButton!
    @IBOutlet weak var editButton: UIBarButtonItem!//SwipeTableViewControllerを継承している場合、cell.delegate = selfをやらないと、storyboardから設定できない

    let defaults = UserDefaults.standard
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    override func viewDidLoad() {
        // 画面初期表示の時にのみ呼び出し
        super.viewDidLoad()
        
        loadItems()
        addButton = FloatingButton(attachedToView: view)
        addButton.floatButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 画面初期表示の時と遷移先画面から戻ってきた時に実行
        super.viewWillAppear(animated)
        
        // 設定画面で全データを削除してこの画面に戻ってきた時、リストを更新するためにリロード
        tableView.reloadData()
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        navBar.barTintColor = defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()
        addButton.floatButton.layer.backgroundColor = (defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()).cgColor
        
        tabBarController?.tabBar.isHidden = false
    }

    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // todoItems?.countは、一番最初はnil。一度itemを追加して、itemを全て消すと、Optionals(0)になってしまうので、No Item Addedとはならない。
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.todoCellIdentifier, for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
                
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
        } else {
            cell.textLabel?.text = "No Items Added."
        }
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        // タップしたセルの内容を編集
        if let item = todoItems?[indexPath.row] {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Edit Todo Item", message: "", preferredStyle: .alert)
            
            let editAction = UIAlertAction(title: "Edit Item", style: .default) { (action) in
                do {
                    try self.realm.write {
                        item.title = textField.text!
                    }
                } catch {
                    print("Error updating item. \(error)")
                }
                tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(editAction)
            alert.addAction(cancelAction)
            
            alert.addTextField { (field) in
                field.placeholder = "Edit item"
                field.text = item.title
                textField = field
            }
            
            present(alert, animated: true, completion: nil)
        }

        // セルが選択状態のままになるのを防ぐ
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: - Load Data Method
    func loadItems() {
        todoItems = realm.objects(Item.self).sorted(byKeyPath: "orderOfItem")
        tableView.reloadData()
    }
    
    //MARK: - Save Data Method
    private func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving item. \(error)")
        }
        
        tableView.reloadData()
    }
        
    //MARK: - Delete Data Method
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting the item, \(error)")
            }
        }
    }
    
    //MARK: - Add New Items
    @objc private func addButtonPressed(_ sender: FloatingButton) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            
            self.save(item: newItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (field) in
            field.placeholder = "Create new item"
            textField = field
        }
                
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - EditButton Method
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.isEditing = false
            editButton.title = "Edit"
            addButton.floatButton.isHidden = false
        } else {
            tableView.isEditing = true
            editButton.title = "Done"
            addButton.floatButton.isHidden = true
        }
    }
    
    //MARK: - Editing Cell Method in Realm
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // move cell in Editing mode
        do {
            try realm.write {
                let sourceItem = todoItems?[sourceIndexPath.row]
                let destinationItem = todoItems?[destinationIndexPath.row]
                
                let destinationItemOrder = destinationItem?.orderOfItem
                
                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in sourceIndexPath.row ... destinationIndexPath.row {
                        todoItems?[index].orderOfItem -= 1
                    }
                } else {
                    for index in (destinationIndexPath.row ..< sourceIndexPath.row).reversed() {
                        todoItems?[index].orderOfItem += 1
                    }
                }
                
                guard let destOrder = destinationItemOrder else {
                    fatalError("destinationItemOrder does not exist.")
                }
                sourceItem?.orderOfItem = destOrder
            }
        } catch {
            print("Error moving the cell. \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // delete cell in Editing mode
        if editingStyle == .delete {
            updateModel(at: indexPath)
            loadItems()
        }
    }
    
    // テーブルビューが編集モードのときに、指定した行の背景をインデントするかどうかをdelegateに尋ねるメソッド
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
