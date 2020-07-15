//
//  ForgotPasswordEmailVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift
import DIKit

class ForgotPasswordEmailVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var viewSend: CustomGradientView!
    
    @Inject private var forgotPasswordPinVM: ForgotPasswordPinVM
    @Inject private var forgotPasswordEmailVM: ForgotPasswordEmailVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
        fieldEmail.text = "bambang@mailinator.com"
        #endif
        
        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func setupView() {
        enableDisableButtonPermintaan(enable: false)
    }
    
    private func observeData() {
        forgotPasswordEmailVM.isLoading.subscribe(onNext: { value in
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
        fieldEmail.delegate = self
        fieldEmail.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    private func enableDisableButtonPermintaan(enable: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.viewSend.isUserInteractionEnabled = enable
            self.viewSend.startColor = enable ? UIColor.peacockBlue.withAlphaComponent(0.8) : UIColor.lightGray
            self.viewSend.endColor = enable ? UIColor.greyblue.withAlphaComponent(0.8) : UIColor.lightGray
            self.view.layoutIfNeeded()
        }
    }
    
    private func checkInput() {
        if fieldEmail.trim() == "" {
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
        }
        return true
    }
    
    @objc func viewSendClick() {
        forgotPasswordEmailVM.forgetPassword(email: fieldEmail.trim(), nc: navigationController)
    }

    @objc func imageBackClick() {
        navigationController?.popViewController(animated: true)
    }
}
