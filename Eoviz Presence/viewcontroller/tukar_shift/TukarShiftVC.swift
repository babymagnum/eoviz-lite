//
//  TukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

class TukarShiftVC: BaseViewController, UICollectionViewDelegate {

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
    
    @Inject private var tukarShiftVM: TukarShiftVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
    }
    
    private func setupEvent() {
        viewTanggalBerbeda.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalBerbedaClick)))
        viewTanggalSama.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalSamaClick)))
        viewTanggalShiftAwal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalShiftAwalClick)))
        viewTanggalTukarShift.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalTukarShiftClick)))
    }
    
    private func setupView() {
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

extension TukarShiftVC {
    @objc func cellParentClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionShift.indexPathForItem(at: sender.location(in: collectionShift)) else { return }
        
        var item = tukarShiftVM.listShift.value[indexpath.item]
        item.isSelected = !item.isSelected
        tukarShiftVM.updateItem(item: item, index: indexpath.item)
        collectionShift.reloadItems(at: [indexpath])
    }

    @objc func viewTanggalBerbedaClick() {
        
    }
    
    @objc func viewTanggalSamaClick() {
        
    }
    
    @objc func viewTanggalShiftAwalClick() {
        
    }
    
    @objc func viewTanggalTukarShiftClick() {
        
    }
    
    @IBAction func buttonHistoryClick(_ sender: Any) {
        
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
