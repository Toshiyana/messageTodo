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
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    
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
        } else {
            timePicker.datePickerMode = .dateAndTime
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveTimeButtonPressed(_ sender: UIButton) {
        
        let allItems = realm.objects(Item.self)
        let itemCountText = String(allItems.count)
        
        let allMessages = realm.objects(Message.self)
        let messageCount = allMessages.count
        let randomIndex = Int.random(in: 0 ..< messageCount)
        let randomMessage = allMessages[randomIndex].content
        
        
    LocalNotificationManager.setNotification(5, of: .seconds, repeats: false, title: "残りのタスクは\(itemCountText)つです！", body: randomMessage, userInfo: ["aps": ["hello": "world"]])
        dismiss(animated: false, completion: nil)
    }
    
    

}
