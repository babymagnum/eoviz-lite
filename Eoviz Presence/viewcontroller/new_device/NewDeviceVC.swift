//
//  NewDeviceVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class NewDeviceVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var fieldPassword: CustomTextField!
    @IBOutlet weak var viewRequest: CustomGradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }

    private func setupEvent() {
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageBackClick)))
    }
}

extension NewDeviceVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail {
            fieldEmail.resignFirstResponder()
            fieldPassword.becomeFirstResponder()
        } else {
            fieldPassword.resignFirstResponder()
        }
        return true
    }
    
    @objc func imageBackClick() {
        navigationController?.popViewController(animated: true)
    }
}
