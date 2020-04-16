//
//  DialogPermintaanTukarShift.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DialogPermintaanTukarShift: BaseViewController {

    @IBOutlet weak var imageAlert: UIImageView!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var viewAction: CustomGradientView!
    @IBOutlet weak var viewBack: CustomGradientView!
    @IBOutlet weak var labelAction: CustomLabel!
    @IBOutlet weak var labelBack: CustomLabel!
    
    var isApprove: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
    }

    private func setupEvent() {
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBackClick)))
    }
    
    private func setupView() {
        imageAlert.image = UIImage(named: isApprove ? "alertTerimaPermintaan" : "alertError24Px")
        labelBack.text = "back".localize()
        labelAction.text = isApprove ? "accept".localize() : "refuse".localize()
        labelContent.text = isApprove ? "approve_change_shift".localize() : "reject_change_shift".localize()
        viewAction.startColor = isApprove ? UIColor.nastyGreen : UIColor.rustRed
        viewAction.endColor = isApprove ? UIColor.paleOliveGreen : UIColor.pastelRed
    }
}

extension DialogPermintaanTukarShift {
    @objc func viewBackClick() {
        
    }
    
    @objc func viewActionClick() {
        
    }
}
