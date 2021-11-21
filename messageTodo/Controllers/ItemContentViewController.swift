//
//  ItemContentViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/19.
//

import UIKit
import RealmSwift

class ItemContentViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let realm = try! Realm()
    
    var delegate: ItemDelegate?
    var showEditItem: Bool = false
    
    var item: Item?
    
    // tableの初期値
    var itemTitle: String = ""
    var itemMemo: String = ""
    var reminderEnabled: Bool = false
   
//    var reminder: Reminder?
    
//    var wordEnabled: Bool = false
    
//    var itemTimeInterval: TimeInterval?
//    var itemDate: Date?
    
    // About reminder
    var wordEnabled: Bool = false
    var wordBody: String = ""
    var timeInterval: TimeInterval = 0
    var date: Date?
    var repeats: Bool = false
    var reminderType = ReminderType.none.rawValue

    
    var timeLabel: String?

    var formattedTimeInterval: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
//        return formatter.string(from: timeInterval)!
        return formatter.string(from: timeInterval)!
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true
        formatter.locale = Locale(identifier: "ja_JP")

        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(TextFieldCell.nib(), forCellReuseIdentifier: TextFieldCell.identifier)
        table.register(TextViewCell.nib(), forCellReuseIdentifier: TextViewCell.identifier)
        table.register(TimeSettingCell.nib(), forCellReuseIdentifier: TimeSettingCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.itemContentToTimeSetting {
            let popup = segue.destination as! TimeSettingViewController
            popup.delegate = self
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

//        print(reminderEnabled)
//        print(reminder?.date)
//        print(reminder?.timeInterval)

        if reminderEnabled && date == nil && timeInterval == 0 {
            // リマインダーがonだが、通知時間を設定していない場合はアラートを表示。
            showTimeAlert()
        }
        
//        if reminderEnabled && reminder?.date == nil && reminder?.timeInterval == 0 {
//            // リマインダーがonだが、通知時間を設定していない場合はアラートを表示。
//            showTimeAlert()
//        }
//        if reminderEnabled && reminder?.date == nil {
//            // リマインダーがonだが、通知時間を設定していない場合はアラートを表示。
//            if reminder?.timeInterval == nil || reminder?.timeInterval != 0 {
//                showTimeAlert()
//            }
//        }
        else {
            if wordEnabled {
                let allMessages = realm.objects(Message.self)
                let messageCount = allMessages.count
                
                // wordEnabledがtrueのときは、wordSwitchよりmessageCountが0になることないので、このifはいらない気もする
                if messageCount != 0 {
                    let randomIndex = Int.random(in: 0 ..< messageCount)
                    let randomMessage = allMessages[randomIndex].content
                    wordBody = randomMessage
                }
            }
            
            // リマインダーがoffの場合
            if showEditItem {
                print(itemTitle)
                delegate?.itemValueEdited(title: itemTitle, memo: itemMemo, reminderEnabled: reminderEnabled, wordEnabled: wordEnabled, wordBody: wordBody, timeInterval: timeInterval, date: date, repeats: repeats, reminderType: reminderType)
//                delegate?.itemValueEdited(title: itemTitle, memo: itemMemo, reminderEnabled: reminderEnabled, reminder: reminder)
            }
            else {
                print(itemTitle)
                delegate?.itemValueAdded(title: itemTitle, memo: itemMemo, reminderEnabled: reminderEnabled, wordEnabled: wordEnabled, wordBody: wordBody, timeInterval: timeInterval, date: date, repeats: repeats, reminderType: reminderType)
//                delegate?.itemValueAdded(title: itemTitle, memo: itemMemo, reminderEnabled: reminderEnabled, reminder: reminder)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ItemContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 1
//            print(reminderEnabled)
//            if reminderEnabled {
//                return 3
//            }
//            else {
//                return 1
//            }
        }
        else if section == 2 {
            if reminderEnabled {
                return 2
            }
            else {
                return 0
            }
        }
                
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let fieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath) as! TextFieldCell

                if showEditItem {
//                    itemTitle = item?.title ?? ""
                    fieldCell.field.text = itemTitle
                }

                fieldCell.field.addTarget(self, action: #selector(didChangedField(_:)), for: .editingChanged)
//                fieldCell.field.addTarget(self, action: #selector(didChangedField(_:)), for: .editingDidEnd)
                return fieldCell
            }
            
            else if indexPath.row == 1 {
                let textViewCell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.identifier, for: indexPath) as! TextViewCell
                textViewCell.textViewInCell.delegate = self
                
                if showEditItem {
//                    itemMemo = item?.memo ?? ""
                    textViewCell.textViewInCell.text = itemMemo
                }

                return textViewCell
            }
        }

        else if indexPath.section == 1 {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            switchCell.textLabel?.text = "リマインダーを送る"
            
            let reminderSwitch = UISwitch()
            reminderSwitch.addTarget(self, action: #selector(didChangedReminderSwitch(_:)), for: .valueChanged)
            reminderSwitch.isOn = reminderEnabled
            switchCell.accessoryView = reminderSwitch
            
            return switchCell
        }

        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let switchCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                switchCell.textLabel?.text = "言葉を添えて通知"
                
                let reminderSwitch = UISwitch()
                reminderSwitch.addTarget(self, action: #selector(didChangedWordSwitch(_:)), for: .valueChanged)
//                reminderSwitch.isOn = reminder?.wordEnabled ?? false
                reminderSwitch.isOn = wordEnabled
                switchCell.accessoryView = reminderSwitch
                
                return switchCell
            }
            else if indexPath.row == 1 {
                let timeCell = tableView.dequeueReusableCell(withIdentifier: TimeSettingCell.identifier, for: indexPath) as! TimeSettingCell

//                if let time = timeLabel {
//                    timeCell.timeLabel.text = time
//                }
//                if let type = reminder?.reminderTypeEnum, type != .none{
//                    if type == .time {
//                        timeCell.timeLabel.text = formattedTimeInterval
//                    }
//                    else if type == .calender {
//                        timeCell.timeLabel.text = formattedDate
//                    }
//                }
//                print(reminderType)
                if reminderType != ReminderType.none.rawValue {
                    if reminderType == ReminderType.time.rawValue {
                        timeCell.timeLabel.text = formattedTimeInterval
                    }
                    else if reminderType == ReminderType.calender.rawValue {
                        timeCell.timeLabel.text = formattedDate
                    }
                }
                else {
                    timeCell.timeLabel.text = "指定なし"
                }

                return timeCell
            }
        }

        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 1 {
            performSegue(withIdentifier: K.itemContentToTimeSetting, sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 150
        return UITableView.automaticDimension
    }
    
    @objc func didChangedField(_ sender: UITextField) {
        itemTitle = sender.text!
//        print(itemTitle)
//        print(sender.text ?? "")
    }
    
    
    
    @objc func didChangedReminderSwitch(_ sender: UISwitch) {
        reminderEnabled = sender.isOn
        if sender.isOn {
//            reminder = Reminder()
            print("Reminder Switch on")
        } else {
//            reminder = nil
//            timeLabel = nil
            print("Reminder Switch off")
        }
        
        table.reloadData()
    }

    @objc func didChangedWordSwitch(_ sender: UISwitch) {
        // wordがひとつも登録されていない時、onにできないようにして、メッセージ追加のアラートを表示
        // wordSwitchを切り替えるたびに、messageを全て取得するのはあまり良くない
        let allMessages = realm.objects(Message.self)
        let messageCount = allMessages.count

        if messageCount == 0 {
            sender.setOn(false, animated: true)
            showMessageAlert()
        }
        else {
            wordEnabled = sender.isOn
        }
//        reminder?.wordEnabled = sender.isOn
        
        if sender.isOn {
            print("Word Switch on")
        } else {
            print("Word Switch off")
        }
    }

    func showTimeAlert() {
        let alert = UIAlertController(title: "リマインダーの入力不足", message: "通時時間を設定してください", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.performSegue(withIdentifier: K.itemContentToTimeSetting, sender: self)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showMessageAlert() {
        let alert = UIAlertController(title: "言葉を添える場合、メッセージを追加してください", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
}

extension ItemContentViewController: TimeSettingDelegate {
    
    func setTimeInterval(timeInv: TimeInterval, timeType: ReminderType, timeRepeats: Bool) {
        timeInterval = timeInv
        reminderType = timeType.rawValue
        repeats = timeRepeats
//        reminder?.timeInterval = timeInterval
//        reminder?.date = nil
//
//        reminder?.reminderTypeEnum = timeType
//
//        print(reminder?.date)
//        print(reminder?.timeInterval)
//        print(reminder?.reminderTypeEnum)
//        print(reminder?.reminderType)
        table.reloadData()
    }
    
    func setDate(timeDate: Date, timeType: ReminderType) {
        date = timeDate
        reminderType = timeType.rawValue
//        reminder?.date = date
//        reminder?.timeInterval = 0
//
//        reminder?.reminderTypeEnum = timeType
//
//        print(reminder?.date)
//        print(reminder?.timeInterval)
//        print(reminder?.reminderTypeEnum)
//        print(reminder?.reminderType)
        table.reloadData()
    }
    
//    func setTimeInterval(timeInterval: TimeInterval, timeText: String) {
//        reminder?.timeInterval = timeInterval
////        reminder?.date = nil
//        print(reminder?.timeInterval)
////        print(reminder?.date)
//        //        itemTimeInterval = timeInterval
//        timeLabel = timeText
//        table.reloadData()
//    }
//
//    func setDate(date: Date, dateText: String) {
//        reminder?.date = date
////        reminder?.timeInterval = 0
////        print(reminder?.timeInterval)
//        print(reminder?.date)
////        itemDate = date
//        timeLabel = dateText
//        table.reloadData()
//    }
    
    
//    func setTimeInterval(timeInterval: TimeInterval) {
//        itemTimeInterval = timeInterval
//    }
//
//    func setDate(date: Date) {
//        itemDate = date
//    }
    
//    func setTimeLabel(time: String) {
//        timeLabel = time
//    }
}

extension ItemContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        itemMemo = textView.text
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        itemMemo = textView.text
//        print(itemMemo!)
////        print(textView.text ?? "")
//    }
}
