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
    
    @objc func textFieldChange(textfield: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.viewSubmit.startColor = self.fieldSandiLama.text?.trim() == "" || self.fieldSandiBaru.text?.trim() == "" || self.fieldUlangiSandiBaru.text?.trim() == "" ? UIColor.lightGray : UIColor.peacockBlue.withAlphaComponent(0.8)
            self.viewSubmit.endColor = self.fieldSandiLama.text?.trim() == "" || self.fieldSandiBaru.text?.trim() == "" || self.fieldUlangiSandiBaru.text?.trim() == "" ? UIColor.lightGray : UIColor.greyblue.withAlphaComponent(0.8)
            self.viewSubmit.isUserInteractionEnabled = !(self.fieldSandiLama.text?.trim() == "" || self.fieldSandiBaru.text?.trim() == "" || self.fieldUlangiSandiBaru.text?.trim() == "")
            self.view.layoutIfNeeded()
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
        if fieldSandiLama.trim() == "" {
            showAlertDialog(image: nil, description: "old_password_is_empty".localize())
        } else if fieldSandiBaru.trim() == "" {
            showAlertDialog(image: nil, description: "new_password_is_empty".localize())
        } else if fieldUlangiSandiBaru.trim() == "" {
            showAlertDialog(image: nil, description: "confirm_new_password_is_empty".localize())
        } else if fieldUlangiSandiBaru.trim() != fieldSandiBaru.trim() {
            showAlertDialog(image: nil, description: "password_not_match".localize())
        } else {
            changePasswordVM.changePassword(old: fieldSandiLama.trim(), new: fieldSandiBaru.trim(), confirm: fieldUlangiSandiBaru.trim(), nc: navigationController)
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
