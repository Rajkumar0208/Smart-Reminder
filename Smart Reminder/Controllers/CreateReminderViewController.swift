//
//  CreateReminderViewController.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

class CreateReminderViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var noObjectDetectedLabel: UILabel!
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var editDateButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    var reminderDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Reminder"
        titleTextField.delegate = self
    }
    
    @IBAction func editDateButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        noObjectDetectedLabel.isHidden = true
        let alert = ReminderDateAlertController()
        alert.delegate = self
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, title != "" else {
            titleTextField.becomeFirstResponder()
            return
        }
        guard let date = reminderDate else {
            editDateButtonTapped(sender)
            return
        }
        guard let nav = parent as? UINavigationController else { fatalError() }
        nav.save(title: title, dueDate: date)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openGallery(_ sender: Any) {
        noObjectDetectedLabel.isHidden = true
        titleTextField.resignFirstResponder()
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            pictureSource(.photoLibrary)
            return
        }
        let alert = PictureSourceAlertController()
        alert.delegate = self
        present(alert, animated: true, completion: nil)
    }
    
}

extension CreateReminderViewController: ReminderDateAlertDelegate {
    
    func reminderDateAlert(_ date: Date) {
        reminderDate = date
        dateTimeTextField.text = date.readableDate
    }
}

extension CreateReminderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noObjectDetectedLabel.isHidden = true
        guard let text = textField.text, text != "" else { return false }
        textField.resignFirstResponder()
        return true
    }
}

extension CreateReminderViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage, let ciImage = CIImage(image: image) else {
            return
        }
        recognizeImage(image: ciImage)
    }
    
    func recognizeImage(image: CIImage) {
        image.recogniseImage { [weak self] object in
            DispatchQueue.main.async { [weak self] in
                self?.noObjectDetectedLabel.isHidden = object != nil
            }
            guard let obj = object else { return }
            let alert = SuggestedReminderViewController(object: obj)
            alert.delegate = self
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension CreateReminderViewController: SuggestedActionDelegate {
    
    func suggestedAction(_ title: String) {
        titleTextField.text = title
    }
}

extension CreateReminderViewController: PictureSourceDelegate {
    
    func pictureSource(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = false
        present(picker, animated: true)
    }
}
