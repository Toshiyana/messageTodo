//
//  MessageListViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/11.
//

import UIKit
import RealmSwift
import SwipeCellKit

final class MessageListViewController: SwipeTableViewController {
    private var addButton: FloatingButton!
    @IBOutlet private weak var sortButton: UIBarButtonItem!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var bannerAdView: BannerAdView!

    private var messages: Results<Message>?
    private var showEditPopup = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "心に残る言葉"
        loadMessages()
        addButton = FloatingButton(attachedToView: self.view)
        addButton.floatButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)

        tableView.register(UINib(nibName: K.messageImageCellIdentifier, bundle: nil), forCellReuseIdentifier: K.messageImageCellIdentifier)
        tableView.separatorStyle = .none

        bannerAdView = BannerAdView(attachedToView: view)
        bannerAdView.bannerView.rootViewController = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 設定画面で全データを削除してこの画面に戻ってきた時、リストを更新するためにリロード
        tableView.reloadData()

        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }

        // change color
        let themeColor = DefaultsManager.shared.getColor() ?? ColorUtility.defaultColor
        ColorUtility.changeNabBarColor(navBar: navBar, color: themeColor)
        addButton.floatButton.layer.backgroundColor = themeColor.cgColor
        searchBar.tintColor = themeColor
        searchBar.barTintColor = themeColor
        searchBar.searchTextField.backgroundColor = UIColor.white

        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 150
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.messageImageCellIdentifier, for: indexPath) as! ImageMessageCell
        cell.delegate = self

        if let message = messages?[indexPath.row] {
            cell.configure(
                image: UIImage(data: message.imageData!), // !は良くない?
                message: message.content,
                name: message.name
            )
        }

        return cell
    }

    // MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEditPopup = true
        performSegue(withIdentifier: K.messageListTomessagePopup, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.messageListTomessagePopup {
            let popup = segue.destination as! MessagePopupViewController
            popup.delegate = self
            popup.titleColor = DefaultsManager.shared.getColor() ?? ColorUtility.defaultColor

            if showEditPopup {
                if let indexPath = tableView.indexPathForSelectedRow,
                   let message = messages?[indexPath.row] {
                    popup.showEditPopup = showEditPopup
                    popup.name = message.name
                    popup.content = message.content
                    popup.imgData = message.imageData
                    // default画像を設定しているので、編集時点でmessage.imageDataには必ず画像dataが入っている（default画像を入れていることを前提にしているので再利用性はあんまり良くない?）
                }
            }
        }
    }

    // MARK: - Load Data Method
    private func loadMessages() {
        // アプリ起動時のcellの並び順を、以前sortで並べ替えた順番にする
        let messageOrder: String? = DefaultsManager.shared.getMessageOrder()
        messages = MessageManager.shared.loadMessages(in: messageOrder)
        tableView.reloadData()
    }

    // MARK: - Save Data Method
    private func save(message: Message) {
        MessageManager.shared.save(message: message)
        tableView.reloadData()
    }

    // MARK: - Delete Data Method
    override func updateModel(at indexPath: IndexPath) {
        if let message = messages?[indexPath.row] {
            MessageManager.shared.delete(message: message)
        }
    }

    // MARK: - Add New Messages
    @objc private func addButtonPressed(_ sender: FloatingButton) {
        showEditPopup = false
        performSegue(withIdentifier: K.messageListTomessagePopup, sender: self)
    }

    // MARK: - SortButton Method
    @IBAction private func sortButtonPressed(_ sender: UIBarButtonItem) {
        guard let messages = messages else { return }

        if !messages.isEmpty {
            let sheet = UIAlertController(title: "言葉の並び替え", message: "", preferredStyle: .alert)
            let dateSortAction = UIAlertAction(title: "作成日順", style: .default) { [weak self] _ in
                self?.messages = MessageManager.shared.sort(by: "dateCreated")
                DefaultsManager.shared.saveMessageOrder(of: K.MessageOrderMethod.dateOrder)
                self?.tableView.reloadData()
            }
            let contentSortAction = UIAlertAction(title: "言葉の内容順", style: .default) { [weak self] _ in
                self?.messages = MessageManager.shared.sort(by: "content")
                DefaultsManager.shared.saveMessageOrder(of: K.MessageOrderMethod.titleOrder)
                self?.tableView.reloadData()
            }
            let nameSortAction = UIAlertAction(title: "発言者順", style: .default) { [weak self] _ in
                self?.messages = MessageManager.shared.sort(by: "name")
                DefaultsManager.shared.saveMessageOrder(of: K.MessageOrderMethod.nameOrder)
                self?.tableView.reloadData()
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
        if searchText.isEmpty {
            loadMessages()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension MessageListViewController: MessagePopupDelegate {
    func popupValueAdded(name: String, content: String, imageData: Data?) {
        let newMessage = Message()
        newMessage.name = name
        newMessage.content = content
        newMessage.dateCreated = Date()
        newMessage.imageData = imageData
        save(message: newMessage)
    }

    func popupValueEdited(name: String, content: String, imageData: Data?) {
        if let indexPath = tableView.indexPathForSelectedRow,
           let message = messages?[indexPath.row] {
            MessageManager.shared.edit(message: message, name: name, content: content, imageData: imageData)
            tableView.reloadData()
        }
    }
}
