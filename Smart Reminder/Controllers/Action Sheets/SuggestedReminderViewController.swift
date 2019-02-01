//
//  SuggestedReminderViewController.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

protocol SuggestedActionDelegate: class {
    func suggestedAction(_ title: String)
}

class SuggestedReminderViewController: UIAlertController {

    weak var delegate: SuggestedActionDelegate?
    
    let object: ClassifierObject
    
    lazy var cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    init(object: ClassifierObject) {
        self.object = object
        super.init(nibName: nil, bundle: nil)
        addAction(cancel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in object.suggestions {
            let alert = UIAlertAction(title: i, style: .default) { [weak self] action in
                self?.delegate?.suggestedAction(action.title ?? "")
            }
            addAction(alert)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
