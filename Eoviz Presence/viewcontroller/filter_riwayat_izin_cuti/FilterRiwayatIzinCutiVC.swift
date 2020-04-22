//
//  FilterRiwayatIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import FittedSheets

class FilterRiwayatIzinCutiVC: BaseViewController {

    @IBOutlet weak var labelTahun: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var viewTerapkan: CustomGradientView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewTahun: CustomView!
    @IBOutlet weak var viewStatus: CustomView!
    
    @Inject private var filterRiwayatIzinCutiVM: FilterRiwayatIzinCutiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        filterRiwayatIzinCutiVM.resetVariabel()
        
        setupEvent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupEvent() {
        viewTahun.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTahunClick)))
        viewStatus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewStatusClick)))
        viewTerapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTerapkanClick)))
    }
    
    private func observeData() {
        filterRiwayatIzinCutiVM.tahun.subscribe(onNext: { value in
            self.labelTahun.text = value
        }).disposed(by: disposeBag)
        
        filterRiwayatIzinCutiVM.status.subscribe(onNext: { value in
            self.labelStatus.text = value
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension FilterRiwayatIzinCutiVC: BottomSheetPickerProtocol {
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getItem(data: String, id: String) {
        if filterRiwayatIzinCutiVM.typePicker.value == "status" {
            filterRiwayatIzinCutiVM.setStatus(status: data, statusId: Int(id)!)
        } else {
            filterRiwayatIzinCutiVM.setTahun(tahun: data)
        }
    }
    
    @objc func viewTerapkanClick() {
        filterRiwayatIzinCutiVM.applyFilter.accept(true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewStatusClick() {
        filterRiwayatIzinCutiVM.setTypePicker(typePicker: "status")
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.singleArray = filterRiwayatIzinCutiVM.listStatus.value
        vc.singleArrayId = filterRiwayatIzinCutiVM.listStatusId.value
        vc.hasId = true
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.4)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @objc func viewTahunClick() {
        filterRiwayatIzinCutiVM.setTypePicker(typePicker: "tahun")
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.singleArray = filterRiwayatIzinCutiVM.listYears.value
        vc.hasId = false
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.4)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
}
