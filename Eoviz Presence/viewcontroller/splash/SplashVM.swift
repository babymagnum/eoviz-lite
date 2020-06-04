//
//  SplashVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SplashVM: BaseViewModel, DialogAlertProtocol {
    
    private var connectionError = false
    
    func nextAction(nc: UINavigationController?) {
        if connectionError {
            checkVersion(nc: nc)
        } else {
            if let url = URL(string: "https://apps.apple.com/id/app/id1509171571"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func nextAction2(nc: UINavigationController?) { }
    
    func checkVersion(nc: UINavigationController?) {
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
        networking.checkVersion(currentVersion: version) { (error, checkVersion, isExpired) in
            
            if let _error = error {
                let isConnectionError = _error == self.constant.CONNECTION_ERROR
                self.connectionError = isConnectionError
                self.showDelegateDialogAlert(isClosable: isConnectionError, image: nil, delegate: self, content: _error, nc: nc)
                return
            }
            
            guard let _checkVersion = checkVersion else { return }
            
            if _checkVersion.data?.must_update ?? false {
                self.showDelegateDialogAlert(isClosable: false, image: nil, delegate: self, content: _checkVersion.messages[0], nc: nc)
            } else {
                self.changeScreen(nc: nc)
            }
        }
    }
    
    private func changeScreen(nc: UINavigationController?) {
        let isLogin = preference.getBool(key: constant.IS_LOGIN)
        
        if isLogin {
            nc?.pushViewController(HomeVC(), animated: true)
        } else {
            nc?.pushViewController(LoginVC(), animated: true)
        }
    }
}
