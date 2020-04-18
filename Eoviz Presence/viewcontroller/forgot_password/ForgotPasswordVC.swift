//
//  ForgotPasswordVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldNewPassword: CustomTextField!
    @IBOutlet weak var fieldConfirmPassword: CustomTextField!
    @IBOutlet weak var viewSend: CustomGradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }
    
    private func setupEvent() {
        fieldNewPassword.delegate = self
        fieldConfirmPassword.delegate = self
        viewSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSendClick)))
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageBackClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension ForgotPasswordVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldNewPassword {
            fieldNewPassword.resignFirstResponder()
            fieldConfirmPassword.becomeFirstResponder()
        } else {
            fieldConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    @objc func viewSendClick() {
        navigationController?.pushViewController(ForgotPasswordEmailVC(), animated: true)
    }
    
    @objc func imageBackClick() {
        navigationController?.popViewController(animated: true)
    }
}
