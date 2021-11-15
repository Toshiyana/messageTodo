//
//  SettingViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/16.
//

import UIKit
import StoreKit
import ChameleonFramework
import RealmSwift

//MARK: - Section Type
struct Section {
    let title: String
    let options: [SettingOptionType]
}

//MARK: - Setting Option Type
enum SettingOptionType {
    case staticCell(model: SettingStaticOption)
    case iconCell(model: SettingIconOption)
    case colorCell(model: SettingColorOption)
    case versionCell(model: SettingVersionOption)
}

struct SettingStaticOption {
    let title: String
    let handler: (() -> Void)
}

struct SettingIconOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> Void)
}

struct SettingColorOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> Void)
}

struct SettingVersionOption {
    let title: String
    let icon: UIImage?
    let detailText: String
}

class SettingViewController: UITableViewController {

    let defaults = UserDefaults.standard
    let realm = try! Realm()
    
    private var models = [Section]()
    
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        title = "設定画面"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Setting.staticCellIdentifier)
        tableView.register(SettingIconCell.self, forCellReuseIdentifier: K.Setting.iconCellIdentifier)
        tableView.register(SettingColorCell.self, forCellReuseIdentifier: K.Setting.colorCellIdentifier)
        tableView.register(SettingVersionCell.self, forCellReuseIdentifier: K.Setting.versionCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        let themeColor = defaults.getColorForKey(key: K.navbarColor) ?? FlatBlue()
        ChameleonUtility.changeNabBarColor(navBar: navBar, color: themeColor)

        tableView.reloadData()
        
        tabBarController?.tabBar.isHidden = true
    }

    private func configure() {
        models.append(Section(title: "ユーザー設定", options: [
            .iconCell(model: SettingIconOption(
                        title: "通知設定",
                        icon: UIImage(systemName: "clock"))
                        {
//                            self.performSegue(withIdentifier: K.settingToScheduler, sender: self)
                            
                            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings)
                            }
                        }),
            .colorCell(model: SettingColorOption(
                        title: "テーマカラーの変更",
                        icon: UIImage(systemName: "paintpalette"))
                        {
                            self.performSegue(withIdentifier: K.settingToColorSegue, sender: self)
                        }),
        ]))
        
        models.append(Section(title: "アプリについて", options: [
            .iconCell(model: SettingIconOption(
                        title: "アプリの使い方",
                        icon: UIImage(systemName: "text.book.closed"))
                        {
                            //
                        }),
            .iconCell(model: SettingIconOption(
                        title: "不具合を報告",
                        icon: UIImage(systemName: "exclamationmark.triangle"))
                        {
                            //
                        }),
            .iconCell(model: SettingIconOption(
                        title: "アプリを評価",
                        icon: UIImage(systemName: "star"))
                        {
                            guard let scene = self.view.window?.windowScene else {
                                print("No scene")
                                return
                            }
                            SKStoreReviewController.requestReview(in: scene)
                        }),
        ]))
        
        models.append(Section(title: "その他", options: [
            .iconCell(model: SettingIconOption(
                        title: "データの削除",
                        icon: UIImage(systemName: "trash"))
                        {
                self.deleteDataAction()
                        }),
            
            .versionCell(model: SettingVersionOption(
                            title: "バージョン",
                            icon: UIImage(systemName: "info.circle"),
                            detailText: version))
        ]))
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return models.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models[section].options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticCell(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.staticCellIdentifier,
                for: indexPath)
            cell.textLabel?.text = model.title
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .iconCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.iconCellIdentifier,
                for: indexPath
            ) as? SettingIconCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        
        case .colorCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.colorCellIdentifier,
                for: indexPath
            ) as? SettingColorCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell

        case .versionCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.versionCellIdentifier,
                for: indexPath
            ) as? SettingVersionCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // action when call was tapped
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .iconCell(let model):
            model.handler()
        case .colorCell(let model):
            model.handler()
        default: // case .versionCell
            return
        }
    }
    
    //MARK: - Delete All Data Method
    private func deleteDataAction() {
        let allItems = self.realm.objects(Item.self)
        let allMessages = self.realm.objects(Message.self)
        
        let alert = UIAlertController(title: "Delet data", message: "", preferredStyle: .alert)
        
        let deleteItemAction = UIAlertAction(title: "Delete All Items", style: .default) { (action) in
            do {
                try self.realm.write {
                    self.realm.delete(allItems)
                }
            } catch {
                print("Error deleting All item, \(error)")
            }
        }
        let deleteMessageAction = UIAlertAction(title: "Delete All Messages", style: .default) { (action) in
            do {
                try self.realm.write {
                    self.realm.delete(allMessages)
                }
            } catch {
                print("Error deleting All Messages, \(error)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteItemAction)
        alert.addAction(deleteMessageAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
}
