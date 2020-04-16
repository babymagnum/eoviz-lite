//
//  DetailPengajuanTukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DetailPengajuanTukarShiftVC: BaseViewController {

    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDiajukanPada: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var labelNamaPengaju: CustomLabel!
    @IBOutlet weak var labelUnitKerjaPengaju: CustomLabel!
    @IBOutlet weak var labelTanggalShiftPengaju: CustomLabel!
    @IBOutlet weak var labelAlasanPengaju: CustomLabel!
    @IBOutlet weak var imagePengaju: CustomImage!
    @IBOutlet weak var imagePengganti: CustomImage!
    @IBOutlet weak var labelNamaPengganti: CustomLabel!
    @IBOutlet weak var labelUnitKerjaPengganti: CustomLabel!
    @IBOutlet weak var labelTanggalShiftPengganti: CustomLabel!
    @IBOutlet weak var labelNamaInfoPengaju: CustomLabel!
    @IBOutlet weak var labelDateInfoPengaju: CustomLabel!
    @IBOutlet weak var imageStatusInfoPengaju: UIImageView!
    @IBOutlet weak var labelStatusInfoPengaju: CustomLabel!
    @IBOutlet weak var labelNamaInfoPengganti: CustomLabel!
    @IBOutlet weak var labelDateInfoPengganti: CustomLabel!
    @IBOutlet weak var imageStatusInfoPengganti: UIImageView!
    @IBOutlet weak var labelStatusInfoPengganti: CustomLabel!
    @IBOutlet weak var viewAction: CustomGradientView!
    @IBOutlet weak var viewParent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
    }

    private func setupEvent() {
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
    }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension DetailPengajuanTukarShiftVC {
    @objc func viewActionClick() {
        
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
