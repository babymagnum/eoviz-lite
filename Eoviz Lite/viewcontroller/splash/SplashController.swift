//
//  SplashController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

class SplashController: BaseViewController {
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    @Inject private var splashVM: SplashVM
    
    func getCurrentTimeZone() -> String {
        let localTimeZoneAbbreviation: Int = TimeZone.current.secondsFromGMT()
        let items = (localTimeZoneAbbreviation / 3600)
        return "\(items)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("current timezone \(TimeZone.current.identifier)")
        print("another timezone \(getCurrentTimeZone())")
        print("another timezone1 \(TimeZone.current.localizedName(for: .shortStandard, locale: .current) ?? "")")
        
        setupView()
        
        preference.saveBool(value: true, key: constant.IS_RELEASE)
        
        splashVM.checkVersion(nc: navigationController)
    }
    
    private func setupView() {
        imageLogo.image = UIImage(named: "logo")?.tinted(with: UIColor.white)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}
