//
//  JSONDecoder-Extension.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 02/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    func getClassifier(for object: String) -> ClassifierObject? {
        guard let urlString = Bundle.main.path(forResource: "Classifier", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: urlString)
        do {
            let data = try Data(contentsOf: url)
            let result = try self.decode(Classifier.self, from: data)
            guard let recommended = result.payload[object] else { return nil }
            return recommended
        } catch {
            print(error)
        }
        return nil
    }
}
