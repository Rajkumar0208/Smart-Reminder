//
//  ReminderDataSource.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

enum Filter {
    case completed, pending, overdue
}

class ReminderDataSource: NSObject {
    
    private var tasks: [UserTask] = []
    private var filteredTasks: [UserTask] = []
    private let cellID = "cell"
    private var filter: Filter = .pending
    
    override init() {
        super.init()
        fetchFromCoreData()
    }
    
    func task(at indexPath: IndexPath) -> UserTask {
        return filteredTasks[indexPath.row]
    }
    
    func delete(at indexPath: IndexPath) {
        let deletedTask = filteredTasks[indexPath.row]
        deleteObject(deletedTask)
        filteredTasks.remove(at: indexPath.row)
        if let index = tasks.firstIndex(where: { $0.id == deletedTask.id }) {
            tasks.remove(at: index)
        }
    }
    
    func update(at indexPath: IndexPath, isCompleted: Bool) {
        filteredTasks[indexPath.row].isCompleted = isCompleted
        update(filteredTasks[indexPath.row])
        if let index = tasks.firstIndex(where: { $0.id == filteredTasks[indexPath.row].id }) {
            tasks[index].isCompleted = isCompleted
        }
        applyFilter(filter)
    }
    
    func applyFilter(_ filter: Filter) {
        self.filter = filter
        switch filter {
        case .completed:
            filteredTasks = tasks.filter { $0.isCompleted }
        case .pending:
            filteredTasks = tasks.filter { !$0.isCompleted }
        case .overdue:
            filteredTasks = tasks.filter { !$0.isCompleted && $0.dueDate.isOverdue }
        }
    }
    
}

extension ReminderDataSource: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? TaskCell else { return UITableViewCell() }
        let task = filteredTasks[indexPath.row]
        cell.configureCell(task)
        return cell
    }

}

//MARK:- Core Data
extension ReminderDataSource {
    
    fileprivate func fetchFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.Task.rawValue)
        do {
            let objects = try managedContext.fetch(fetchRequest)
            let tasks = objects.map { UserTask($0) }
            self.tasks = tasks
            applyFilter(filter)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(title: String, dueDate: Date, isCompleted: Bool = false) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntity.Task.rawValue, in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        object.setValue(title, forKeyPath: TaskAttribute.title.rawValue)
        object.setValue(dueDate, forKeyPath: TaskAttribute.dueDate.rawValue)
        object.setValue(isCompleted, forKeyPath: TaskAttribute.isCompleted.rawValue)
        
        do {
            try managedContext.save()
            let task = UserTask(object)
            setLocalPushNotification(task)
            tasks.append(task)
            applyFilter(filter)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func setLocalPushNotification(_ task: UserTask) {
        let content = UNMutableNotificationContent()
        content.title = "Smart Reminder Alert"
        content.subtitle = task.title
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let timeInterval = task.dueDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        if timeInterval <= 0 { return }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let requestID = task.id.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    fileprivate func deleteObject(_ task: UserTask) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let object = managedContext.object(with: task.id)
        managedContext.delete(object)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uriRepresentation().absoluteString])
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func update(_ task: UserTask) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let object = managedContext.object(with: task.id)
        object.setValue(task.isCompleted, forKeyPath: TaskAttribute.isCompleted.rawValue)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
