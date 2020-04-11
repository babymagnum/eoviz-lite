//
//  BottomSheetProfilVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class BottomSheetProfilVC: BaseViewController {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var viewAmbilFoto: UIView!
    @IBOutlet weak var viewPilihFoto: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewParent.corners = [.topLeft, .topRight]
        // Do any additional setup after loading the view.
    }

}
