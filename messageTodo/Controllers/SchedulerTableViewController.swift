//
//  SchedulerTableViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit
import RealmSwift

class SchedulerTableViewController: UITableViewController {

    //
    @IBOutlet weak var notificationSwitch: UISwitch!
    //
    @IBOutlet weak var wordSwitch: UISwitch!
    
    
    //
    @IBOutlet weak var timeOptionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    @IBOutlet weak var repeatSwitch: UISwitch!
       
    var delegate: ScheduleDelegate?
    
    let realm = try! Realm()
    var item: Item?
    var showEditItem: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = item {
            notificationSwitch.isOn = item.reminderEnabled
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.schedulerToTimeSetting {
//            let vc = segue.destination as! TimeSettingViewController
//            vc.delegate = self
//            
//            if showEditItem {
//                if let item = item {
//                    vc.showEditItem = showEditItem
//                    vc.item = item
//                }
//            }
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            if notificationSwitch.isOn {
                return 2
            }
            else {
                return 0
            }
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        tableView.reloadData()
    }
  
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {

        do {
            try realm.write {
                item?.reminderEnabled = notificationSwitch.isOn
//                item?.reminder = itemSchedule?.reminder
            }
        } catch {
            print("Error editing item. \(error)")
        }

//        delegate?.scheduleValueSaved(itemSchedule: item)
        
        dismiss(animated: true, completion: nil)
    }
    
}

//extension SchedulerTableViewController: TimeSettingDelegate {
//    func timeSettingValueAdded(itemTimeSetting: Item?) {
//        item = itemTimeSetting
//    }
//}
