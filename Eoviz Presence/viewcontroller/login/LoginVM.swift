//
//  LoginVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import DIKit
import RxRelay

class LoginVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    var error = BehaviorRelay(value: "")
    var successLogin = BehaviorRelay(value: false)
    
    func login(username: String, password: String) {
        isLoading.accept(true)
        
        networking.login(username: username, password: password) { (error, login, _) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.error.accept(_error)
                return
            }
            
            if let _login = login {
                if _login.status {
                    if let _data = _login.data {
                        self.preference.saveString(value: _data.token, key: self.constant.TOKEN)
                        self.preference.saveString(value: _data.emp_lang, key: self.constant.LANGUAGE)
                        self.preference.saveBool(value: true, key: self.constant.IS_LOGIN)
                        self.successLogin.accept(true)
                    }
                } else {
                    self.error.accept(_login.messages[0])
                }
            }
        }
    }
    
}
