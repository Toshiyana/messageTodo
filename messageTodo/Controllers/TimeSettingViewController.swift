//
//  TimeSettingViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit
import ChameleonFramework

class TimeSettingViewController: UIViewController {
    
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var popupLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeTableView.dataSource = self
        timeTableView.delegate = self
        
        timeTableView.register(UINib(nibName: K.TimeSetting.timePickerCellIdentifier, bundle: nil), forCellReuseIdentifier: K.TimeSetting.timePickerCellIdentifier)
        timeTableView.register(UINib(nibName: K.TimeSetting.switchCellIdentifier, bundle: nil), forCellReuseIdentifier: K.TimeSetting.switchCellIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let themeColor = defaults.getColorForKey(key: K.navbarColor) ?? FlatBlue()
        popupLabel.backgroundColor = themeColor
    }

    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTimeButtonPressed(_ sender: UIButton) {
//        let timeCell = timeTableView.dequeueReusableCell(withIdentifier: K.TimeSetting.timePickerCellIdentifier) as! TimePickerCell
//        let repeatCell = timeTableView.dequeueReusableCell(withIdentifier: K.TimeSetting.switchCellIdentifier) as! SwitchCell
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    

}

extension TimeSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.TimeSetting.timePickerCellIdentifier) as! TimePickerCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.TimeSetting.switchCellIdentifier) as! SwitchCell
            print(cell.repeatSwitch.isOn)
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
