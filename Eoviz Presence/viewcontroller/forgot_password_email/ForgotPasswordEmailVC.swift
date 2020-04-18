//
//  ForgotPasswordEmailVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class ForgotPasswordEmailVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var viewSend: CustomGradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEvent()
    }

    private func setupEvent() {
        fieldEmail.delegate = self
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

extension ForgotPasswordEmailVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail {
            fieldEmail.resignFirstResponder()
        }
        return true
    }
    
    @objc func viewSendClick() {
        navigationController?.pushViewController(ForgotPasswordPinVC(), animated: true)
    }

    @objc func imageBackClick() {
        navigationController?.popToViewController(ofClass: LoginVC.self)
    }
}
