//
//  ItemContentViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/19.
//

import UIKit
import RealmSwift

final class ItemContentViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var navbar: UINavigationBar!

    weak var delegate: ItemDelegate?
    var showEditItem: Bool = false

    private var item: Item?

    // tableの初期値
    var itemTitle: String = ""
    var itemMemo: String = ""
    var reminderEnabled: Bool = false

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

        if repeats {
            return formatter.string(from: timeInterval)! + "（繰り返し）"
        } else {
            return formatter.string(from: timeInterval)!
        }
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
        table.register(SwitchCell.nib(), forCellReuseIdentifier: SwitchCell.identifier)

        table.delegate = self
        table.dataSource = self

        let themeColor = DefaultsManager.shared.getColor() ?? ColorUtility.defaultColor
        ColorUtility.changeNabBarColor(navBar: navbar, color: themeColor)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.itemContentToTimeSetting {
            let popup = segue.destination as! TimeSettingViewController
            popup.delegate = self
        }
    }

    @IBAction private func saveButtonPressed(_ sender: UIBarButtonItem) {
        if reminderEnabled && date == nil && timeInterval == 0 {
            // リマインダーがonだが、通知時間を設定していない場合はアラートを表示。
            showTimeAlert()
        } else {
            if wordEnabled {
                guard let allMessages = MessageManager.shared.loadMessages(in: nil) else { return }
                let messageCount = allMessages.count

                // wordEnabledがtrueのときは、wordSwitchよりmessageCountが0になることないので、このifはいらない気もする
                if messageCount != 0 {
                    let randomIndex = Int.random(in: 0 ..< messageCount)
                    let randomMessage = allMessages[randomIndex].content
                    wordBody = randomMessage
                }
            }

            // リマインダーがoffの場合
            if showEditItem { // showEditItemはここでしか使っていない
                delegate?.itemValueEdited(title: itemTitle, memo: itemMemo, reminderEnabled: reminderEnabled,
                                          wordEnabled: wordEnabled, wordBody: wordBody, timeInterval: timeInterval,
                                          date: date, repeats: repeats, reminderType: reminderType)
            } else {
                delegate?.itemValueAdded(title: itemTitle, memo: itemMemo, reminderEnabled: reminderEnabled,
                                         wordEnabled: wordEnabled, wordBody: wordBody, timeInterval: timeInterval,
                                         date: date, repeats: repeats, reminderType: reminderType)
            }
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension ItemContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else if section == 2 {
            if reminderEnabled {
                return 2
            } else {
                return 0
            }
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let fieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath) as! TextFieldCell

                fieldCell.configure(text: itemTitle) // itemTitleは、Addのときに初期値の""で、showEditItemがtrueのときにTodoListVCから渡された値が入る
                fieldCell.field.addTarget(self, action: #selector(didChangedField(_:)), for: .editingChanged) // .editingDidEndにするとうまく保存されない

                return fieldCell
            } else if indexPath.row == 1 {
                let textViewCell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.identifier, for: indexPath) as! TextViewCell

                textViewCell.textView.delegate = self
                textViewCell.configure(text: itemMemo) // itemMemoは、Addのときに初期値の""で、showEditItemがtrueのときにTodoListVCから渡された値が入る
                textViewCell.textView.addDoneButton(title: "完了", target: self, selector: #selector(tapDone(sender:)))

                return textViewCell
            }
        } else if indexPath.section == 1 {
            let reminderSwitchCell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as! SwitchCell

            reminderSwitchCell.mySwitch.addTarget(self, action: #selector(didChangedReminderSwitch(_:)), for: .valueChanged) // reminderEnabledを取得するため、configure()の前に実行
            reminderSwitchCell.configure(text: "リマインダーを送る", isOn: reminderEnabled)

            return reminderSwitchCell
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let wordSwitchCell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as! SwitchCell

                wordSwitchCell.mySwitch.addTarget(self, action: #selector(didChangedWordSwitch(_:)), for: .valueChanged) // reminderEnabledを取得するため、configure()の前に実行
                wordSwitchCell.configure(text: "ランダムな言葉を添えて通知", isOn: wordEnabled)

                return wordSwitchCell
            } else if indexPath.row == 1 {
                let timeCell = tableView.dequeueReusableCell(withIdentifier: TimeSettingCell.identifier, for: indexPath) as! TimeSettingCell

                switch reminderType {
                case ReminderType.time.rawValue:
                    timeCell.configure(timeText: formattedTimeInterval)
                case ReminderType.calender.rawValue:
                    timeCell.configure(timeText: formattedDate)
                default: // ReminderType.none.rawValue
                    timeCell.configure(timeText: "指定なし")
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

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 150
        return UITableView.automaticDimension
    }

    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

    @objc func didChangedField(_ sender: UITextField) {
        itemTitle = sender.text!
    }

    @objc func didChangedReminderSwitch(_ sender: UISwitch) {
        reminderEnabled = sender.isOn

        if sender.isOn == false {
            // Reset Reminder Setting
            wordEnabled = false
            reminderType = ReminderType.none.rawValue
        }

        table.reloadData()
    }

    @objc func didChangedWordSwitch(_ sender: UISwitch) {
        // wordがひとつも登録されていない時、onにできないようにして、メッセージ追加のアラートを表示
        // wordSwitchを切り替えるたびに、messageを全て取得するのはあまり良くない
        guard let allMessages = MessageManager.shared.loadMessages(in: nil) else { return }
        let messageCount = allMessages.count

        if messageCount == 0 {
            sender.setOn(false, animated: true)
            showMessageAlert()
        } else {
            wordEnabled = sender.isOn
        }
    }

    func showTimeAlert() {
        let alert = UIAlertController(title: "リマインダーの入力不足", message: "通時時間を設定してください", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: K.itemContentToTimeSetting, sender: self)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func showMessageAlert() {
        let alert = UIAlertController(title: "言葉が追加されていません", message: "", preferredStyle: .alert)
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
        table.reloadData()
    }

    func setDate(timeDate: Date, timeType: ReminderType) {
        date = timeDate
        reminderType = timeType.rawValue
        table.reloadData()
    }
}

extension ItemContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        itemMemo = textView.text
    }
}
