//
//  TaskCell.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 02/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    func configureCell(_ task: UserTask) {
        textLabel?.text = task.title
        detailTextLabel?.text = task.dueDate.readableDate
        accessoryType = task.isCompleted ? .checkmark : .none
        let isOverdue = !task.isCompleted && task.dueDate.isOverdue
        detailTextLabel?.textColor = isOverdue ? UIColor.red : UIColor.black
    }
}
