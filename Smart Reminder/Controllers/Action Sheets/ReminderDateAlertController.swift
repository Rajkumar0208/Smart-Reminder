//
//  ReminderDateAlertController.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

protocol ReminderDateAlertDelegate: class {
    func reminderDateAlert(_ date: Date)
}

class ReminderDateAlertController: UIAlertController {

    weak var delegate: ReminderDateAlertDelegate?
    
    override var preferredStyle: UIAlertController.Style {
        return .actionSheet
    }
    
    lazy var pickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.minimumDate = Date()
        return picker
    }()
    
    lazy var cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] action in
        self?.dismiss(animated: true, completion: nil)
    }
    lazy var save = UIAlertAction(title: "Save", style: .default) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.reminderDateAlert(_self.pickerView.date)
        self?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(pickerView)
        addConstraints()
        addAction(save)
        addAction(cancel)
    }
    
    func addConstraints() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -100)
        let leftConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: pickerView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
        view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
    }

}
