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
    
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    var messages: Results<Message>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
        navBar.barTintColor = defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()
        addButton.floatButton.layer.backgroundColor = (defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()).cgColor
        
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
    
    //MARK: - Load Data Method
    private func loadMessages() {
        messages = realm.objects(Message.self).sorted(byKeyPath: "name", ascending: true)
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
        
        let alert = UIAlertController(title: "Add New Message", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in

            let newMessage = Message()
            newMessage.content = contentField.text!
            newMessage.name = nameField.text!
            newMessage.dateCreated = Date()
            
            self.save(message: newMessage)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        alert.addTextField { (field) in
            field.placeholder = "Add a new content"
            contentField = field
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Add a new name"
            nameField = field
        }
        
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - SortButton Method
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
    }
    

}
