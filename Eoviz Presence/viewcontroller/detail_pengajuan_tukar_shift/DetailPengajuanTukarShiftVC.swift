//
//  DetailPengajuanTukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DetailPengajuanTukarShiftVC: BaseViewController {

    @IBOutlet weak var viewCatatan: UIView!
    @IBOutlet weak var viewCatatanHeight: NSLayoutConstraint!
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
    @IBOutlet weak var viewActionHeight: CustomMargin!
    @IBOutlet weak var viewActionMarginTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
    }

    private func setupEvent() {
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        if Bool.random() {
            // hide the view action
            self.viewAction.isHidden = true
            self.viewActionHeight.multi = 0
            self.viewActionMarginTop.constant = 0
        } else {
            // hide the view catatan
            self.viewCatatan.isHidden = true
            self.viewCatatanHeight.constant = 0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension DetailPengajuanTukarShiftVC {
    @objc func viewActionClick() {
        showCustomDialog(DialogBatalkanTukarShiftVC())
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
