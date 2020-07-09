//
//  ChangePasswordVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 24/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ChangePasswordVM: BaseViewModel, DialogAlertProtocol {
    
    var hideSandiLama = BehaviorRelay(value: true)
    var hideSandiBaru = BehaviorRelay(value: true)
    var hideConfirmPassword = BehaviorRelay(value: true)
    var isLoading = BehaviorRelay(value: false)
    
    func nextAction(nc: UINavigationController?) {
        nc?.popViewController(animated: true)
    }
    
    func nextAction2(nc: UINavigationController?) {}
    
    func changePassword(old: String, new: String, confirm: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        let body: [String: String] = [
            "old_password": old,
            "new_password": new,
            "retype_new_password": confirm,
        ]
        
        networking.changePassword(body: body) { (error, success, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.showDelegateDialogAlert(isClosable: true, image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: nc)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
}
