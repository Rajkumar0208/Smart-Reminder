//
//  Date-Extension.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import Foundation

extension Date {
    
    var readableDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
    
    var isOverdue: Bool {
        return Date().compare(self) == .orderedDescending
    }
}
