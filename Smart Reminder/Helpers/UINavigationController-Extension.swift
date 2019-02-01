//
//  UINavigationController-Extension.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 02/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func save(title: String, dueDate: Date) {
        for i in children {
            if let vc = i as? ViewController {
                vc.save(title: title, dueDate: dueDate)
            }
        }
    }
}
