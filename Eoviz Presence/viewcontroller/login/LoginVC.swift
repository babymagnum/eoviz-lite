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
import SVProgressHUD

class LoginVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var fieldPassword: CustomTextField!
    @IBOutlet weak var viewLogin: CustomGradientView!
    
    @Inject var loginVM: LoginVM
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        setupEvent()
    }
    
    private func observeData() {
        loginVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        loginVM.successLogin.subscribe(onNext: { value in
            if value {
                guard let loginVC = self.navigationController?.viewControllers.last(where: { $0.isKind(of: LoginVC.self) }) else { return }
                let index = self.navigationController?.viewControllers.lastIndex(of: loginVC) ?? 0
                
                self.navigationController?.pushViewController(HomeVC(), animated: true)
                
                // remove login controller from viewcontrollers array -> so if user in homeVC they cant swipe back
                self.navigationController?.viewControllers.remove(at: index)
            }
        }).disposed(by: disposeBag)
        
        loginVM.error.subscribe(onNext: { value in
            if value != "" {
                self.showAlertDialog(description: value)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        #if DEBUG
        fieldEmail.text = "bambang@mailinator.com"
        fieldPassword.text = "123456"
        #endif
        
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
            loginVM.login(username: fieldEmail.trim(), password: fieldPassword.trim())
        }
    }
    
    @IBAction func buttonForgotPasswordClick(_ sender: Any) {
        navigationController?.pushViewController(ForgotPasswordVC(), animated: true)
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
