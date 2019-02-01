//
//  ViewController.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableDataSource = ReminderDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = tableDataSource
        tableView.delegate = self
    }
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableDataSource.applyFilter(.pending)
        case 1:
            tableDataSource.applyFilter(.overdue)
        case 2:
            tableDataSource.applyFilter(.completed)
        default:
            fatalError()
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tableDataSource.task(at: indexPath)
        let alert = TaskActionController(isCompleted: task.isCompleted, for: indexPath)
        alert.delegate = self
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: TaskActionSheetDelegate {
    
    func taskAction(_ action: TaskAction, _ indexPath: IndexPath) {
        switch action {
        case .markCompleted:
            tableDataSource.update(at: indexPath, isCompleted: true)
        case .markIncomplete:
            tableDataSource.update(at: indexPath, isCompleted: false)
        case .delete:
            tableDataSource.delete(at: indexPath)
        case .cancel:
            return
        }
        tableView.reloadData()
    }
}

extension ViewController {
    
    func save(title: String, dueDate: Date) {
        tableDataSource.save(title: title, dueDate: dueDate)
        tableView.reloadData()
    }
}
