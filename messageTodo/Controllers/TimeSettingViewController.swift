//
//  TimeSettingViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/12.
//

import UIKit
import RealmSwift

class TimeSettingViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupLabel: UILabel!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!

    weak var delegate: TimeSettingDelegate?

    var showEditItem: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 15
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let themeColor = DefaultsManager.shared.getColor() ?? ColorUtility.defaultColor
        popupLabel.backgroundColor = themeColor
    }

    @IBAction private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
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

    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction private func saveTimeButtonPressed(_ sender: UIButton) {
        if timeSegmentedControl.selectedSegmentIndex == 0 {
            delegate?.setTimeInterval(timeInv: timePicker.countDownDuration, timeType: .time, timeRepeats: repeatSwitch.isOn)
        } else {
            delegate?.setDate(timeDate: timePicker.date, timeType: .calender)
        }

        dismiss(animated: false, completion: nil)
    }
}
