//
//  ForgotPasswordVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 26/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ForgotPasswordVM: BaseViewModel, DialogAlertProtocol {
    
    var isLoading = BehaviorRelay(value: false)
    var hideNewPassword = BehaviorRelay(value: true)
    var hideConfirmPassword = BehaviorRelay(value: true)
    
    func nextAction2(nc: UINavigationController?) { }
    
    func nextAction(nc: UINavigationController?) {
        guard let forgotPasswordPinVC = nc?.viewControllers.last(where: { $0.isKind(of: ForgotPasswordEmailVC.self) }) else { return }
        let removedIndex = nc?.viewControllers.lastIndex(of: forgotPasswordPinVC) ?? 0
        
        nc?.viewControllers.remove(at: removedIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            nc?.popViewController(animated: true)
        }
    }
    
    func submitNewPassword(password: String, code: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        let body: [String: String] = [
            "email": preference.getString(key: constant.EMAIL),
            "new_password": password,
            "code": code
        ]
        
        networking.submitNewPassword(body: body) { (error, success, _) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.showDelegateDialogAlert(isClosable: nil, image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: nc)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
}
