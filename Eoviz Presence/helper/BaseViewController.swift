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

class BaseViewController: UIViewController {
    
    lazy var imagePicker: ImagePickerManager = { return ImagePickerManager() }()
    
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
    
//    lazy var splashVM: SplashVM = {
//        let container = Container()
//        container.register(SplashVM.self) { (r) -> SplashVM in
//            return SplashVM()
//        }
//        let _splashVM = container.resolve(SplashVM.self)!
//        return _splashVM
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func showCustomDialog(_ vc: UIViewController, _ height: CGFloat, cancelable: Bool) {
        let popupVc = PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width, popupHeight: height)
        self.present(popupVc, animated: true)
    }
    
    func forceLogout(_ navigationController: UINavigationController) {
        DispatchQueue.main.async {
            let vc = DialogAlert()
            vc.stringDescription = "Session anda berakhir, silahkan login kembali untuk melanjutkan."
            self.showCustomDialog(vc, UIScreen.main.bounds.height, cancelable: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData()
            navigationController.popToRootViewController(animated: true)
        })
    }
    
    func showInDevelopmentDialog() {
        let vc = DialogAlert()
        vc.stringDescription = "Segera Hadir"
        showCustomDialog(vc, UIScreen.main.bounds.height, cancelable: true)
    }
    
    func resetData() {
        preference.saveBool(value: false, key: constant.IS_LOGIN)
        preference.saveString(value: "", key: constant.TOKEN)
    }
}
