//
//  IzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 19/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD
import Toast_Swift
import FittedSheets

class IzinCutiVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var labelNama: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var viewJenisCuti: CustomView!
    @IBOutlet weak var labelJenisCuti: CustomLabel!
    @IBOutlet weak var viewRentangTanggalMulai: CustomView!
    @IBOutlet weak var viewRentangTanggalAkhir: CustomView!
    @IBOutlet weak var labelRentangTanggalMulai: CustomLabel!
    @IBOutlet weak var labelRentangTanggalAkhir: CustomLabel!
    @IBOutlet weak var viewTanggalMeninggalkanPekerjaan: CustomView!
    @IBOutlet weak var labelTanggalMeninggalkanPekerjaan: CustomLabel!
    @IBOutlet weak var viewWaktuMulai: CustomView!
    @IBOutlet weak var labelWaktuMulai: CustomLabel!
    @IBOutlet weak var viewWaktuSelesai: CustomView!
    @IBOutlet weak var labelWaktuSelesai: CustomLabel!
    @IBOutlet weak var collectionJatahCuti: UICollectionView!
    @IBOutlet weak var viewTanggalCutiTahunan: CustomView!
    @IBOutlet weak var labelTanggalCutiTahunan: CustomLabel!
    @IBOutlet weak var collectionTanggalCuti: UICollectionView!
    @IBOutlet weak var textviewAlasan: CustomTextView!
    @IBOutlet weak var viewSimpan: CustomGradientView!
    @IBOutlet weak var viewKirim: CustomGradientView!
    @IBOutlet weak var collectionJatahCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var viewSakit: UIView!
    @IBOutlet weak var viewSakitHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMeninggalkanKantor: UIView!
    @IBOutlet weak var viewMeninggalkanKantorHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCuti: UIView!
    @IBOutlet weak var viewCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAlasanTopMargin: NSLayoutConstraint!
    @IBOutlet weak var collectionTanggalCutiHeight: NSLayoutConstraint!
    
    @Inject private var izinCutiVM: IzinCutiVM
    @Inject private var profileVM: ProfileVM
    private var disposeBag = DisposeBag()
    private var deletedTanggalCutiPosition = 0
    private var listJenisCuti = [String]()
    private var isBackDate = false
    
    var permissionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        izinCutiVM.selectedJenisCuti.accept(0)
        
        setupView()
        
        setupEvent()
        
        observeData()
        
        getData()
    }
    
    private func getData() {
        izinCutiVM.tipeCuti(nc: navigationController)
    }
    
    private func isRange() {
        self.viewAlasanTopMargin.constant = 0
        self.viewSakit.isHidden = false
        self.viewSakitHeight.constant = 1000
        self.viewMeninggalkanKantor.isHidden = true
        self.viewMeninggalkanKantorHeight.constant = 0
        self.viewCuti.isHidden = true
        self.viewCutiHeight.constant = 0
    }
    
    private func observeData() {
        profileVM.profileData.subscribe(onNext: { value in
            self.labelNama.text = value.emp_name
            self.labelUnitKerja.text = value.emp_unit ?? "" == "" ? "-" : value.emp_unit
        }).disposed(by: disposeBag)
        
        izinCutiVM.selectedJenisCuti.subscribe(onNext: { value in
            UIView.animate(withDuration: 0.2) {
                if value == 0 {
                    self.labelJenisCuti.text = "pick_leave_type".localize()
                    
                    // Pilih jenis cuti
                    self.viewAlasanTopMargin.constant = 20
                    self.viewSakit.isHidden = true
                    self.viewSakitHeight.constant = 0
                    self.viewMeninggalkanKantor.isHidden = true
                    self.viewMeninggalkanKantorHeight.constant = 0
                    self.viewCuti.isHidden = true
                    self.viewCutiHeight.constant = 0
                } else {
                    let jenisCuti = self.izinCutiVM.listTipeCuti.value[value]
                    self.isBackDate = jenisCuti.is_allow_backdate ?? 0 == 1
                    self.labelJenisCuti.text = jenisCuti.perstype_name ?? ""
                    
                    if jenisCuti.is_range ?? 0 == 1 && jenisCuti.is_allow_backdate ?? 0 == 1 {
                        // Sakit dg surat dokter
                        self.isRange()
                    } else if jenisCuti.is_range ?? 0 == 0 && jenisCuti.is_allow_backdate ?? 0 == 1 {
                        // Meninggalkan kantor sementara
                        self.viewAlasanTopMargin.constant = 0
                        self.viewSakit.isHidden = true
                        self.viewSakitHeight.constant = 0
                        self.viewMeninggalkanKantor.isHidden = false
                        self.viewMeninggalkanKantorHeight.constant = 1000
                        self.viewCuti.isHidden = true
                        self.viewCutiHeight.constant = 0
                    } else if jenisCuti.perstype_id == 7 {
                        // Cuti tahunan
                        self.viewAlasanTopMargin.constant = 0
                        self.viewSakit.isHidden = true
                        self.viewSakitHeight.constant = 0
                        self.viewMeninggalkanKantor.isHidden = true
                        self.viewMeninggalkanKantorHeight.constant = 0
                        self.viewCuti.isHidden = false
                        self.viewCutiHeight.constant = 10000
                        self.izinCutiVM.getCutiTahunan(nc: self.navigationController)
                    } else {
                        self.isRange()
                    }
                }
                
                self.view.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
        
        izinCutiVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        izinCutiVM.listJatahCuti.subscribe(onNext: { value in
            self.collectionJatahCuti.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionJatahCutiHeight.constant = self.collectionJatahCuti.contentSize.height
                }
            }
        }).disposed(by: disposeBag)
        
        izinCutiVM.listTanggalCuti.subscribe(onNext: { value in
            self.collectionTanggalCuti.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionTanggalCutiHeight.constant = self.collectionTanggalCuti.contentSize.height
                }
            }
        }).disposed(by: disposeBag)
        
        izinCutiVM.listTipeCuti.subscribe(onNext: { value in
            if value.count > 0 {
                value.forEach { item in
                    self.listJenisCuti.append(item.perstype_name ?? "")
                }
            } else {
                self.labelJenisCuti.text = "pick_leave_type".localize()
            }
        }).disposed(by: disposeBag)
        
        izinCutiVM.isDateExist.subscribe(onNext: { value in
            if value {
                self.view.makeToast("date_exist".localize())
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewJenisCuti.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewJenisCutiClick)))
        viewRentangTanggalMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRentangTanggalMulaiClick)))
        viewRentangTanggalAkhir.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRentangTanggalAkhirClick)))
        viewTanggalMeninggalkanPekerjaan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalMeninggalkanPekerjaanClick)))
        viewWaktuMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuMulaiClick)))
        viewWaktuSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuSelesaiClick)))
        viewTanggalCutiTahunan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalCutiTahunanClick)))
        viewKirim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKirimClick)))
        viewSimpan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSimpanClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    private func setupView() {
        collectionJatahCuti.register(UINib(nibName: "JatahCutiCell", bundle: .main), forCellWithReuseIdentifier: "JatahCutiCell")
        collectionJatahCuti.delegate = self
        collectionJatahCuti.dataSource = self
        
        collectionTanggalCuti.register(UINib(nibName: "TanggalCutiCell", bundle: .main), forCellWithReuseIdentifier: "TanggalCutiCell")
        collectionTanggalCuti.delegate = self
        collectionTanggalCuti.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension IzinCutiVC: BottomSheetDatePickerProtocol, BottomSheetPickerProtocol {
    func getItem(index: Int) {
        izinCutiVM.selectedJenisCuti.accept(index)
    }
    
    func pickDate(formatedDate: String) {
        let newFormatedDate = formatedDate.replacingOccurrences(of: "-", with: "/")
        let newFormatedMillis = PublicFunction.dateToMillis(date: PublicFunction.stringToDate(date: newFormatedDate, pattern: "dd/MM/yyyy"), pattern: "dd/MM/yyyy")
    
        if izinCutiVM.viewPickType.value == .rentangTanggalAwal {
            let tanggalAkhirMillis = PublicFunction.dateToMillis(date: PublicFunction.stringToDate(date: labelRentangTanggalAkhir.text ?? "", pattern: "dd/MM/yyyy"), pattern: "dd/MM/yyyy")
            
            if newFormatedMillis > tanggalAkhirMillis {
                labelRentangTanggalAkhir.text = "end".localize()
            }
            
            labelRentangTanggalMulai.text = newFormatedDate
        } else if izinCutiVM.viewPickType.value == .rentangTanggalAkhir {
            let tanggalMulaiMillis = PublicFunction.dateToMillis(date: PublicFunction.stringToDate(date: labelRentangTanggalMulai.text ?? "", pattern: "dd/MM/yyyy"), pattern: "dd/MM/yyyy")
            
            if newFormatedMillis < tanggalMulaiMillis {
                self.view.makeToast("end_date_cant_smaller_than_start_date".localize())
            } else {
                labelRentangTanggalAkhir.text = newFormatedDate
            }
        } else if izinCutiVM.viewPickType.value == .tanggalMeninggalkanPekerjaan {
            labelTanggalMeninggalkanPekerjaan.text = newFormatedDate
        } else if izinCutiVM.viewPickType.value == .tanggalCuti {
            izinCutiVM.addTanggalCuti(date: newFormatedDate)
        }
    }
    
    func pickTime(pickedTime: String) {
        let timeInt = Int(pickedTime.replacingOccurrences(of: ":", with: "")) ?? 0
        
        if izinCutiVM.viewPickType.value == .waktuMulai {
            let timeIntSelesai = Int(labelWaktuSelesai.text?.replacingOccurrences(of: ":", with: "") ?? "") ?? 0
            
            if timeInt > timeIntSelesai {
                labelWaktuSelesai.text = "end".localize()
            }
            
            labelWaktuMulai.text = pickedTime
        } else if izinCutiVM.viewPickType.value == .waktuSelesai {
            let timeIntMulai = Int(labelWaktuMulai.text?.replacingOccurrences(of: ":", with: "") ?? "") ?? 0
            
            if timeInt < timeIntMulai {
                self.view.makeToast("end_time_cant_smaller_than_start_time".localize())
            } else {
                labelWaktuSelesai.text = pickedTime
            }
        }
    }
    
    @objc func viewJenisCutiClick() {
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.singleArray = listJenisCuti
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.4)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    private func openDatePicker(isBackDate: Bool, pickerType: PickerTypeEnum, viewPickType: ViewPickType) {
        
        izinCutiVM.viewPickType.accept(viewPickType)
        
        let vc = BottomSheetDatePickerVC()
        vc.delegate = self
        vc.isBackDate = isBackDate
        vc.picker = pickerType
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.5)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @objc func viewRentangTanggalMulaiClick() {
        openDatePicker(isBackDate: isBackDate, pickerType: .date, viewPickType: .rentangTanggalAwal)
    }
    
    @objc func viewRentangTanggalAkhirClick() {
        openDatePicker(isBackDate: isBackDate, pickerType: .date, viewPickType: .rentangTanggalAkhir)
    }
    
    @objc func viewTanggalMeninggalkanPekerjaanClick() {
        openDatePicker(isBackDate: isBackDate, pickerType: .date, viewPickType: .tanggalMeninggalkanPekerjaan)
    }
    
    @objc func viewWaktuMulaiClick() {
        openDatePicker(isBackDate: isBackDate, pickerType: .time, viewPickType: .waktuMulai)
    }
    
    @objc func viewWaktuSelesaiClick() {
        openDatePicker(isBackDate: isBackDate, pickerType: .time, viewPickType: .waktuSelesai)
    }
    
    @objc func viewTanggalCutiTahunanClick() {
        openDatePicker(isBackDate: isBackDate, pickerType: .date, viewPickType: .tanggalCuti)
    }

    @IBAction func buttonHistoryClick(_ sender: Any) {
        navigationController?.pushViewController(RiwayatIzinCutiVC(), animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonDeleteClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionTanggalCuti.indexPathForItem(at: sender.location(in: collectionTanggalCuti)) else { return }
        deletedTanggalCutiPosition = indexpath.item
        izinCutiVM.deleteTanggalCuti(position: indexpath.item)
    }
    
    @objc func viewKirimClick() {
        submitCuti(sendType: "1")
    }
    
    @objc func viewSimpanClick() {
        submitCuti(sendType: "2")
    }
    
    private func submitLeaveRange(tipeCuti: TipeCutiItem, sendType: String) {
        if labelRentangTanggalMulai.text == "" {
            self.view.makeToast("start_date_cant_empty".localize())
        } else if labelRentangTanggalAkhir.text == "" {
            self.view.makeToast("end_date_cant_empty".localize())
        } else if textviewAlasan.text.trim() == "" {
            self.view.makeToast("empty_reason".localize())
        } else {
            izinCutiVM.submitCuti(isRange: true, date: nil, dateStart: labelRentangTanggalMulai.text ?? "", dateEnd: labelRentangTanggalAkhir.text ?? "", sendType: sendType, permissionId: permissionId ?? "", permissionTypeId: "\(tipeCuti.perstype_id ?? 0)", reason: textviewAlasan.text.trim(), nc: navigationController)
        }
    }
    
    private func submitCuti(sendType: String) {
        let jenisCuti = izinCutiVM.listTipeCuti.value[izinCutiVM.selectedJenisCuti.value]
        
        self.isBackDate = jenisCuti.is_allow_backdate ?? 0 == 1
        self.labelJenisCuti.text = jenisCuti.perstype_name ?? ""
        
        if jenisCuti.is_range ?? 0 == 1 && jenisCuti.is_allow_backdate ?? 0 == 1 {
            // Sakit dg surat dokter
            submitLeaveRange(tipeCuti: jenisCuti, sendType: sendType)
        } else if jenisCuti.is_range ?? 0 == 0 && jenisCuti.is_allow_backdate ?? 0 == 1 {
            // Meninggalkan kantor sementara
            if labelTanggalMeninggalkanPekerjaan.text == "" {
                self.view.makeToast("date_cant_empty".localize())
            } else if labelWaktuMulai.text == "" {
                self.view.makeToast("start_time_cant_empty".localize())
            } else if labelWaktuSelesai.text == "" {
                self.view.makeToast("end_time_cant_empty".localize())
            } else if textviewAlasan.text.trim() == "" {
                self.view.makeToast("empty_reason".localize())
            } else {
                izinCutiVM.submitCuti(isRange: false, date: labelTanggalMeninggalkanPekerjaan.text ?? "", dateStart: labelRentangTanggalMulai.text ?? "", dateEnd: labelRentangTanggalAkhir.text ?? "", sendType: sendType, permissionId: permissionId ?? "", permissionTypeId: "\(jenisCuti.perstype_id ?? 0)", reason: textviewAlasan.text.trim(), nc: navigationController)
            }
        } else if jenisCuti.perstype_id == 7 {
            // Cuti tahunan
            if izinCutiVM.listTanggalCuti.value.count == 0 {
                self.view.makeToast("you_have_not_pick_leave_date_yet".localize())
            } else if textviewAlasan.text.trim() == "" {
                self.view.makeToast("empty_reason".localize())
            } else {
                izinCutiVM.submitCuti(isRange: false, date: nil, dateStart: labelRentangTanggalMulai.text ?? "", dateEnd: labelRentangTanggalAkhir.text ?? "", sendType: sendType, permissionId: permissionId ?? "", permissionTypeId: "\(jenisCuti.perstype_id ?? 0)", reason: textviewAlasan.text.trim(), nc: navigationController)
            }
        } else {
            submitLeaveRange(tipeCuti: jenisCuti, sendType: sendType)
        }
    }
}

extension IzinCutiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionJatahCuti {
            return izinCutiVM.listJatahCuti.value.count
        } else {
            return izinCutiVM.listTanggalCuti.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionJatahCuti {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JatahCutiCell", for: indexPath) as! JatahCutiCell
            cell.data = izinCutiVM.listJatahCuti.value[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalCutiCell", for: indexPath) as! TanggalCutiCell
            cell.data = izinCutiVM.listTanggalCuti.value[indexPath.item]
            cell.buttonDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonDeleteClick(sender:))))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionJatahCuti {
            let item = izinCutiVM.listJatahCuti.value[indexPath.item]
            let periodeHeight = "\(item.start ?? "") - \(item.end ?? "")".getHeight(withConstrainedWidth: screenWidth - 60 - 40, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
            let kadaluarsaHeight = item.expired?.getHeight(withConstrainedWidth: screenWidth - 60 - 40, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
            let hariHeight = "\(item.quota ?? 0)".getHeight(withConstrainedWidth: screenWidth - 60 - 40, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
            return CGSize(width: screenWidth - 60, height: periodeHeight + kadaluarsaHeight + (hariHeight * 3) + 52)
        } else {
            return CGSize(width: screenWidth - 60, height: screenWidth * 0.11)
        }
    }
}
