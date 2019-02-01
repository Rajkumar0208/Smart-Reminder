//
//  CIImage-Extension.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 02/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Vision
import CoreML

extension CIImage {
    
    func recogniseImage(_ completion: @escaping (_ object: ClassifierObject?) -> Void) {
        if let model = try? VNCoreMLModel(for: ImageClassifier().model) {
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] vnrequest, error in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    let topResult = results.first
                    let confidenceRate = (topResult?.confidence)! * 100
                    let rounded = Int(confidenceRate * 100) / 100
                    let text = topResult?.identifier ?? "Anonymous"
                    if rounded < 90 {
                        completion(nil)
                    } else {
                        completion(self?.imageResult(detected: text))
                    }
                }
            })
            let handler = VNImageRequestHandler(ciImage: self)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Err :(", error)
                }
            }
        }
    }
    
    fileprivate func imageResult(detected object: String?) -> ClassifierObject? {
        guard let obj = object, let classfiedObj = JSONDecoder().getClassifier(for: obj) else {
            return nil
        }
        return classfiedObj
    }
    
}
