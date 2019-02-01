//
//  PictureSourceAlertController.swift
//  Smart Reminder
//
//  Created by Mustafa Yusuf on 02/02/19.
//  Copyright © 2019 Mustafa Yusuf. All rights reserved.
//

import UIKit

protocol PictureSourceDelegate: class {
    func pictureSource(_  source: UIImagePickerController.SourceType)
}

class PictureSourceAlertController: UIAlertController {

    weak var delegate: PictureSourceDelegate?
    
    lazy var cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    lazy var camera = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
        self?.delegate?.pictureSource(.camera)
        self?.dismiss(animated: true, completion: nil)
    })
    
    lazy var gallery = UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
        self?.delegate?.pictureSource(.photoLibrary)
        self?.dismiss(animated: true, completion: nil)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addAction(cancel)
        addAction(gallery)
        addAction(camera)
    }
}
