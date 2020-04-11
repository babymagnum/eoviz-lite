//
//  NotificationVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift

class NotificationVC: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var collectionNotifikasi: UICollectionView!
    @IBOutlet weak var viewEmptyNotifikasi: UIView!
    
    @Inject var notificationVM: NotificationVM
    
    private var disposeBag = DisposeBag()
    private var listNotifikasi = [NotifikasiData]()
    private var isLoading = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        observeData()
        
        notificationVM.getNotifikasi(isFirst: true)
    }

    private func observeData() {
        notificationVM.isLoading.subscribe(onNext: { value in
            self.isLoading = value
        }).disposed(by: disposeBag)
        
        notificationVM.listNotifikasi.subscribe(onNext: { value in
            self.listNotifikasi = value
            self.collectionNotifikasi.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
        
        collectionNotifikasi.register(UINib(nibName: "NotifikasiCell", bundle: .main), forCellWithReuseIdentifier: "NotifikasiCell")
        collectionNotifikasi.register(UINib(nibName: "LoadingCell", bundle: .main), forCellWithReuseIdentifier: "LoadingCell")
        collectionNotifikasi.delegate = self
        collectionNotifikasi.dataSource = self
        collectionNotifikasi.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        notificationVM.getNotifikasi(isFirst: true)
    }
}

extension NotificationVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listNotifikasi.count - 1 {
            notificationVM.getNotifikasi(isFirst: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listNotifikasi.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < listNotifikasi.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotifikasiCell", for: indexPath) as! NotifikasiCell
            cell.data = listNotifikasi[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < listNotifikasi.count {
            let item = listNotifikasi[indexPath.item]
            let dateHeight = item.date.getHeight(withConstrainedWidth: screenWidth - 60 - 34, font: UIFont(name: "Roboto-Medium", size: 11)!)
            let titleHeight = item.title.getHeight(withConstrainedWidth: screenWidth - 60 - 34 - 18, font: UIFont(name: "Poppins-SemiBold", size: 12)!)
            let contentHeight = item.content.getHeight(withConstrainedWidth: screenWidth - 60 - 34, font: UIFont(name: "Poppins-SemiBold", size: 11)!)
            return CGSize(width: screenWidth - 60, height: dateHeight + titleHeight + contentHeight + 34)
        } else {
            return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.35)
        }
    }
}
