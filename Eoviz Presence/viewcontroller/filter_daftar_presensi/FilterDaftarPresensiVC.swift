//
//  FilterDaftarPresensiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import DIKit
import RxSwift

class FilterDaftarPresensiVC: BaseViewController {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewBulan: CustomView!
    @IBOutlet weak var viewTahun: CustomView!
    @IBOutlet weak var labelBulan: CustomLabel!
    @IBOutlet weak var labelTahun: CustomLabel!
    @IBOutlet weak var viewTerapkan: CustomGradientView!
    
    private var disposeBag = DisposeBag()
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
        
        filterDaftarPresensiVM.resetBulanTahun()
    }
    
    private func observeData() {
        filterDaftarPresensiVM.bulan.subscribe(onNext: { value in
            self.labelBulan.text = value == "" ? PublicFunction.getStringDate(pattern: "MMMM") : value
        }).disposed(by: disposeBag)
        
        filterDaftarPresensiVM.tahun.subscribe(onNext: { value in
            self.labelTahun.text = value == "" ? PublicFunction.getStringDate(pattern: "yyyy") : value
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewBulan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBulanClick)))
        viewTahun.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTahunClick)))
        viewTerapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTerapkanClick)))
    }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension FilterDaftarPresensiVC: BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String) {
        filterDaftarPresensiVM.updateBulanTahun(fullDate: formatedDate)
    }
    
    func pickTime(pickedTime: String) { }
    
    private func openDatePicker() {
        let vc = BottomSheetDatePickerVC()
        vc.delegate = self
        vc.picker = .date
        vc.isBackDate = true
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.5)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTerapkanClick() {
        filterDaftarPresensiVM.applyFilter.accept(true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTahunClick() {
        openDatePicker()
    }
    
    @objc func viewBulanClick() {
        openDatePicker()
    }
}
