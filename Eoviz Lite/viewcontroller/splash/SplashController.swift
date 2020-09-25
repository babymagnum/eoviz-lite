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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        preference.saveBool(value: true, key: constant.IS_RELEASE)
        
        splashVM.checkVersion(nc: navigationController)
    }
    
    private func setupView() {
        imageLogo.image = UIImage(named: "logo")?.tinted(with: UIColor.white)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}
