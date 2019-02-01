//
//  Classifier.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 01/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import Foundation

struct Classifier: Decodable {
    let payload: [String: ClassifierObject]
}

struct ClassifierObject: Decodable {
    let suggestions: [String]
}
