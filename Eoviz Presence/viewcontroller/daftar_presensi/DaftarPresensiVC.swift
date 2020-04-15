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
    
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    @Inject private var daftarPresensiVM: DaftarPresensiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        observeData()
        
        daftarPresensiVM.getListPresensi()
    }
    
    private func observeData() {
        daftarPresensiVM.listPresensi.subscribe(onNext: { value in
            self.collectionPresensi.reloadData()
        }).disposed(by: disposeBag)
        
        daftarPresensiVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        filterDaftarPresensiVM.applyFilter.subscribe(onNext: { value in
            if value {
                print("reload list presensi after filter, date: \(self.filterDaftarPresensiVM.fullDate.value)")
                self.daftarPresensiVM.getListPresensi()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
        collectionPresensi.register(UINib(nibName: "DaftarPresensiCell", bundle: .main), forCellWithReuseIdentifier: "DaftarPresensiCell")
        collectionPresensi.delegate = self
        collectionPresensi.dataSource = self
        collectionPresensi.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        daftarPresensiVM.getListPresensi()
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
        let dateHeight = item.date.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize()))
        let statusHeight = item.status.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Medium", size: 9 + PublicFunction.dynamicSize()))
        let jamMasukHeight = item.jamMasukReal.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
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
