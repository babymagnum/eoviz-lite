//
//  SplashController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class SplashController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    @Inject var splashVM: SplashVM
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        splashVM.setTest(value: "splash")
        
        splashVM.test.subscribe { (event) in
            print("test value \(event.element ?? "")")
        }.disposed(by: disposeBag)
        
        preference.saveBool(value: true, key: constant.IS_RELEASE)
        
        changeScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func changeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.pushViewController(LoginVC(), animated: true)
//            if !self.preference.getBool(key: self.staticLet.IS_FIRST_TIME_OPEN) {
//                self.navigationController?.pushViewController(OnboardingController(), animated: true)
//            } else if !self.preference.getBool(key: self.staticLet.IS_LOGIN) {
//                self.navigationController?.pushViewController(LoginController(), animated: true)
//            } else {
//                self.navigationController?.pushViewController(HomeController(), animated: true)
//            }
        }
    }

}
