//
//  MessageListViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class MessageListViewController: SwipeTableViewController {

    private var addButton: FloatingButton!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    var messages: Results<Message>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "思い出の言葉"
        loadMessages()
        addButton = FloatingButton(attachedToView: self.view)
        addButton.floatButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        
        tableView.register(UINib(nibName: K.messageCellIdentifier, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        searchBar.tintColor = themeColor
        searchBar.barTintColor = themeColor
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.messageCellIdentifier, for: indexPath) as! MessageCell
        
        cell.delegate = self
        
        if let message = messages?[indexPath.row] {
            cell.messageLabel.text = message.content
            cell.nameLabel.text = message.name
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.messageListTomessagePopup, sender: self)
//        if let message = messages?[indexPath.row] {
//            var contentField = UITextField()
//            var nameField = UITextField()
//
//            let alert = UIAlertController(title: "言葉の編集", message: "", preferredStyle: .alert)
//
//            let editAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                do {
//                    try self.realm.write {
//                        message.content = contentField.text!
//                        message.name = nameField.text!
//                        message.dateCreated = Date()
//                    }
//                } catch {
//                    print("Error updating message. \(error)")
//                }
//                tableView.reloadData()
//            }
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//            alert.addAction(editAction)
//            alert.addAction(cancelAction)
//
//            alert.addTextField { (field) in
//                field.text = message.content
//                field.placeholder = "言葉"
//                contentField = field
//            }
//            alert.addTextField { (field) in
//                field.text = message.name
//                field.placeholder = "発言者"
//                nameField = field
//            }
//            present(alert, animated: true, completion: nil)
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
    
    //MARK: - Load Data Method
    private func loadMessages() {
        // アプリ起動時のcellの並び順を、以前sortで並べ替えた順番にする
        if let messageOrder = defaults.string(forKey: K.messagesOrder) {
            switch messageOrder {
            case "DateOrder":
                messages = realm.objects(Message.self).sorted(byKeyPath: "dateCreated", ascending: true)
            case "TitleOrder":
                messages = realm.objects(Message.self).sorted(byKeyPath: "content", ascending: true)
            case "NameOrder":
                messages = realm.objects(Message.self).sorted(byKeyPath: "name", ascending: true)
            default:
                messages = realm.objects(Message.self)//defaultは実行されることがない
            }
        } else {
            messages = realm.objects(Message.self).sorted(byKeyPath: "name", ascending: true)
        }
        tableView.reloadData()
    }
        
    //MARK: - Save Data Method
    private func save(message: Message) {
        do {
            try realm.write {
                realm.add(message)
            }
        } catch {
            print("Error saving message. \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete Data Method
    override func updateModel(at indexPath: IndexPath) {
        if let message = messages?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(message)
                }
            } catch {
                print("Error deleting the message, \(error)")
            }
        }
    }

    //MARK: - Add New Messages
    @objc private func addButtonPressed(_ sender: FloatingButton) {
        
        var contentField = UITextField()
        var nameField = UITextField()
        
        let alert = UIAlertController(title: "言葉の追加", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "追加", style: .default) { (action) in

            let newMessage = Message()
            newMessage.content = contentField.text!
            newMessage.name = nameField.text!
            newMessage.dateCreated = Date()
            
            self.save(message: newMessage)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        alert.addTextField { (field) in
            field.placeholder = "言葉"
            contentField = field
        }
        
        alert.addTextField { (field) in
            field.placeholder = "発言者"
            nameField = field
        }
        
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - SortButton Method
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
        if messages?.count != 0 {
            let sheet = UIAlertController(title: "Sort Messages", message: "", preferredStyle: .alert)
            let dateSortAction = UIAlertAction(title: "Date Order", style: .default) { (action) in
                self.messages = self.realm.objects(Message.self).sorted(byKeyPath: "dateCreated", ascending: true)
                self.defaults.set("DateOrder", forKey: K.messagesOrder)
                self.tableView.reloadData()
            }
            let contentSortAction = UIAlertAction(title: "Title Order", style: .default) { (action) in
                self.messages = self.realm.objects(Message.self).sorted(byKeyPath: "content", ascending: true)
                self.defaults.set("TitleOrder", forKey: K.messagesOrder)
                self.tableView.reloadData()
            }
            let nameSortAction = UIAlertAction(title: "Name Order", style: .default) { (action) in
                self.messages = self.realm.objects(Message.self).sorted(byKeyPath: "name", ascending: true)
                self.defaults.set("NameOrder", forKey: K.messagesOrder)
                self.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            sheet.addAction(dateSortAction)
            sheet.addAction(contentSortAction)
            sheet.addAction(nameSortAction)
            sheet.addAction(cancelAction)

            present(sheet, animated: false, completion: nil)
        }
    }
}

extension MessageListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        messages = messages?.filter("(content CONTAINS[cd] %@) || (name CONTAINS[cd] %@)", searchBar.text!, searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    // 検索バーのテキスト入力がない時にセルの内容を表示
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadMessages()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
