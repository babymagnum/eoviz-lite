//
//  ForgotPasswordPinVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 26/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ForgotPasswordPinVM: BaseViewModel, DialogAlertProtocol {
    
    var isLoading = BehaviorRelay(value: false)
    var time = BehaviorRelay(value: "")
    
    private var minutes = 3
    private var seconds = 1
    private var timer: Timer?
    
    func startTimer(expiredTime: Int, nc: UINavigationController?) {
        if let _timer = timer { _timer.invalidate() }
        
        let allSeconds = expiredTime / 1000
        
        minutes = allSeconds / 60
        seconds = allSeconds % 60 == 0 ? 1 : allSeconds % 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.seconds -= 1
            
            let time = "\(String(self.minutes).count == 1 ? "0\(self.minutes)" : "\(String(self.minutes))"):\(String(self.seconds).count == 1 ? "0\(self.seconds)" : "\(String(self.seconds))")"
            
            self.time.accept(time)
            
            if self.minutes >= 1 && self.seconds == 0 {
                self.minutes -= 1
                self.seconds = 60
            }
            
            if self.minutes == 0 && self.seconds == 0 {
                timer.invalidate()
                self.minutes = 0
                self.seconds = 0
                
                let time = "\(String(self.minutes).count == 1 ? "0\(self.minutes)" : "\(String(self.minutes))"):\(String(self.seconds).count == 1 ? "0\(self.seconds)" : "\(String(self.seconds))")"
                
                self.time.accept(time)
                nc?.popViewController(animated: true)
            }
        }
    }
    
    func nextAction2(nc: UINavigationController?) { }
    
    func nextAction(nc: UINavigationController?) {
        
    }
    
    func submitVerificationCode(code: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        let body: [String: String] = [
            "email": preference.getString(key: constant.EMAIL),
            "code": code
        ]
        
        networking.submitCodeForgetPassword(body: body) { (error, success, _) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                guard let forgotPasswordPinVC = nc?.viewControllers.last(where: { $0.isKind(of: ForgotPasswordPinVC.self) }) else { return }
                let removedIndex = nc?.viewControllers.lastIndex(of: forgotPasswordPinVC) ?? 0
                
                let destinationVC = ForgotPasswordVC()
                destinationVC.code = code
                nc?.pushViewController(destinationVC, animated: true)
                
                nc?.viewControllers.remove(at: removedIndex)
                //self.showDelegateDialogAlert(isClosable: nil, image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: nc)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
}
