//
//  MessagePopupViewController.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/11/04.
//

import UIKit
import CropViewController

final class MessagePopupViewController: UIViewController, CropViewControllerDelegate {
    @IBOutlet private weak var popupView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!

    var showEditPopup: Bool = false
    var titleColor: UIColor?
    var name: String?
    var content: String?
    var imgData: Data?

    weak var delegate: MessagePopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        nameTextField.setLeftPaddingPoints(5)

        contentTextView.addDoneButton(title: "完了", target: self, selector: #selector(tapDone(sender:)))

        popupView.layer.cornerRadius = 15
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.masksToBounds = true

        titleLabel.backgroundColor = titleColor
        titleLabel.textColor = UIColor.white

        iconImageButton.layer.cornerRadius = iconImageButton.frame.width / 2
        iconImageButton.layer.masksToBounds = true

        if showEditPopup {
            titleLabel.text = "言葉の編集"
            nameTextField.text = name
            contentTextView.text = content

            if let iconImage = UIImage(data: imgData!) {
                iconImageButton.setImage(
                    iconImage.withRenderingMode(.alwaysOriginal),
                    for: .normal)
            }
        }
    }

    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction private func changeImageButtonPressed(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
    }

    @IBAction private func saveButtonPressed(_ sender: UIButton) {
        let nameText = nameTextField.text!
        let contentText = contentTextView.text!
        let imageData = iconImageButton.image(for: .normal)?.pngData()

        if showEditPopup {
            delegate?.popupValueEdited(name: nameText, content: contentText, imageData: imageData)
        } else {
            delegate?.popupValueAdded(name: nameText, content: contentText, imageData: imageData)
        }

        dismiss(animated: false, completion: nil)
    }

    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        } else if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
    }
}

extension MessagePopupViewController: UITextFieldDelegate {
    // keyboardのreturnを押した時の処理を記述
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Returnを押した時にkeyboardを閉じる（Popup上の全てのtextFieldを対象）
        // 指定のtextFieldに対して行う場合は、IBOutletで命名した名前を利用（ex: nameTextField.endEditing(true)）
        nameTextField.endEditing(true)
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

    //    func dismissKeyboard() {
    //           let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(MessagePopupViewController.dismissKeyboardTouchOutside))
    //           tap.cancelsTouchesInView = false
    //           view.addGestureRecognizer(tap)
    //    }
    //    @objc private func dismissKeyboardTouchOutside() {
    //       view.endEditing(true)
    //    }
}

// UIImagePickerControllerDelegateとCropViewControllerを用いる場合
// MARK: - UIImagePickerControllerDelegate
extension MessagePopupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerActionSheet() {
        let sheet = UIAlertController(title: "画像の選択", message: nil, preferredStyle: .alert)

        let photoLibraryAction = UIAlertAction(title: "アルバムから選択", style: .default) { [weak self] _ in
            self?.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { [weak self] _ in
            self?.showImagePickerController(sourceType: .camera)
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
        imagePickerController.allowsEditing = false // CropViewControllerを利用するのでfalse（defaultはfalseだからなくても良い）
        imagePickerController.sourceType = sourceType

        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        // CropViewControllerを用いて円状にCrop
        let cropViewController = CropViewController(croppingStyle: .circular, image: originalImage)
        cropViewController.delegate = self

        picker.dismiss(animated: true) {
            self.present(cropViewController, animated: true, completion: nil)
        }
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        iconImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

// UIImagePickerControllerのみを用いる場合
// extension MessagePopupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func showImagePickerControllerActionSheet() {
//
//        let sheet = UIAlertController(title: "画像の選択", message: nil, preferredStyle: .alert)
//
//        let photoLibraryAction = UIAlertAction(title: "アルバムから選択", style: .default) { [weak self] (action) in
//            self?.showImagePickerController(sourceType: .photoLibrary)
//        }
//        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { [weak self] (action) in
//            self?.showImagePickerController(sourceType: .camera)
//        }
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
//
//        sheet.addAction(photoLibraryAction)
//        sheet.addAction(cameraAction)
//        sheet.addAction(cancelAction)
//
//        present(sheet, animated: true, completion: nil)
//    }
//
//    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
//
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
//        imagePickerController.sourceType = sourceType
//
//        present(imagePickerController, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            iconImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
//
//
//        }
//        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            iconImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
// }
