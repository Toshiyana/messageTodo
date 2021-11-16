//
//  SchedulerTableViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit

class SchedulerTableViewController: UITableViewController {

    //
    @IBOutlet weak var notificationSwitch: UISwitch!
    //
    @IBOutlet weak var wordSwitch: UISwitch!
    
    
    //
    @IBOutlet weak var timeOptionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    @IBOutlet weak var repeatSwitch: UISwitch!
        
    override func viewDidLoad() {
        super.viewDidLoad()

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
        dismiss(animated: true, completion: nil)
    }
    
}
