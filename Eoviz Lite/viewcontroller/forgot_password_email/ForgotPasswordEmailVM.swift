//
//  ForgotPasswordEmailVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 26/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ForgotPasswordEmailVM: BaseViewModel {
    
    var isLoading = BehaviorRelay(value: false)
    
    func forgetPassword(email: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.forgetPassword(email: email) { (error, forgotPassword, _) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _forgotPassword = forgotPassword else { return }
            
            if _forgotPassword.status {
                self.preference.saveString(value: email, key: self.constant.EMAIL)
                
                let vc = ForgotPasswordPinVC()
                vc.expiredToken = _forgotPassword.data?.expired_token
                nc?.pushViewController(vc, animated: true)
                //self.showDelegateDialogAlert(isClosable: nil, image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: nc)
            } else {
                self.showAlertDialog(image: nil, message: _forgotPassword.messages[0], navigationController: nc)
            }
        }
    }
}
