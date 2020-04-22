//
//  BaseViewModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import EzPopup

class BaseViewModel {
    
    lazy var networking: Networking = {
        return Networking()
    }()
    
    lazy var preference: Preference = {
        return Preference()
    }()
    
    lazy var constant: Constant = {
        return Constant()
    }()
    
    lazy var screenWidth : CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    lazy var screenHeight : CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    func resetData(navigationController: UINavigationController?) {
        preference.saveBool(value: false, key: constant.IS_LOGIN)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showCustomDialog(destinationVC: UIViewController, navigationController: UINavigationController?) {
        let popupVc = PopupViewController(contentController: destinationVC, popupWidth: screenWidth, popupHeight: screenHeight)
        
        navigationController?.present(popupVc, animated: true)
    }
    
    func showAlertDialog(image: String?, message: String, navigationController: UINavigationController?) {
        let vc = DialogAlert()
        vc.stringDescription = message
        vc.image = image
        
        let popupVc = PopupViewController(contentController: vc, popupWidth: screenWidth, popupHeight: screenHeight)
        navigationController?.present(popupVc, animated: true)
    }
    
    func forceLogout(navigationController: UINavigationController?) {
        let vc = DialogAlert()
        vc.stringDescription = "please_login_again".localize()
        self.showCustomDialog(destinationVC: vc, navigationController: navigationController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData(navigationController: navigationController)
        })
    }
}
