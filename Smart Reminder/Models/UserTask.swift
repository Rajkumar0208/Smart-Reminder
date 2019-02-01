//
//  UserTask.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import CoreData

struct UserTask {
    
    let id: NSManagedObjectID
    let title: String
    let dueDate: Date
    var isCompleted: Bool
    
    init(_ object: NSManagedObject) {
        id = object.objectID
        title = object.value(forKeyPath: TaskAttribute.title.rawValue) as? String ?? ""
        dueDate = object.value(forKeyPath: TaskAttribute.dueDate.rawValue) as? Date ?? Date()
        isCompleted = object.value(forKeyPath: TaskAttribute.isCompleted.rawValue) as? Bool ?? false
    }
}
