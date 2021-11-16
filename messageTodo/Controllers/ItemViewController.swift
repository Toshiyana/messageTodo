//
//  ItemViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/15.
//

import UIKit

class ItemViewController: UIViewController {
    
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    
    var showEditItem: Bool = false
    var itemTitle: String?
    var memo: String?
    
    var delegate: ItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        itemTitleTextField.delegate = self
        
        memoTextView.addDoneButton(title: "完了", target: self, selector: #selector(tapDone(sender:)))
                
        if showEditItem {
            itemTitleTextField.text = itemTitle
            memoTextView.text = memo
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let itemTitleText = itemTitleTextField.text!
        let memoText = memoTextView.text!
        
        if showEditItem {
            delegate?.itemValueEdited(title: itemTitleText, memo: memoText)
        } else {
            delegate?.itemValueAdded(title: itemTitleText, memo: memoText)
        }
        
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
