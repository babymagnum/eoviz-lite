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
import SVProgressHUD

protocol FilterDaftarPresensiProtocol {
    func applyFilter()
}

class FilterDaftarPresensiVC: BaseViewController {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewBulan: CustomView!
    @IBOutlet weak var viewTahun: CustomView!
    @IBOutlet weak var labelBulan: CustomLabel!
    @IBOutlet weak var labelTahun: CustomLabel!
    @IBOutlet weak var viewTerapkan: CustomGradientView!
    @IBOutlet weak var viewReset: CustomGradientView!
    
    var delegate: FilterDaftarPresensiProtocol?
    
    private var filterBulan = false
    private var disposeBag = DisposeBag()
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        
        observeData()
        
        getData()
    }
    
    private func getData() {
        if filterDaftarPresensiVM.listBulan.value.count == 0 || filterDaftarPresensiVM.listTahun.value.count == 0 {
            filterDaftarPresensiVM.getBulanTahun(nc: navigationController)
        }
    }
    
    private func observeData() {
        filterDaftarPresensiVM.loading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        filterDaftarPresensiVM.fullBulan.subscribe(onNext: { value in
            self.labelBulan.text = value
        }).disposed(by: disposeBag)
        
        filterDaftarPresensiVM.tahun.subscribe(onNext: { value in
            self.labelTahun.text = value
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewBulan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBulanClick)))
        viewTahun.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTahunClick)))
        viewTerapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTerapkanClick)))
        viewReset.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewResetClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension FilterDaftarPresensiVC: BottomSheetPickerProtocol {
    func getItem(index: Int) {
        if filterBulan {
            let bulan = "\(filterDaftarPresensiVM.listBulan.value[index].number ?? 1)"
            
            filterDaftarPresensiVM.fullBulan.accept(filterDaftarPresensiVM.listBulan.value[index].name ?? "")
            filterDaftarPresensiVM.bulan.accept(bulan.count == 1 ? "0\(bulan)" : bulan)
        } else {
            filterDaftarPresensiVM.tahun.accept(filterDaftarPresensiVM.listTahun.value[index])
        }
    }
    
    private func openDatePicker(list: [String], selectedValue: String) {
        let vc = BottomSheetPickerVC()
        vc.singleArray = list
        vc.selectedValue = selectedValue
        vc.delegate = self
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.5)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTerapkanClick() {
        navigationController?.popViewController(animated: true)
        delegate?.applyFilter()
    }
    
    @objc func viewResetClick() {
        filterDaftarPresensiVM.resetFilterDaftarPresensi()
        navigationController?.popViewController(animated: true)
        delegate?.applyFilter()
    }
    
    @objc func viewTahunClick() {
        filterBulan = false
        openDatePicker(list: filterDaftarPresensiVM.listTahun.value, selectedValue: filterDaftarPresensiVM.tahun.value)
    }
    
    @objc func viewBulanClick() {
        filterBulan = true
        var list = [String]()
        filterDaftarPresensiVM.listBulan.value.forEach { item in
            list.append(item.name ?? "")
        }
        openDatePicker(list: list, selectedValue: filterDaftarPresensiVM.fullBulan.value)
    }
}
