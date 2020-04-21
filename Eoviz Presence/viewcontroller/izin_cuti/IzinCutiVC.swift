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
    private var disposeBag = DisposeBag()
    private var deletedTanggalCutiPosition = 0
    
    private var listJenisCuti: [String] {
        return ["Pilih jenis Cuti", "Sakit dengan surat dokter", "Izin meninggalkan pekerjaan sementara", "Cuti Tahunan"]
    }
    
    private var listJenisCutiId: [String] {
        return ["0", "1", "2", "3"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        izinCutiVM.jenisCuti.subscribe(onNext: { value in
            self.labelJenisCuti.text = value
            
            UIView.animate(withDuration: 0.2) {
                if value == "Pilih jenis Cuti" {
                    self.viewAlasanTopMargin.constant = 20
                    self.viewSakit.isHidden = true
                    self.viewSakitHeight.constant = 0
                    self.viewMeninggalkanKantor.isHidden = true
                    self.viewMeninggalkanKantorHeight.constant = 0
                    self.viewCuti.isHidden = true
                    self.viewCutiHeight.constant = 0
                } else if value == "Sakit dengan surat dokter" {
                    self.viewAlasanTopMargin.constant = 0
                    self.viewSakit.isHidden = false
                    self.viewSakitHeight.constant = 1000
                    self.viewMeninggalkanKantor.isHidden = true
                    self.viewMeninggalkanKantorHeight.constant = 0
                    self.viewCuti.isHidden = true
                    self.viewCutiHeight.constant = 0
                } else if value == "Izin meninggalkan pekerjaan sementara" {
                    self.viewAlasanTopMargin.constant = 0
                    self.viewSakit.isHidden = true
                    self.viewSakitHeight.constant = 0
                    self.viewMeninggalkanKantor.isHidden = false
                    self.viewMeninggalkanKantorHeight.constant = 1000
                    self.viewCuti.isHidden = true
                    self.viewCutiHeight.constant = 0
                } else {
                    self.viewAlasanTopMargin.constant = 0
                    self.viewSakit.isHidden = true
                    self.viewSakitHeight.constant = 0
                    self.viewMeninggalkanKantor.isHidden = true
                    self.viewMeninggalkanKantorHeight.constant = 0
                    self.viewCuti.isHidden = false
                    self.viewCutiHeight.constant = 10000
                    self.izinCutiVM.getCutiTahunan()
                }
                
                self.view.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
        
        izinCutiVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
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
    func getItem(data: String, id: String) {
        izinCutiVM.updateJenisCuti(jenisCuti: data, jenisCutiId: id)
    }
    
    func pickDate(formatedDate: String) {
        let newFormatedDate = formatedDate.replacingOccurrences(of: "-", with: "/")
        
        if izinCutiVM.viewPickType.value == .rentangTanggalAwal {
            labelRentangTanggalMulai.text = newFormatedDate
        } else if izinCutiVM.viewPickType.value == .rentangTanggalAkhir {
            labelRentangTanggalAkhir.text = newFormatedDate
        } else if izinCutiVM.viewPickType.value == .tanggalMeninggalkanPekerjaan {
            labelTanggalMeninggalkanPekerjaan.text = newFormatedDate
        } else if izinCutiVM.viewPickType.value == .tanggalCuti {
            izinCutiVM.addTanggalCuti(date: newFormatedDate)
            labelTanggalCutiTahunan.text = newFormatedDate
        }
    }
    
    func pickTime(pickedTime: String) {
        if izinCutiVM.viewPickType.value == .waktuMulai {
            labelWaktuMulai.text = pickedTime
        } else if izinCutiVM.viewPickType.value == .waktuSelesai {
            labelWaktuSelesai.text = pickedTime
        }
    }
    
    @objc func viewJenisCutiClick() {
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.hasId = true
        vc.singleArray = listJenisCuti
        vc.singleArrayId = listJenisCutiId
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
        openDatePicker(isBackDate: true, pickerType: .date, viewPickType: .rentangTanggalAwal)
    }
    
    @objc func viewRentangTanggalAkhirClick() {
        openDatePicker(isBackDate: true, pickerType: .date, viewPickType: .rentangTanggalAkhir)
    }
    
    @objc func viewTanggalMeninggalkanPekerjaanClick() {
        openDatePicker(isBackDate: true, pickerType: .date, viewPickType: .tanggalMeninggalkanPekerjaan)
    }
    
    @objc func viewWaktuMulaiClick() {
        openDatePicker(isBackDate: false, pickerType: .time, viewPickType: .waktuMulai)
    }
    
    @objc func viewWaktuSelesaiClick() {
        openDatePicker(isBackDate: false, pickerType: .time, viewPickType: .waktuSelesai)
    }
    
    @objc func viewTanggalCutiTahunanClick() {
        openDatePicker(isBackDate: false, pickerType: .date, viewPickType: .tanggalCuti)
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
        navigationController?.pushViewController(DetailIzinCutiVC(), animated: true)
    }
    
    @objc func viewSimpanClick() {
        
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
            let periodeHeight = item.periode.getHeight(withConstrainedWidth: screenWidth - 60 - 40, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
            let kadaluarsaHeight = item.kadaluarsa.getHeight(withConstrainedWidth: screenWidth - 60 - 40, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
            let hariHeight = item.jatahCuti.getHeight(withConstrainedWidth: screenWidth - 60 - 40, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
            return CGSize(width: screenWidth - 60, height: periodeHeight + kadaluarsaHeight + (hariHeight * 3) + 52)
        } else {
            return CGSize(width: screenWidth - 60, height: screenWidth * 0.11)
        }
    }
}
