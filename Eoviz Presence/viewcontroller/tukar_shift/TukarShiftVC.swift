//
//  TukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import FittedSheets

class TukarShiftVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionShiftTopMargin: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorTopMargin: NSLayoutConstraint!
    @IBOutlet weak var imageTanggalSama: UIImageView!
    @IBOutlet weak var imageTanggalBerbeda: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelPegawai: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var viewTanggalBerbeda: UIView!
    @IBOutlet weak var viewTanggalSama: UIView!
    @IBOutlet weak var viewTanggalShiftAwal: CustomView!
    @IBOutlet weak var labelTanggalShiftAwal: CustomLabel!
    @IBOutlet weak var viewTanggalTukarShift: CustomView!
    @IBOutlet weak var labelTanggalTukarShift: CustomLabel!
    @IBOutlet weak var collectionShift: UICollectionView!
    @IBOutlet weak var collectionShiftHeight: NSLayoutConstraint!
    @IBOutlet weak var viewShiftEmpty: UIView!
    @IBOutlet weak var viewShiftEmptyHeight: NSLayoutConstraint!
    @IBOutlet weak var textviewAlasan: CustomTextView!
    @IBOutlet weak var viewSimpan: CustomGradientView!
    @IBOutlet weak var viewKirim: CustomGradientView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewTanggalShiftAwalParent: UIView!
    @IBOutlet weak var viewTanggalShiftAwalParentHeight: NSLayoutConstraint!
    @IBOutlet weak var viewShiftParent: CustomView!
    
    private var disposeBag = DisposeBag()
    @Inject private var tukarShiftVM: TukarShiftVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        tukarShiftVM.isEmpty.subscribe(onNext: { value in
            UIView.animate(withDuration: 0.2) {
                self.viewShiftEmptyHeight.constant = value ? 1000 : 0
                self.viewShiftEmpty.isHidden = !value
                self.viewShiftParent.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
        
        tukarShiftVM.isLoading.subscribe(onNext: { value in
            UIView.animate(withDuration: 0.2) {
                self.activityIndicatorTopMargin.constant = value ? 15 : 0
                self.activityIndicator.isHidden = !value
                self.viewShiftParent.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
        
        tukarShiftVM.listShift.subscribe(onNext: { value in
            self.collectionShift.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionShiftHeight.constant = self.collectionShift.contentSize.height
                    self.viewShiftParent.layoutIfNeeded()
                }
            }
        }).disposed(by: disposeBag)
        
        tukarShiftVM.tanggalTukarShift.subscribe(onNext: { value in
            self.labelTanggalTukarShift.text = value
            if value != "" { self.tukarShiftVM.getListShift() }
        }).disposed(by: disposeBag)
        
        tukarShiftVM.tanggalShiftAwal.subscribe(onNext: { value in
            self.labelTanggalShiftAwal.text = value
        }).disposed(by: disposeBag)
        
        tukarShiftVM.typeTanggal.subscribe(onNext: { value in
            if value != "" {
                self.imageTanggalBerbeda.image = UIImage(named: value == "beda" ? "group840" : "rectangle577")
                self.imageTanggalSama.image = UIImage(named: value == "sama" ? "group840" : "rectangle577")
                
                UIView.animate(withDuration: 0.2) {
                    self.viewTanggalShiftAwalParentHeight.constant = value == "sama" ? 0 : 1000
                    self.viewTanggalShiftAwalParent.isHidden = value == "sama" ? true : false
                    self.viewParent.layoutIfNeeded()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewTanggalBerbeda.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalBerbedaClick)))
        viewTanggalSama.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalSamaClick)))
        viewTanggalShiftAwal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalShiftAwalClick)))
        viewTanggalTukarShift.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalTukarShiftClick)))
    }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
        collectionShift.register(UINib(nibName: "ShiftCell", bundle: .main), forCellWithReuseIdentifier: "ShiftCell")
        collectionShift.delegate = self
        collectionShift.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension TukarShiftVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tukarShiftVM.listShift.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShiftCell", for: indexPath) as! ShiftCell
        cell.data = tukarShiftVM.listShift.value[indexPath.item]
        cell.viewParent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellParentClick(sender:))))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginHorizontal: CGFloat = 100
        let item = tukarShiftVM.listShift.value[indexPath.item]
        let nameHeight = item.name.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize()))
        let shiftHeight = item.shift.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Regular", size: 11 + PublicFunction.dynamicSize()))
        let masukHeight = item.dateMasuk.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize()))
        return CGSize(width: screenWidth - 60 - 35, height: nameHeight + shiftHeight + (masukHeight * 2) + 29)
    }
}

extension TukarShiftVC: BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String) {
        let newFormatedDate = PublicFunction.dateStringTo(date: formatedDate, fromPattern: "dd-MM-yyyy", toPattern: "dd/MM/yyyy")
        
        if tukarShiftVM.typeShift.value == "shift_awal" {
            tukarShiftVM.tanggalShiftAwal.accept(newFormatedDate)
        } else {
            tukarShiftVM.tanggalTukarShift.accept(newFormatedDate)
        }
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
    
    @objc func cellParentClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionShift.indexPathForItem(at: sender.location(in: collectionShift)) else { return }
        
        var item = tukarShiftVM.listShift.value[indexpath.item]
        item.isSelected = !item.isSelected
        tukarShiftVM.updateItem(item: item, index: indexpath.item)
        collectionShift.reloadItems(at: [indexpath])
    }

    @objc func viewTanggalBerbedaClick() {
        tukarShiftVM.typeTanggal.accept("beda")
    }
    
    @objc func viewTanggalSamaClick() {
        tukarShiftVM.typeTanggal.accept("sama")
    }
    
    @objc func viewTanggalShiftAwalClick() {
        tukarShiftVM.typeShift.accept("shift_awal")
        openDatePicker()
    }
    
    @objc func viewTanggalTukarShiftClick() {
        tukarShiftVM.typeShift.accept("tukar_shift")
        openDatePicker()
    }
    
    @IBAction func buttonHistoryClick(_ sender: Any) {
        
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
