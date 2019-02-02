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
    
    fileprivate var tasks: [UserTask] = []
    fileprivate var filteredTasks: [UserTask] = []
    fileprivate let cellID = "cell"
    fileprivate var filter: Filter = .pending
    
    lazy var managedContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }()
    
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
        tasks = managedContext?.getTasks() ?? []
        applyFilter(filter)
    }
    
    func save(title: String, dueDate: Date, isCompleted: Bool = false) {
        let task = managedContext?.saveTask(title: title, dueDate: dueDate, isCompleted: isCompleted)
        
        guard let t = task else { return }
        setLocalPushNotification(t)
        
        tasks.append(t)
        applyFilter(filter)
    }
    
    fileprivate func setLocalPushNotification(_ task: UserTask) {
        if task.dueDate.isOverdue { return }
        let request = UNNotificationRequest(task: task)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    fileprivate func deleteObject(_ task: UserTask) {
        let id = task.id.uriRepresentation().absoluteString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        
        managedContext?.deleteTask(task)
    }
    
    fileprivate func update(_ task: UserTask) {
        managedContext?.updateTask(task)
        
        if task.isCompleted {
            let id = task.id.uriRepresentation().absoluteString
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        } else if !task.dueDate.isOverdue {
            setLocalPushNotification(task)
        }
    }

}
