//
//  HomeVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import EzPopup

class HomeVC: UITabBarController {

    @IBOutlet weak var bottomNavigationBar: UITabBar!
    
    lazy var preference: Preference = { return Preference() }()
    lazy var constant: Constant = { return Constant() }()
    
    // properties
    private var currentPage = 0
    private var totalPage = 0
    private var hasNotif = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBottomNavigation()
        
        getNotificationList()
    }
    
    func forceLogout() {
        let vc = DialogAlert()
        vc.stringDescription = "Session anda berakhir, silahkan login kembali untuk melanjutkan."
        present(PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width, popupHeight: UIScreen.main.bounds.height), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData()
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func resetData() {
        preference.saveBool(value: false, key: constant.IS_LOGIN)
        preference.saveString(value: "", key: constant.TOKEN)
    }
    
    private func getNotificationList() {
        
    }
    
    private func checkNotifIcon(isSelected: Bool) -> UIImage? {
        if hasNotif {
            if isSelected {
                return UIImage(named: "hasNotifikasi")?.tinted(with: UIColor.init(hexString: "347eb2"))!
            } else {
                return UIImage(named: "hasNotifikasi")?.tinted(with: UIColor.init(hexString: "253644"))!
            }
        } else {
            if isSelected {
                return UIImage(named: "notifikasi")?.tinted(with: UIColor.init(hexString: "347eb2"))!
            } else {
                return UIImage(named: "notifikasi")?.tinted(with: UIColor.init(hexString: "253644"))!
            }
        }
    }
    
    private func setTabbarItem() {
        let berandaVC = BerandaVC()
        let approvalVC = ApprovalVC()
        let notificationVC = NotificationVC()
        let profileVC = ProfileVC()
        viewControllers = [berandaVC, approvalVC, notificationVC, profileVC]
        berandaVC.tabBarItem = UITabBarItem(title: "home".localize(), image: UIImage(named: "home")?.tinted(with: UIColor.init(hexString: "253644")), selectedImage: UIImage(named: "home")?.tinted(with: UIColor.init(hexString: "347eb2")))
        approvalVC.tabBarItem = UITabBarItem(title: "approval".localize(), image: UIImage(named: "persetujuan")?.tinted(with: UIColor.init(hexString: "253644")), selectedImage: UIImage(named: "persetujuan")?.tinted(with: UIColor.init(hexString: "347eb2")))
        notificationVC.tabBarItem = UITabBarItem(title: "notification".localize(), image: checkNotifIcon(isSelected: false), selectedImage: checkNotifIcon(isSelected: true))
        profileVC.tabBarItem = UITabBarItem(title: "profile".localize(), image: UIImage(named: "profil")?.tinted(with: UIColor.init(hexString: "253644")), selectedImage: UIImage(named: "profil")?.tinted(with: UIColor.init(hexString: "347eb2")))
        
        setViewControllers(viewControllers, animated: true)
    }
    
    private func initBottomNavigation() {
        UITabBar.appearance().tintColor = UIColor.windowsBlue
        UITabBar.appearance().backgroundColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.dark
        tabBar.addShadow(CGSize(width: 2, height: 4), UIColor.black.withAlphaComponent(0.5), 4, 1)
        tabBar.roundCorners([.topLeft, .topRight], radius: 15)
        
        self.delegate = self
        
        setTabbarItem()
    }

}

extension HomeVC: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (tabBar.items)![0] {
        } else if item == (tabBar.items)![1] {
            self.selectedIndex = 1
        } else if item == (tabBar.items)![2] {
            self.selectedIndex = 2
        } else if item == (tabBar.items)![3] {
            self.selectedIndex = 3
        }
    }
}
