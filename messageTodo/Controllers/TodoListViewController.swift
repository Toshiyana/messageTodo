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
    var showEditItem = false
    
    override func viewDidLoad() {
        // 画面初期表示の時にのみ呼び出し
        super.viewDidLoad()
        
        title = "タスク"
        tableView.rowHeight = 50
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

        // change color
        let themeColor = defaults.getColorForKey(key: K.navbarColor) ?? FlatBlue()
        ChameleonUtility.changeNabBarColor(navBar: navBar, color: themeColor)
        addButton.floatButton.layer.backgroundColor = themeColor.cgColor

        guard let tabBar = tabBarController?.tabBar else {
            fatalError("NavigationController does not exist.")
        }
        TabBarUtility.Set(tabBar: tabBar) // for iOS15
        
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
            cell.textLabel?.text = "タスクが追加されていません"
        }
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        // タップしたセルの内容を編集
        showEditItem = true
        performSegue(withIdentifier: K.itemListToItemContent, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.itemListToItemContent {
            let vc = segue.destination as! ItemContentViewController
            vc.delegate = self

            if showEditItem {
                if let indexPath = tableView.indexPathForSelectedRow,
                   let item = todoItems?[indexPath.row] {

                    vc.showEditItem = showEditItem
                    vc.itemTitle = item.title
                    vc.itemMemo = item.memo
                    vc.reminderEnabled = item.reminderEnabled
                    
                    vc.wordEnabled = item.reminder?.wordEnabled ?? false
                    vc.wordBody = item.reminder?.wordBody ?? ""
                    vc.timeInterval = item.reminder?.timeInterval ?? 0
                    vc.date = item.reminder?.date
                    vc.repeats = item.reminder?.repeats ?? false
                    vc.reminderType = item.reminder?.reminderType ?? ReminderType.none.rawValue
                }
            }
        }
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
            
            // item削除前に、設定された通知も削除
            LocalNotificationManager.shared.removeScheduledNotification(item: item)
            
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
        showEditItem = false
        performSegue(withIdentifier: K.itemListToItemContent, sender: self)
        
    }
    
    //MARK: - EditButton Method
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {

        if tableView.isEditing {
            tableView.isEditing = false
            editButton.title = "並び替え"
            addButton.floatButton.isHidden = false
        } else {
            tableView.isEditing = true
            editButton.title = "完了"
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

extension TodoListViewController: ItemDelegate {
    func itemValueAdded(title: String, memo: String, reminderEnabled: Bool, wordEnabled: Bool, wordBody: String, timeInterval: TimeInterval, date: Date?, repeats: Bool, reminderType: String) {
        let newItem = Item()
        newItem.title = title
        newItem.memo = memo
        newItem.reminderEnabled = reminderEnabled
        
        newItem.reminder = Reminder()
        newItem.reminder?.wordEnabled = wordEnabled
        newItem.reminder?.wordBody = wordBody
        newItem.reminder?.timeInterval = timeInterval
        newItem.reminder?.date = date
        newItem.reminder?.repeats = repeats
        newItem.reminder?.reminderType = reminderType
        
        save(item: newItem)
        
        LocalNotificationManager.shared.scheduleNotification(item: newItem)
    }
    
    func itemValueEdited(title: String, memo: String, reminderEnabled: Bool, wordEnabled: Bool, wordBody: String, timeInterval: TimeInterval, date: Date?, repeats: Bool, reminderType: String) {
        if let indexPath = tableView.indexPathForSelectedRow,
           let item = todoItems?[indexPath.row] {

            do {
                try realm.write {
                    item.title = title
                    item.memo = memo
                    item.reminderEnabled = reminderEnabled
                    // About reminder
                    item.reminder?.wordEnabled = wordEnabled
                    item.reminder?.wordBody = wordBody
                    item.reminder?.timeInterval = timeInterval
                    item.reminder?.date = date
                    item.reminder?.repeats = repeats
                    item.reminder?.reminderType = reminderType

                }
            } catch {
                print("Error editing item. \(error)")
            }
            tableView.reloadData()

            // 通知内容の更新
            LocalNotificationManager.shared.removeScheduledNotification(item: item)
            LocalNotificationManager.shared.scheduleNotification(item: item)
        }
    }
}
