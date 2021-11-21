//
//  ItemViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/15.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController {
    
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var reminderButton: UIButton!
    
    let realm = try! Realm()
    
    var showEditItem: Bool = false

    var item: Item?
//    var itemTitle: String?
//    var memo: String?
    
    var delegate: ItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        itemTitleTextField.delegate = self
        
        memoTextView.addDoneButton(title: "完了", target: self, selector: #selector(tapDone(sender:)))
                
        if showEditItem {
            itemTitleTextField.text = item?.title
            memoTextView.text = item?.memo
//            itemTitleTextField.text = itemTitle
//            memoTextView.text = memo
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if item?.reminderEnabled ?? false {
//            reminderButton.setTitle("リマインダーあり", for: .normal)
//        }
    }
    
//    @IBAction func reminderButtonPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: K.itemToScheduler, sender: self)
//    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.itemToScheduler {
//            let vc = segue.destination as! SchedulerViewController
////            let vc = segue.destination as! SchedulerTableViewController
////            vc.delegate = self
//            
//            if showEditItem {
//                if let item = item {
//                    vc.showEditItem = showEditItem
//                    vc.item = item
//
//                }
//            }
//        }
    }

    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

        
    @IBAction func saveButtonPressed(_ sender: UIButton) {
//        item?.title = itemTitleTextField.text!
//        item?.memo = memoTextView.text!
        
//        let itemTitleText = itemTitleTextField.text!
//        let memoText = memoTextView.text!
        
        
//        let reminder = Reminder()
//        reminder.timeInterval = 60

        if showEditItem {
            do {
                try realm.write {
                    item?.title = itemTitleTextField.text!
                    item?.memo = memoTextView.text!
//                    item.reminderEnabled = itemValue?.reminderEnabled ?? false
//                    item.reminder = itemValue?.reminder
                }
            } catch {
                print("Error editing item. \(error)")
            }

//            delegate?.itemValueEdited(itemValue: item)
        }
        else {
            
            let newItem = Item()
            newItem.title = itemTitleTextField.text!
            newItem.memo = memoTextView.text!
//            newItem.reminderEnabled = itemValue?.reminderEnabled ?? false
//            newItem.reminder = itemValue?.reminder

            do {
                try realm.write {
                    realm.add(newItem)
                }
            } catch {
                print("Error saving item. \(error)")
            }

//            delegate?.itemValueAdded(itemValue: item)
        }
//        delegate?.itemTableRelod()
        
//        if showEditItem {
//            delegate?.itemValueEdited(title: itemTitleText, memo: memoText, reminderEnabled: true, reminder: nil)
//        } else {
//            delegate?.itemValueAdded(title: itemTitleText, memo: memoText, reminderEnabled: true, reminder: nil)
//        }
        
//        var notificationBody = ""
//        let withWord = true
//        if withWord {
//            let allMessages = realm.objects(Message.self)
//            let messageCount = allMessages.count
//            let randomIndex = Int.random(in: 0 ..< messageCount)
//            let randomMessage = allMessages[randomIndex].content
//            notificationBody = randomMessage
//        }
        
        
//        LocalNotificationManager.setNotification(5, of: .seconds, repeats: false, title: itemTitleText, body: notificationBody, userInfo: ["aps": ["hello": "world"]])
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
                
        dismiss(animated: true, completion: nil)
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (itemTitleTextField.isFirstResponder) {
            itemTitleTextField.resignFirstResponder()
        }
        else if (memoTextView.isFirstResponder) {
            memoTextView.resignFirstResponder()
        }
    }
}

extension ItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTitleTextField.endEditing(true)
        return true
    }
}

extension ItemViewController: ScheduleDelegate {
    func scheduleValueAdded(itemSchedule: Item?) {
        item = itemSchedule
    }
    
    func scheduleValueSaved(itemSchedule: Item?) {
//        do {
//            try realm.write {
//                item?.reminderEnabled = itemSchedule?.reminderEnabled ?? false
//                item?.reminder = itemSchedule?.reminder
//            }
//        } catch {
//            print("Error editing item. \(error)")
//        }
    }
}
