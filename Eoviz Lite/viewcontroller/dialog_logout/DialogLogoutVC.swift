//
//  DialogLogoutVC.swift
//  Eoviz Lite
//
//  Created by Arief Zainuri on 09/07/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

class DialogLogoutVC: BaseViewController {

    @IBOutlet weak var viewKembali: CustomGradientView!
    @IBOutlet weak var viewLogout: CustomGradientView!
    
    @Inject private var provileVM: ProfileVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }

    private func setupEvent() {
        viewKembali.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKembaliClick)))
        viewLogout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewLogoutClick)))
    }
    
    @objc func viewKembaliClick() {
        self.dismiss(animated: true)
    }
    
    @objc func viewLogoutClick() {
        self.dismiss(animated: true)
        provileVM.doLogout.accept(true)
    }
}
