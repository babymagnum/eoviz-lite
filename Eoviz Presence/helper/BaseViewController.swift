//
//  BaseViewController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit
import EzPopup
import DIKit

class BaseViewController: UIViewController {
    
    lazy var preference: Preference = {
        return Preference()
    }()
    
    lazy var constant: Constant = {
        return Constant()
    }()
    
    lazy var function: PublicFunction = {
        return PublicFunction()
    }()
    
    lazy var networking: Networking = {
        return Networking()
    }()
    
    lazy var screenWidth : CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    lazy var screenHeight : CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func checkTopMargin(viewRootTopMargin: NSLayoutConstraint) {
        if #available(iOS 11, *) {
            viewRootTopMargin.constant += 0
        } else {
            viewRootTopMargin.constant += UIApplication.shared.statusBarFrame.height
        }
    }
    
    func checkRootHeight(viewRootHeight: NSLayoutConstraint, _ additionHeight: CGFloat, addHeightFor11Above: Bool, addHeightFor11Below: Bool) {
        if #available(iOS 11, *) {
            viewRootHeight.constant += addHeightFor11Above ? additionHeight : 0
        } else {
            viewRootHeight.constant += addHeightFor11Below ? 45 + additionHeight : additionHeight
        }
    }
    
    func addMoreRootHeight(viewRootHeight: NSLayoutConstraint, _ additionHeight: CGFloat) {
        if (UIScreen.main.bounds.width == 320) {
            viewRootHeight.constant += additionHeight + 5
        } else if (UIScreen.main.bounds.width == 375) {
            viewRootHeight.constant += additionHeight + 6
        } else if (UIScreen.main.bounds.width == 414) {
            viewRootHeight.constant += additionHeight + 7
        } else {
            viewRootHeight.constant += additionHeight + 8
        }
    }
    
    func showAlertDialog(description: String) {
        let vc = DialogAlert()
        vc.stringDescription = description
        showCustomDialog(vc, cancelable: true)
    }
    
    func showCustomDialog(_ vc: UIViewController, cancelable: Bool) {
        let popupVc = PopupViewController(contentController: vc, popupWidth: screenWidth, popupHeight: screenHeight)
        self.present(popupVc, animated: true)
    }
    
    func forceLogout(_ navigationController: UINavigationController) {
        DispatchQueue.main.async {
            let vc = DialogAlert()
            vc.stringDescription = "Session anda berakhir, silahkan login kembali untuk melanjutkan."
            self.showCustomDialog(vc, cancelable: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData()
            navigationController.popToRootViewController(animated: true)
        })
    }
    
    func showInDevelopmentDialog() {
        let vc = DialogAlert()
        vc.stringDescription = "Segera Hadir"
        showCustomDialog(vc, cancelable: true)
    }
    
    func resetData() {
        preference.saveBool(value: false, key: constant.IS_LOGIN)
        preference.saveString(value: "", key: constant.TOKEN)
        navigationController?.popToRootViewController(animated: true)
    }
}
