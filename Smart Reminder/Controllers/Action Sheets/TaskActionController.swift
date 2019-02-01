//
//  TaskActionController.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

enum TaskAction: String {
    case markIncomplete = "Mark as incomplete"
    case markCompleted = "Mark as complete"
    case delete = "Delete"
    case cancel = "Cancel"
}

protocol TaskActionSheetDelegate: class {
    func taskAction(_ action: TaskAction, _ indexPath: IndexPath)
}

class TaskActionController: UIAlertController {
    
    weak var delegate: TaskActionSheetDelegate?
    
    lazy var markCompleted = UIAlertAction(title: TaskAction.markCompleted.rawValue, style: .default) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.taskAction(.markCompleted, _self.indexPath)
    }
    
    lazy var markIncomplete = UIAlertAction(title: TaskAction.markIncomplete.rawValue, style: .default) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.taskAction(.markIncomplete, _self.indexPath)
    }
    
    lazy var delete = UIAlertAction(title: TaskAction.delete.rawValue, style: .destructive) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.taskAction(.delete, _self.indexPath)
    }
    
    lazy var cancel = UIAlertAction(title: TaskAction.cancel.rawValue, style: .cancel) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.taskAction(.cancel, _self.indexPath)
    }
    
    override var preferredStyle: UIAlertController.Style {
        return .actionSheet
    }
    
    let indexPath: IndexPath
    
    init(isCompleted: Bool, for indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
        title = "What would you like to do?"
        if isCompleted { addAction(markIncomplete) }
        else { addAction(markCompleted) }
        addAction(cancel)
        addAction(delete)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
