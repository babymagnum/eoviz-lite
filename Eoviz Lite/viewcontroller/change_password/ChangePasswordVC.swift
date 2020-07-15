//
//  ChangePasswordVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import SVProgressHUD
import RxSwift

class ChangePasswordVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var buttonSecureConfirmPassword: UIButton!
    @IBOutlet weak var buttonSecureSandiBaru: UIButton!
    @IBOutlet weak var buttonSecureSandiLama: UIButton!
    @IBOutlet weak var fieldSandiLama: CustomTextField!
    @IBOutlet weak var fieldSandiBaru: CustomTextField!
    @IBOutlet weak var fieldUlangiSandiBaru: CustomTextField!
    @IBOutlet weak var viewSubmit: CustomGradientView!
    @IBOutlet weak var viewParent: CustomView!
    
    @Inject private var changePasswordVM: ChangePasswordVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetData()
        
        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func resetData() {
        changePasswordVM.hideSandiBaru.accept(true)
        changePasswordVM.hideSandiLama.accept(true)
        changePasswordVM.hideConfirmPassword.accept(true)
    }
    
    private func observeData() {
        changePasswordVM.hideSandiLama.subscribe(onNext: { value in
            self.buttonSecureSandiLama.setImage(UIImage(named: value ? "invisible" : "visibility")?.tinted(with: UIColor.dark), for: .normal)
            self.fieldSandiLama.isSecureTextEntry = value
        }).disposed(by: disposeBag)
        
        changePasswordVM.hideSandiBaru.subscribe(onNext: { value in
            self.buttonSecureSandiBaru.setImage(UIImage(named: value ? "invisible" : "visibility")?.tinted(with: UIColor.dark), for: .normal)
            self.fieldSandiBaru.isSecureTextEntry = value
        }).disposed(by: disposeBag)
        
        changePasswordVM.hideConfirmPassword.subscribe(onNext: { value in
            self.buttonSecureConfirmPassword.setImage(UIImage(named: value ? "invisible" : "visibility")?.tinted(with: UIColor.dark), for: .normal)
            self.fieldUlangiSandiBaru.isSecureTextEntry = value
        }).disposed(by: disposeBag)
        
        changePasswordVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        fieldSandiLama.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        fieldSandiBaru.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        fieldUlangiSandiBaru.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        viewSubmit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSubmitClick)))
    }

    private func setupView() {
        viewSubmit.startColor = UIColor.lightGray
        viewSubmit.endColor = UIColor.lightGray
        viewSubmit.isUserInteractionEnabled = false
        self.view.layoutIfNeeded()
        
        fieldSandiLama.delegate = self
        fieldSandiBaru.delegate = self
        fieldUlangiSandiBaru.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension ChangePasswordVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldSandiLama {
            fieldSandiLama.resignFirstResponder()
            fieldSandiBaru.becomeFirstResponder()
        } else if textField == fieldSandiBaru {
            fieldSandiBaru.resignFirstResponder()
            fieldUlangiSandiBaru.becomeFirstResponder()
        } else {
            fieldUlangiSandiBaru.resignFirstResponder()
        }
        return true
    }
    
    private func enableDisableButton(enable: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.viewSubmit.startColor = enable ? UIColor.peacockBlue.withAlphaComponent(0.8) : UIColor.lightGray
            self.viewSubmit.endColor = enable ? UIColor.greyblue.withAlphaComponent(0.8) : UIColor.lightGray
            self.viewSubmit.isUserInteractionEnabled = enable
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldChange(textfield: UITextField) {
        if fieldSandiLama.trim() == "" {
            enableDisableButton(enable: false)
        } else if fieldSandiBaru.trim() == "" {
            enableDisableButton(enable: false)
        } else if fieldUlangiSandiBaru.trim() == "" {
            enableDisableButton(enable: false)
        } else {
            enableDisableButton(enable: true)
        }
    }
    
    @IBAction func buttonSecureConfirmPasswordClick(_ sender: Any) {
        changePasswordVM.hideConfirmPassword.accept(!changePasswordVM.hideConfirmPassword.value)
    }
    
    @IBAction func buttonSecureSandiBaruClick(_ sender: Any) {
        changePasswordVM.hideSandiBaru.accept(!changePasswordVM.hideSandiBaru.value)
    }
    
    @IBAction func buttonSecureSandiLamaClick(_ sender: Any) {
        changePasswordVM.hideSandiLama.accept(!changePasswordVM.hideSandiLama.value)
    }
    
    @objc func viewSubmitClick() {
        changePasswordVM.changePassword(old: fieldSandiLama.trim(), new: fieldSandiBaru.trim(), confirm: fieldUlangiSandiBaru.trim(), nc: navigationController)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
