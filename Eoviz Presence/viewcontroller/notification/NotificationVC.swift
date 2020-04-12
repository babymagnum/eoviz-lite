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
    
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var collectionNotifikasi: UICollectionView!
    @IBOutlet weak var viewEmptyNotifikasi: UIView!
    
    @Inject var notificationVM: NotificationVM
    
    private var disposeBag = DisposeBag()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.sizeThatFits(CGSize(width: 29, height: 29))
        refreshControl.tintColor = UIColor.windowsBlue
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        observeData()
        
        notificationVM.getNotifikasi(isFirst: true)
    }

    private func observeData() {
        notificationVM.showEmpty.subscribe(onNext: { value in
            self.viewEmptyNotifikasi.isHidden = !value
        }).disposed(by: disposeBag)
        notificationVM.isLoading.subscribe(onNext: { _ in
            self.collectionNotifikasi.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
        notificationVM.listNotifikasi.subscribe(onNext: { _ in
            self.collectionNotifikasi.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        viewParent.corners = [.topLeft, .topRight]
        
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
        if indexPath.item == notificationVM.listNotifikasi.value.count - 1 {
            notificationVM.getNotifikasi(isFirst: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notificationVM.listNotifikasi.value.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == notificationVM.listNotifikasi.value.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.isHidden = !notificationVM.isLoading.value
            cell.activityIndicator.startAnimating()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotifikasiCell", for: indexPath) as! NotifikasiCell
            cell.data = notificationVM.listNotifikasi.value[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == notificationVM.listNotifikasi.value.count {
            return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
        } else {
            let item = notificationVM.listNotifikasi.value[indexPath.item]
            let dateHeight = item.date.getHeight(withConstrainedWidth: screenWidth - 60 - 34, font: UIFont(name: "Roboto-Medium", size: 11 + PublicFunction.dynamicSize()))
            let titleHeight = item.title.getHeight(withConstrainedWidth: screenWidth - 60 - 34 - 18, font: UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize()))
            let contentHeight = item.content.getHeight(withConstrainedWidth: screenWidth - 60 - 34, font: UIFont(name: "Poppins-SemiBold", size: 11 + PublicFunction.dynamicSize()))
            return CGSize(width: screenWidth - 60, height: dateHeight + titleHeight + contentHeight + 34)
        }
    }
}
