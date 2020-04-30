//
//  FilterJamKerjaTimVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 30/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import DIKit
import RxSwift

protocol FilterJamKerjaTimProtocol {
    func applyFilter(dateStart: String, dateEnd: String, listKaryawan: [String])
}

class FilterJamKerjaTimVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewTanggalMulai: CustomView!
    @IBOutlet weak var labelTanggalMulai: CustomLabel!
    @IBOutlet weak var viewTanggalSelesai: CustomView!
    @IBOutlet weak var labelTanggalSelesai: CustomLabel!
    @IBOutlet weak var collectionDaftarKaryawan: UICollectionView!
    @IBOutlet weak var collectionDaftarKaryawanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    @IBOutlet weak var viewEmptyHeight: NSLayoutConstraint!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewTerapkan: CustomGradientView!
    
    @Inject private var filterJamKerjaTimVM: FilterJamKerjaTimVM
    private var disposeBag = DisposeBag()
    private var datePick = ""
    
    var delegate: FilterJamKerjaTimProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
        
        filterJamKerjaTimVM.filterKaryawan(nc: navigationController)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func observeData() {
        filterJamKerjaTimVM.isLoading.subscribe(onNext: { value in
            self.activityIndicator.isHidden = !value
        }).disposed(by: disposeBag)
        
        filterJamKerjaTimVM.showEmpty.subscribe(onNext: { value in
            self.viewEmpty.isHidden = !value
            self.viewEmptyHeight.constant = value ? 1000 : 0
        }).disposed(by: disposeBag)
        
        filterJamKerjaTimVM.emptyMessage.subscribe(onNext: { value in
            self.labelEmpty.text = value
        }).disposed(by: disposeBag)
        
        filterJamKerjaTimVM.listKaryawan.subscribe(onNext: { value in
            self.collectionDaftarKaryawan.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.collectionDaftarKaryawanHeight.constant = self.collectionDaftarKaryawan.contentSize.height
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        collectionDaftarKaryawan.register(UINib(nibName: "FilterKaryawanCell", bundle: .main), forCellWithReuseIdentifier: "FilterKaryawanCell")
        collectionDaftarKaryawan.delegate = self
        collectionDaftarKaryawan.dataSource = self
    }
    
    private func setupEvent() {
        viewTanggalMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalMulaiClick)))
        viewTanggalSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalSelesaiClick)))
        viewTerapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTerapkanClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }

}

extension FilterJamKerjaTimVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterJamKerjaTimVM.listKaryawan.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterKaryawanCell", for: indexPath) as! FilterKaryawanCell
        let item = filterJamKerjaTimVM.listKaryawan.value[indexPath.item]
        cell.imageSelected.image = UIImage(named: item.isSelected ? "selected" : "rectangle577")
        cell.labelName.text = item.emp_name
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellKaryawanClick(sender:))))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = filterJamKerjaTimVM.listKaryawan.value[indexPath.item]
        let imageSize = (screenWidth - 60 - 40) * 0.083
        let nameHeight = item.emp_name.getHeight(withConstrainedWidth: screenWidth - 60 - 40 - imageSize - 10, font: UIFont(name: "Poppins-Medium", size: 14 + PublicFunction.dynamicSize()))
        return CGSize(width: screenWidth - 60 - 40, height: nameHeight + 20)
    }
}

extension FilterJamKerjaTimVC: BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String) {
        if datePick == "mulai" {
            labelTanggalMulai.text = PublicFunction.dateStringTo(date: formatedDate, fromPattern: "dd-MM-yyyy", toPattern: "dd/MM/yyyy")
        } else {
            labelTanggalSelesai.text = PublicFunction.dateStringTo(date: formatedDate, fromPattern: "dd-MM-yyyy", toPattern: "dd/MM/yyyy")
        }
    }
    
    func pickTime(pickedTime: String) { }
    
    private func openDatePicker(datePick: String) {
        self.datePick = datePick
        let vc = BottomSheetDatePickerVC()
        vc.delegate = self
        vc.picker = .date
        vc.isBackDate = true
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.5)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @objc func cellKaryawanClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionDaftarKaryawan.indexPathForItem(at: sender.location(in: collectionDaftarKaryawan)) else { return }
        
        filterJamKerjaTimVM.changeSelected(index: indexpath.item)
    }
    
    @objc func viewTanggalMulaiClick() {
        openDatePicker(datePick: "mulai")
    }
    
    @objc func viewTanggalSelesaiClick() {
        openDatePicker(datePick: "selesai")
    }
    
    @objc func viewTerapkanClick() {
        navigationController?.popViewController(animated: true)
        
        let dateStart = labelTanggalMulai.text?.trim() == "start".localize() ? "" : labelTanggalMulai.text?.trim()
        let dateEnd = labelTanggalSelesai.text?.trim() == "end".localize() ? "" : labelTanggalSelesai.text?.trim()
        let selectedKaryawan = filterJamKerjaTimVM.listKaryawan.value.filter({ $0.isSelected }).map { "\($0.emp_id)" }
        delegate?.applyFilter(dateStart: dateStart ?? "", dateEnd: dateEnd ?? "", listKaryawan: selectedKaryawan)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
