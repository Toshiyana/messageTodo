//
//  TimeSettingViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit
import ChameleonFramework
import RealmSwift

class TimeSettingViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupLabel: UILabel!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    var delegate: TimeSettingDelegate?
    
//    var item: Item?
    var showEditItem: Bool = false
    
    let defaults = UserDefaults.standard
    
//    var formattedTimeInterval: String {
//        return String(timePicker.countDownDuration)
//    }

    var formattedTimeInterval: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]

        return formatter.string(from: timePicker.countDownDuration) ?? ""
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: timePicker.date)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 15
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let themeColor = defaults.getColorForKey(key: K.navbarColor) ?? FlatBlue()
        popupLabel.backgroundColor = themeColor
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            timePicker.datePickerMode = .countDownTimer
            repeatLabel.isHidden = false
            repeatSwitch.isHidden = false
        } else {
            timePicker.datePickerMode = .dateAndTime
            repeatLabel.isHidden = true
            repeatSwitch.isHidden = true
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveTimeButtonPressed(_ sender: UIButton) {
        if timeSegmentedControl.selectedSegmentIndex == 0 {
            delegate?.setTimeInterval(timeInv: timePicker.countDownDuration, timeType: .time, timeRepeats: repeatSwitch.isOn)
            
//            delegate?.setTimeInterval(timeInterval: timePicker.countDownDuration, timeText: formattedTimeInterval)
//            print(formattedTimeInterval)
        } else {
            delegate?.setDate(timeDate: timePicker.date, timeType: .calender)
//            delegate?.setDate(date: timePicker.date, dateText: formattedDate)
//            print(formattedDate)
        }
        
        
        if showEditItem {
//            delegate?.timeSettingValueAdded(itemTimeSetting: item)
        }
        
//        let isRepeatable = repeatSwitch.isOn
        
//        delegate?.scheduleValueAdded(reminder: )
        
        dismiss(animated: false, completion: nil)
    }
    
}

