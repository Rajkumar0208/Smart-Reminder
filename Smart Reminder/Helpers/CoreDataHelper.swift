//
//  CoreDataHelper.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import CoreData

enum CoreDataEntity: String {
    case Task
    
}

enum TaskAttribute: String {
    case dueDate, isCompleted, title
}

extension NSManagedObjectContext {
    
    func getTasks() -> [UserTask] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.Task.rawValue)
        do {
            let objects = try self.fetch(fetchRequest)
            let tasks = objects.map { UserTask($0) }
            return tasks
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            return []
        }
    }
    
    func saveTask(title: String, dueDate: Date, isCompleted: Bool = false) -> UserTask {
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntity.Task.rawValue, in: self)!
        let object = NSManagedObject(entity: entity, insertInto: self)
        object.setValue(title, forKeyPath: TaskAttribute.title.rawValue)
        object.setValue(dueDate, forKeyPath: TaskAttribute.dueDate.rawValue)
        object.setValue(isCompleted, forKeyPath: TaskAttribute.isCompleted.rawValue)
        
        do {
            try save()
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        return UserTask(object)
    }
    
    func deleteTask(_ task: UserTask) {
        let object = self.object(with: task.id)
        self.delete(object)
        do {
            try save()
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
    }
    
    func updateTask(_ task: UserTask) {
        let object = self.object(with: task.id)
        object.setValue(task.isCompleted, forKeyPath: TaskAttribute.isCompleted.rawValue)
        do {
            try save()
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
    }
}
