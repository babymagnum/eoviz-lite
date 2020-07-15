//
//  ForgotPasswordPinVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD
import Toast_Swift

class ForgotPasswordPinVC: BaseViewController {

    var expiredToken: Int?
    
    @IBOutlet weak var fieldPin1: CustomTextField!
    @IBOutlet weak var fieldPin2: CustomTextField!
    @IBOutlet weak var fieldPin3: CustomTextField!
    @IBOutlet weak var fieldPin4: CustomTextField!
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var viewSubmit: CustomGradientView!
    @IBOutlet weak var labelTimer: CustomLabel!
    
    @Inject private var forgotPasswordPinVM: ForgotPasswordPinVM
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        forgotPasswordPinVM.startTimer(expiredTime: expiredToken ?? 0, nc: navigationController)
        
        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func setupView() {
        enableDisableButtonPermintaan(enable: false)
    }
    
    private func observeData() {
        forgotPasswordPinVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        forgotPasswordPinVM.time.subscribe(onNext: { value in
            self.labelTimer.text = value
        }).disposed(by: disposeBag)
    }

    private func setupEvent() {
        fieldPin1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fieldPin2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fieldPin3.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fieldPin4.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageBackClick)))
        viewSubmit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSubmitClick)))
        observeTextField(focusTextField: fieldPin1, nextTextField: fieldPin2, beforeTextField: nil, isLast: false)
        observeTextField(focusTextField: fieldPin2, nextTextField: fieldPin3, beforeTextField: fieldPin1, isLast: false)
        observeTextField(focusTextField: fieldPin3, nextTextField: fieldPin4, beforeTextField: fieldPin2, isLast: false)
        observeTextField(focusTextField: fieldPin4, nextTextField: nil, beforeTextField: fieldPin3, isLast: true)
    }
    
    private func observeTextField(focusTextField: CustomTextField, nextTextField: CustomTextField?, beforeTextField: CustomTextField?, isLast: Bool) {
        focusTextField.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: { _ in
            if focusTextField.trim().count > 1 { focusTextField.text = "\(Array(focusTextField.text!)[1])" }
            
            if focusTextField.trim().count == 1 {
                focusTextField.resignFirstResponder()
                nextTextField?.becomeFirstResponder()
            } else {
                focusTextField.resignFirstResponder()
                beforeTextField?.becomeFirstResponder()
            }
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension ForgotPasswordPinVC {
    private func enableDisableButtonPermintaan(enable: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.viewSubmit.isUserInteractionEnabled = enable
            self.viewSubmit.startColor = enable ? UIColor.peacockBlue.withAlphaComponent(0.8) : UIColor.lightGray
            self.viewSubmit.endColor = enable ? UIColor.greyblue.withAlphaComponent(0.8) : UIColor.lightGray
            self.view.layoutIfNeeded()
        }
    }
    
    private func checkInput() {
        if fieldPin1.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else if fieldPin2.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else if fieldPin3.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else if fieldPin4.trim() == "" {
            enableDisableButtonPermintaan(enable: false)
        } else {
            enableDisableButtonPermintaan(enable: true)
        }
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        checkInput()
    }
    
    @objc func viewSubmitClick() {
        let code = "\(fieldPin1.trim())\(fieldPin2.trim())\(fieldPin3.trim())\(fieldPin4.trim())"
        
        forgotPasswordPinVM.submitVerificationCode(code: code, nc: navigationController)
    }
    
    @objc func imageBackClick() {
        //navigationController?.popToViewController(ofClass: LoginVC.self)
        navigationController?.popViewController(animated: true)
    }
}
