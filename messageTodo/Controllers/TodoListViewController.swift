//
//  TodoListViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import UIKit
import SwipeCellKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    private var addButton: FloatingButton!
    @IBOutlet weak var editButton: UIBarButtonItem!//SwipeTableViewControllerを継承している場合、cell.delegate = selfをやらないと、storyboardから設定できない

    let defaults = UserDefaults.standard
    var todoItems: Results<Item>?
    var showEditItem = false
    
    var themeColor: UIColor?
    
    override func viewDidLoad() {
        // 画面初期表示の時にのみ呼び出し
        super.viewDidLoad()
        
        tableView.register(CheckmarkCell.nib(), forCellReuseIdentifier: CheckmarkCell.identifier)
        
        title = "Todo"
//        tableView.rowHeight = 50
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
//        let themeColor = defaults.getColorForKey(key: K.navbarColor) ?? FlatOrange()
        themeColor = defaults.getColorForKey(key: K.navbarColor) ?? ColorUtility.defaultColor
        ColorUtility.changeNabBarColor(navBar: navBar, color: themeColor!)
        addButton.floatButton.layer.backgroundColor = themeColor!.cgColor

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckmarkCell.identifier, for: indexPath) as! CheckmarkCell
        cell.delegate = self
                
        if let item = todoItems?[indexPath.row] {
            
            cell.configure(
                text: item.title,
                isDone: item.isDone,
                buttonColor: themeColor!,
                buttonTag: indexPath.row) // tagをつけて、どのcellのbuttonが押されたかを識別
            
            cell.checkButton.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - Load Data Method
    func loadItems() {
        todoItems = ItemManager.shared.loadItems()
        tableView.reloadData()
    }
    
    //MARK: - Save Data Method
    private func save(item: Item) {
        ItemManager.shared.save(item: item)
        tableView.reloadData()
    }
        
    //MARK: - Delete Data Method
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            // item削除前に、設定された通知も削除
            LocalNotificationManager.shared.removeScheduledNotification(item: item)
            ItemManager.shared.delete(item: item)
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
    
    //MARK: - CheckButton Method
    @objc func checkButtonPressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.tintColor = .lightGray

        } else {
            sender.isSelected = true
            sender.tintColor = themeColor
        }
        
        if let item = todoItems?[sender.tag] {
            ItemManager.shared.check(item: item)
        }
    }
    
    //MARK: - Editing Cell Method in Realm
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // move cell in Editing mode
        ItemManager.shared.sort(todoItems: todoItems,
                                sourceIndexPath: sourceIndexPath,
                                destinationIndexPath: destinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // remove "delete button" in editing
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        // remove "delete button's indent sapace" in editing
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
        
        // didSelectRowAtで、tableView.deselectRow()を実行すると、tableView.indexPathForSelectedRowがnilになるので注意
        if let indexPath = tableView.indexPathForSelectedRow,
           let item = todoItems?[indexPath.row] {
            ItemManager.shared.edit(item: item,
                                    title: title, memo: memo, reminderEnabled: reminderEnabled, wordEnabled: wordEnabled, wordBody: wordBody,
                                    timeInterval: timeInterval, date: date, repeats: repeats, reminderType: reminderType)
            tableView.reloadData()

            // 通知内容の更新
            LocalNotificationManager.shared.removeScheduledNotification(item: item)
            LocalNotificationManager.shared.scheduleNotification(item: item)
        }
    }
}
