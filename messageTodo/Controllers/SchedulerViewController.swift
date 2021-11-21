//
//  SchedulerViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/19.
//

import UIKit
import RealmSwift

class SchedulerViewController: UIViewController {

    @IBOutlet weak var reminderTable: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    let realm = try! Realm()
    var item: Item?
    var showEditItem: Bool = false
    
    var reminderEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reminderTable.delegate = self
        reminderTable.dataSource = self
        
//        reminderEnabled = item?.reminderEnabled ?? false
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print(item)
        do {
            try realm.write {
                item?.reminderEnabled = reminderEnabled
            }
        } catch {
            print("Error editing item. \(error)")
        }
        
//        if item == nil {
//            let newItem = Item()
//            newItem.reminderEnabled = reminderEnabled
//
//            do {
//                try realm.write {
//                    realm.add(newItem)
//                }
//            } catch {
//                print("Error saving item. \(error)")
//            }
//
//
//        }
//        else {
//            do {
//                try realm.write {
//                    item?.reminderEnabled = reminderEnabled
//                }
//            } catch {
//                print("Error editing item. \(error)")
//            }
//        }
        
        dismiss(animated: true, completion: nil)
    }
    

}

extension SchedulerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            switchCell.textLabel?.text = "リマインダーを送る"
            
            let reminderSwitch = UISwitch()
            reminderSwitch.addTarget(self, action: #selector(didChangedReminderSwitch(_:)), for: .valueChanged)
//            print(item)
            reminderSwitch.isOn = item?.reminderEnabled ?? false
//            reminderSwitch.isOn = reminderEnabled
            switchCell.accessoryView = reminderSwitch
            
            return switchCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 150
        return UITableView.automaticDimension
    }
        
    @objc func didChangedReminderSwitch(_ sender: UISwitch) {
        reminderEnabled = sender.isOn
        
        if sender.isOn {
            print("Reminder Switch on")
        } else {
            print("Reminder Switch off")
        }
    }
    
}
