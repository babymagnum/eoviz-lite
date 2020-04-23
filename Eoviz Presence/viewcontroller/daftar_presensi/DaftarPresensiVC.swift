//
//  DaftarPresensiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD

class DaftarPresensiVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionPresensi: UICollectionView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    @Inject private var daftarPresensiVM: DaftarPresensiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterDaftarPresensiVM.resetBulanTahun()
        
        setupView()
        
        observeData()
        
        getData()
    }
    
    private func getData() {
        if daftarPresensiVM.listPresensi.value.count == 0 {
            let date = "\(filterDaftarPresensiVM.tahun.value)-\(filterDaftarPresensiVM.bulan.value)"
            daftarPresensiVM.getListPresensi(date: date, nc: navigationController)
        }
    }
    
    private func observeData() {
        daftarPresensiVM.listPresensi.subscribe(onNext: { value in
            self.collectionPresensi.reloadData()
        }).disposed(by: disposeBag)
        
        daftarPresensiVM.labelEmpty.subscribe(onNext: { value in
            self.labelEmpty.text = value
        }).disposed(by: disposeBag)
        
        daftarPresensiVM.showEmpty.subscribe(onNext: { value in
            self.viewEmpty.isHidden = !value
        }).disposed(by: disposeBag)
        
        daftarPresensiVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        filterDaftarPresensiVM.applyFilter.subscribe(onNext: { value in
            if value {
                let date = "\(self.filterDaftarPresensiVM.tahun.value)-\(self.filterDaftarPresensiVM.bulan.value)"
                print("date applied \(date)")
                self.daftarPresensiVM.getListPresensi(date: date, nc: self.navigationController)
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        collectionPresensi.register(UINib(nibName: "DaftarPresensiCell", bundle: .main), forCellWithReuseIdentifier: "DaftarPresensiCell")
        collectionPresensi.delegate = self
        collectionPresensi.dataSource = self
        collectionPresensi.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        let date = "\(self.filterDaftarPresensiVM.tahun.value)-\(self.filterDaftarPresensiVM.bulan.value)"
        daftarPresensiVM.getListPresensi(date: date, nc: navigationController)
    }
}

extension DaftarPresensiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daftarPresensiVM.listPresensi.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaftarPresensiCell", for: indexPath) as! DaftarPresensiCell
        cell.data = daftarPresensiVM.listPresensi.value[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = daftarPresensiVM.listPresensi.value[indexPath.item]
        let marginHorizontal: CGFloat = 60 - 26
        let dateHeight = item.presence_date?.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let statusHeight = item.prestype_name?.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Medium", size: 9 + PublicFunction.dynamicSize())) ?? 0
        let jamMasukHeight = item.presence_in?.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        return CGSize(width: screenWidth - 60, height: dateHeight + statusHeight + (jamMasukHeight * 2) + 55)
    }
}

extension DaftarPresensiVC {
    @IBAction func buttonFilterClick(_ sender: Any) {
        navigationController?.pushViewController(FilterDaftarPresensiVC(), animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
