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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.windowsBlue
        
        return refreshControl
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
    
    func addBlurView(view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 1
        view.addSubview(blurEffectView)
    }
    
    func removeBlurView(view: UIView) {
        let viewTag = view.viewWithTag(1)
        viewTag?.removeFromSuperview()
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
        popupVc.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        popupVc.backgroundAlpha = 0.1
        self.present(popupVc, animated: true)
    }
    
    func forceLogout(_ navigationController: UINavigationController) {
        let vc = DialogAlert()
        vc.stringDescription = "please_login_again".localize()
        self.showCustomDialog(vc, cancelable: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData()
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        _handleRefresh(refreshControl: refreshControl)
    }
    
    func _handleRefresh(refreshControl: UIRefreshControl) {}
}
