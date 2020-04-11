//
//  LoginVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class LoginVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var fieldPassword: CustomTextField!
    @IBOutlet weak var viewLogin: CustomGradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }
    
    private func setupEvent() {
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        viewLogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewLoginClick)))
    }
    
    @objc func viewLoginClick() {
        if fieldEmail.trim() == "" {
            PublicFunction.showUnderstandDialog(self, "", "email_is_empty".localize(), "understand".localize())
        } else if fieldPassword.trim() == "" {
            PublicFunction.showUnderstandDialog(self, "", "password_is_empty".localize(), "understand".localize())
        } else {
            preference.saveBool(value: true, key: constant.IS_LOGIN)
            navigationController?.pushViewController(HomeVC(), animated: true)
        }
    }
    
    @IBAction func buttonForgotPasswordClick(_ sender: Any) {
        navigationController?.pushViewController(ForgotPasswordVC(), animated: true)
        
//        preference.saveString(value: constant.ENGLISH, key: constant.LANGUAGE)
//        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonNewDeviceClick(_ sender: Any) {
        navigationController?.pushViewController(NewDeviceVC(), animated: true)
    }
}

extension LoginVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail {
            fieldEmail.resignFirstResponder()
            fieldPassword.becomeFirstResponder()
        } else {
            fieldPassword.resignFirstResponder()
        }
        
        return true
    }
}
