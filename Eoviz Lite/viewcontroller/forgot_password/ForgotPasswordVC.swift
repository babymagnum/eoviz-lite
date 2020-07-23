//
//  ForgotPasswordVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import SVProgressHUD
import RxSwift
import Toast_Swift

class ForgotPasswordVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldNewPassword: CustomTextField!
    @IBOutlet weak var fieldConfirmPassword: CustomTextField!
    @IBOutlet weak var viewSend: CustomGradientView!
    @IBOutlet weak var buttonShowHideNewPassword: UIButton!
    @IBOutlet weak var buttonShowHideConfirmPassword: UIButton!
    
    @Inject private var forgotPasswordVM: ForgotPasswordVM
    private var disposeBag = DisposeBag()
    
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func setupView() {
        enableDisableButtonPermintaan(enable: false)
    }
    
    private func observeData() {
        forgotPasswordVM.hideNewPassword.subscribe(onNext: { value in
            self.buttonShowHideNewPassword.setImage(UIImage(named: value ? "invisible" : "visibility")?.tinted(with: UIColor.dark), for: .normal)
            self.fieldNewPassword.isSecureTextEntry = value
        }).disposed(by: disposeBag)
        
        forgotPasswordVM.hideConfirmPassword.subscribe(onNext: { value in
            self.buttonShowHideConfirmPassword.setImage(UIImage(named: value ? "invisible" : "visibility")?.tinted(with: UIColor.dark), for: .normal)
            self.fieldConfirmPassword.isSecureTextEntry = value
        }).disposed(by: disposeBag)
        
        forgotPasswordVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        fieldNewPassword.delegate = self
        fieldConfirmPassword.delegate = self
        fieldNewPassword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fieldConfirmPassword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    private func enableDisableButtonPermintaan(enable: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.viewSend.isUserInteractionEnabled = enable
            self.viewSend.startColor = enable ? UIColor.peacockBlue.withAlphaComponent(0.8) : UIColor.lightGray
            self.viewSend.endColor = enable ? UIColor.greyblue.withAlphaComponent(0.8) : UIColor.lightGray
            self.view.layoutIfNeeded()
        }
    }
    
    private func checkInput() {
        if fieldNewPassword.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else if fieldConfirmPassword.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else {
            enableDisableButtonPermintaan(enable: true)
        }
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        checkInput()
    }
    
    @IBAction func showHideConfirmPasswordClick(_ sender: Any) {
        forgotPasswordVM.hideConfirmPassword.accept(!forgotPasswordVM.hideConfirmPassword.value)
    }
    
    @IBAction func showHideNewPasswordClick(_ sender: Any) {
        forgotPasswordVM.hideNewPassword.accept(!forgotPasswordVM.hideNewPassword.value)
    }
    
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
        if fieldNewPassword.text?.trim() != fieldConfirmPassword.text?.trim() {
            showAlertDialog(image: nil, description: "password_didnt_match".localize())
        } else {
            forgotPasswordVM.submitNewPassword(password: fieldNewPassword.trim(), code: code ?? "", nc: navigationController)
        }
    }
    
    @objc func imageBackClick() {
        navigationController?.popViewController(animated: true)
    }
}
