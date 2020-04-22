//
//  FilterRiwayatTukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import FittedSheets

class FilterRiwayatTukarShiftVC: BaseViewController {

    @IBOutlet weak var labelTahun: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var viewTerapkan: CustomGradientView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewTahun: CustomView!
    @IBOutlet weak var viewStatus: CustomView!
    
    @Inject private var filterRiwayatTukarShiftVM: FilterRiwayatTukarShiftVM
    private var disposeBag = DisposeBag()
    private var listYears : [String] {
        var years = [String]()
        let currentYears = Int(PublicFunction.getStringDate(pattern: "yyyy")) ?? 2020
        for i in (2000..<currentYears + 1).reversed() {
            years.append("\(i)")
        }
        return years
    }
    private var listStatus: [String] {
        return ["Semua", "Saved", "Submitted", "Approved", "Canceled", "Rejected"]
    }
    private var listStatusId: [String] {
        return ["1", "2", "3", "4", "5", "6"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        filterRiwayatTukarShiftVM.resetVariabel()
        
        setupEvent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupEvent() {
        viewTahun.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTahunClick)))
        viewStatus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewStatusClick)))
        viewTerapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTerapkanClick)))
    }
    
    private func observeData() {
        filterRiwayatTukarShiftVM.tahun.subscribe(onNext: { value in
            self.labelTahun.text = value
        }).disposed(by: disposeBag)
        
        filterRiwayatTukarShiftVM.status.subscribe(onNext: { value in
            self.labelStatus.text = value
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }

}

extension FilterRiwayatTukarShiftVC: BottomSheetPickerProtocol {
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getItem(data: String, id: String) {
        if filterRiwayatTukarShiftVM.typePicker.value == "status" {
            filterRiwayatTukarShiftVM.setStatus(status: data, statusId: Int(id)!)
        } else {
            filterRiwayatTukarShiftVM.setTahun(tahun: data)
        }
    }
    
    @objc func viewTerapkanClick() {
        filterRiwayatTukarShiftVM.applyFilter.accept(true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewStatusClick() {
        filterRiwayatTukarShiftVM.setTypePicker(typePicker: "status")
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.singleArray = listStatus
        vc.singleArrayId = listStatusId
        vc.hasId = true
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.4)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @objc func viewTahunClick() {
        filterRiwayatTukarShiftVM.setTypePicker(typePicker: "tahun")
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.singleArray = listYears
        vc.hasId = false
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.4)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
}
