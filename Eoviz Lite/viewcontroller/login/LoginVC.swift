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
    
    @IBOutlet weak var buttonShowHide: UIButton!
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var fieldPassword: CustomTextField!
    @IBOutlet weak var viewLogin: CustomGradientView!
    
    @Inject var loginVM: LoginVM
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetData()
        
        observeData()
        
        setupView()
        
        setupEvent()
    }
    
    private func setupView() {
        enableDisableButtonPermintaan(enable: false)
    }
    
    private func resetData() {
        loginVM.hidePassword.accept(true)
    }
    
    private func observeData() {
        loginVM.hidePassword.subscribe(onNext: { value in
            self.buttonShowHide.setImage(UIImage(named: value ? "invisible" : "visibility")?.tinted(with: UIColor.dark), for: .normal)
            self.fieldPassword.isSecureTextEntry = value
        }).disposed(by: disposeBag)
        
        loginVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                SVProgressHUD.dismiss()
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
        
        fieldEmail.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fieldPassword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        viewLogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewLoginClick)))
    }
    
}

extension LoginVC {
    @IBAction func buttonShowHideClick(_ sender: Any) {
        loginVM.hidePassword.accept(!loginVM.hidePassword.value)
    }
    
    @objc func viewLoginClick() {
        if fieldEmail.trim() == "" {
            PublicFunction.showUnderstandDialog(self, "", "email_is_empty".localize(), "understand".localize())
        } else if fieldPassword.trim() == "" {
            PublicFunction.showUnderstandDialog(self, "", "password_is_empty".localize(), "understand".localize())
        } else {
            loginVM.login(username: fieldEmail.trim(), password: fieldPassword.trim(), navigationController: navigationController)
        }
    }
    
    @IBAction func buttonForgotPasswordClick(_ sender: Any) {
        navigationController?.pushViewController(ForgotPasswordEmailVC(), animated: true)
    }
    
    @IBAction func buttonNewDeviceClick(_ sender: Any) {
        navigationController?.pushViewController(NewDeviceVC(), animated: true)
    }
    
    private func enableDisableButtonPermintaan(enable: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.viewLogin.isUserInteractionEnabled = enable
            self.viewLogin.startColor = enable ? UIColor.peacockBlue.withAlphaComponent(0.8) : UIColor.lightGray
            self.viewLogin.endColor = enable ? UIColor.greyblue.withAlphaComponent(0.8) : UIColor.lightGray
            self.view.layoutIfNeeded()
        }
    }
    
    private func checkInput() {
        if fieldEmail.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else if fieldPassword.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else {
            enableDisableButtonPermintaan(enable: true)
        }
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        checkInput()
    }
    
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
