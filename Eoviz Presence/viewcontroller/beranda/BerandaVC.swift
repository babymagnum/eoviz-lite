//
//  BerandaVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD

class BerandaVC: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var viewCornerParent: CustomView!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelShift: CustomLabel!
    @IBOutlet weak var labelPresenceStatus: CustomLabel!
    @IBOutlet weak var labelTime: CustomLabel!
    @IBOutlet weak var collectionData: UICollectionView!
    @IBOutlet weak var viewPresensi: UIView!
    @IBOutlet weak var viewTukarShift: UIView!
    @IBOutlet weak var viewIzinCuti: UIView!
    @IBOutlet weak var viewJamKerja: UIView!
    
    private var disposeBag = DisposeBag()
    @Inject var berandaVM: BerandaVM
    
    var listBerandaData = [
        BerandaCarousel(image: "clock", content: "percentage_npresence".localize(), percentage: 0.71, percentageContent: "71%"),
        BerandaCarousel(image: "koper", content: "leave_nquota".localize(), percentage: 10/16, percentageContent: "10")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        observeData()
        
        berandaVM.startTime()
        
        berandaVM.getBerandaData()
    }
    
    private func observeData() {
        berandaVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        berandaVM.isExpired.subscribe(onNext: { value in
            if value { self.forceLogout(self.navigationController!) }
        }).disposed(by: disposeBag)
        
        berandaVM.error.subscribe(onNext: { value in
            if value != "" {
                self.showAlertDialog(description: value)
            }
        }).disposed(by: disposeBag)
        
        berandaVM.beranda.subscribe(onNext: { value in
            self.imageUser.loadUrl(value.photo ?? "")
            self.labelName.text = "\("hello".localize()) \(value.emp_name ?? "")"
            self.labelPresenceStatus.text = value.status_presence ?? ""
            self.labelShift.text = value.shift_name ?? ""
            if let _presence = value.presence {
                let isZero = _presence.target == 0 || _presence.achievement == 0
                let percentage = isZero ? 0 : Double(_presence.achievement / _presence.target)
                
                self.listBerandaData[0].percentage = percentage
                self.listBerandaData[0].percentageContent = "\(Int(percentage) * 100)%"
            }
            if let _leave = value.leave_quota {
                let isZero = _leave.quota == 0 || _leave.used == 0
                
                self.listBerandaData[1].percentage = isZero ? 0 : Double(_leave.used / _leave.quota)
                self.listBerandaData[1].percentageContent = "\(_leave.quota)"
            }
            
            self.collectionData.reloadData()
        }).disposed(by: disposeBag)
        
        berandaVM.time.subscribe(onNext: { value in
            self.labelTime.text = value == "" ? "\(PublicFunction.getStringDate(pattern: "HH:mm:ss")) WIB" : value
        }).disposed(by: disposeBag)
    }

    private func setupView() {
        
        viewCornerParent.corners = [.topLeft, .topRight]
        imageUser.loadUrl("https://ppmschool.ac.id/id/wp-content/uploads/2016/01/tutor-8.jpg")
        collectionData.register(UINib(nibName: "BerandaCell", bundle: .main), forCellWithReuseIdentifier: "BerandaCell")
        collectionData.delegate = self
        collectionData.dataSource = self
        let collectionDataLayout = collectionData.collectionViewLayout as! UICollectionViewFlowLayout
        collectionDataLayout.itemSize = CGSize(width: screenWidth * 0.7, height: screenWidth * 0.32)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension BerandaVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listBerandaData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BerandaCell", for: indexPath) as! BerandaCell
        cell.position = indexPath.item
        cell.data = listBerandaData[indexPath.item]
        return cell
    }
}
