//
//  UNNotificationRequest-Extension.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 02/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UserNotifications

extension UNNotificationRequest {
    
    convenience init(task: UserTask) {
        let content = UNMutableNotificationContent()
        content.title = "Smart Reminder Alert"
        content.body = task.title
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let timeInterval = task.dueDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let requestID = task.id.uriRepresentation().absoluteString
        self.init(identifier: requestID, content: content, trigger: trigger)
    }
}
