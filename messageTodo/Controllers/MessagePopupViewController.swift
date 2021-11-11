//
//  MessagePopupViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/04.
//

import UIKit
import ChameleonFramework

class MessagePopupViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    var showEditPopup: Bool = false
    var titleColor: UIColor?
    var name: String?
    var content: String?
    var imgData: Data?
    
    var delegate: MessagePopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        contentTextField.delegate = self
                
//        iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysOriginal)
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        
        popupView.layer.cornerRadius = 15
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.masksToBounds = true
        
        titleLabel.backgroundColor = titleColor
        titleLabel.textColor = ContrastColorOf(titleColor!, returnFlat: true)

        if showEditPopup {
            titleLabel.text = "言葉の編集"
            nameTextField.text = name
            contentTextField.text = content
            iconImageView.image = UIImage(data: imgData!) // default画像設定しているので必ず存在するが、!良くない？
        }
    }
    
    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let nameText = nameTextField.text!
        let contentText = contentTextField.text!
        let imageData = iconImageView.image?.pngData()//default画像を設定しているので、それも毎回保存してしまうのは良くない？
        
        if showEditPopup {
            delegate?.popupValueEdited(name: nameText, content: contentText, imageData: imageData)
        } else {
            delegate?.popupValueAdded(name: nameText, content: contentText, imageData: imageData)
        }
        
        dismiss(animated: false)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
}

extension MessagePopupViewController: UITextFieldDelegate {
    
    // keyboardのreturnを押した時の処理を記述
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Returnを押した時にkeyboardを閉じる（Popup上の全てのtextFieldを対象）
        // 指定のtextFieldに対して行う場合は、IBOutletで命名した名前を利用（ex: nameTextField.endEditing(true)）
        textField.endEditing(true)
        return true
    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            return true // keyboardを閉じる
//        } else {
//            textField.placeholder = "文字を入力してください"
//            return false // keyboardを開いたまま
//        }
//    }
}

extension MessagePopupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        
        let sheet = UIAlertController(title: "画像の選択", message: nil, preferredStyle: .alert)
        
        let photoLibraryAction = UIAlertAction(title: "アルバムから選択", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        sheet.addAction(photoLibraryAction)
        sheet.addAction(cameraAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            iconImageView.image = editedImage
//            let data = editedImage.pngData()!
//            iconImageView.image = UIImage(data: data)
        
//        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            iconImageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
