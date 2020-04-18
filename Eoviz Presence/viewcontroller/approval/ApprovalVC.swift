//
//  ApprovalVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class ApprovalVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var buttonTukarShift: CustomButton!
    @IBOutlet weak var buttonIzinCuti: CustomButton!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var collectionPersetujuan: UICollectionView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    private var disposeBag = DisposeBag()
    @Inject private var approvalVM: ApprovalVM
    private var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        observeData()
        
        approvalVM.getIzinCuti(isFirst: true)
        approvalVM.getTukarShift(isFirst: true)
    }
    
    private func observeData() {
        approvalVM.showEmptyIzinCuti.subscribe(onNext: { value in
            if self.currentPage == 0 {
                self.viewEmpty.isHidden = !value
            }
        }).disposed(by: disposeBag)
        
        approvalVM.showEmptyTukarShift.subscribe(onNext: { value in
            if self.currentPage == 1 {
                self.viewEmpty.isHidden = !value
            }
        }).disposed(by: disposeBag)
        
        approvalVM.isLoading.subscribe(onNext: { _ in
            self.collectionPersetujuan.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
        
        approvalVM.listIzinCuti.subscribe(onNext: { _ in
            self.collectionPersetujuan.reloadData()
        }).disposed(by: disposeBag)
        
        approvalVM.listTukarShift.subscribe(onNext: { _ in
            self.collectionPersetujuan.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }

    private func setupView() {
        collectionPersetujuan.register(UINib(nibName: "PersetujuanCell", bundle: .main), forCellWithReuseIdentifier: "PersetujuanCell")
        collectionPersetujuan.register(UINib(nibName: "LoadingCell", bundle: .main), forCellWithReuseIdentifier: "LoadingCell")
        collectionPersetujuan.delegate = self
        collectionPersetujuan.dataSource = self
        collectionPersetujuan.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        
        if currentPage == 0 {
            approvalVM.getIzinCuti(isFirst: true)
        } else {
            approvalVM.getTukarShift(isFirst: true)
        }
    }
}

extension ApprovalVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if currentPage == 0 {
            if indexPath.item == approvalVM.listIzinCuti.value.count - 1 {
                approvalVM.getIzinCuti(isFirst: false)
            }
        } else {
            if indexPath.item == approvalVM.listTukarShift.value.count - 1 {
                approvalVM.getTukarShift(isFirst: false)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentPage == 0 {
            return approvalVM.listIzinCuti.value.count + 1
        } else {
            return approvalVM.listTukarShift.value.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentPage == 0 {
            if indexPath.item == approvalVM.listIzinCuti.value.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
                cell.activityIndicator.isHidden = !approvalVM.isLoading.value
                cell.activityIndicator.startAnimating()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersetujuanCell", for: indexPath) as! PersetujuanCell
                cell.data = approvalVM.listIzinCuti.value[indexPath.item]
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellClick(sender:))))
                return cell
            }
        } else {
            if indexPath.item == approvalVM.listTukarShift.value.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
                cell.activityIndicator.isHidden = !approvalVM.isLoading.value
                cell.activityIndicator.startAnimating()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersetujuanCell", for: indexPath) as! PersetujuanCell
                cell.data = approvalVM.listTukarShift.value[indexPath.item]
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellClick(sender:))))
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize = (screenWidth - 60) * 0.17
        
        if currentPage == 0 {
            if indexPath.item == approvalVM.listIzinCuti.value.count {
                return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
            } else {
                let item = approvalVM.listIzinCuti.value[indexPath.item]
                let isReadWidth: CGFloat = item.isRead ? 18 : 0
                let dateHeight = item.date.getHeight(withConstrainedWidth: screenWidth - 145 - imageSize - isReadWidth, font: UIFont(name: "Roboto-Medium", size: 11 + PublicFunction.dynamicSize()))
                let contentHeight = item.content.getHeight(withConstrainedWidth: screenWidth - 145 - imageSize - isReadWidth, font: UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize()))
                return CGSize(width: screenWidth - 60, height: dateHeight + contentHeight + 37)
            }
        } else {
            if indexPath.item == approvalVM.listTukarShift.value.count {
                return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
            } else {
                let item = approvalVM.listTukarShift.value[indexPath.item]
                let isReadWidth: CGFloat = item.isRead ? 18 : 0
                let dateHeight = item.date.getHeight(withConstrainedWidth: screenWidth - 145 - imageSize - isReadWidth, font: UIFont(name: "Roboto-Medium", size: 11 + PublicFunction.dynamicSize()))
                let contentHeight = item.content.getHeight(withConstrainedWidth: screenWidth - 145 - imageSize - isReadWidth, font: UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize()))
                return CGSize(width: screenWidth - 60, height: dateHeight + contentHeight + 37)
            }
        }
    }
}

extension ApprovalVC {
    private func changePage(value: Int) {
        currentPage = value
        labelEmpty.text = currentPage == 0 ? "empty_leave_permission".localize() : "empty_change_shift".localize()
        
        // change background color
        buttonIzinCuti.backgroundColor = currentPage == 0 ? UIColor.windowsBlue : UIColor.veryLightPinkSix
        buttonTukarShift.backgroundColor = currentPage == 1 ? UIColor.windowsBlue : UIColor.veryLightPinkSix
        
        // change text color
        buttonIzinCuti.setTitleColor(currentPage == 0 ? UIColor.whiteTwo : UIColor.slateGrey, for: .normal)
        buttonTukarShift.setTitleColor(currentPage == 1 ? UIColor.whiteTwo : UIColor.slateGrey, for: .normal)
        
        self.viewEmpty.isHidden = self.currentPage == 0 ? !self.approvalVM.showEmptyIzinCuti.value : !self.approvalVM.showEmptyTukarShift.value
    }
    
    @objc func cellClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionPersetujuan.indexPathForItem(at: sender.location(in: collectionPersetujuan)) else { return }
        
        let item = currentPage == 0 ? approvalVM.listIzinCuti.value[indexpath.item] : approvalVM.listTukarShift.value[indexpath.item]
        
        navigationController?.pushViewController(DetailPersetujuanTukarShiftVC(), animated: true)
    }
    
    @IBAction func buttonTukarShiftClick(_ sender: Any) {
        changePage(value: 1)
        collectionPersetujuan.reloadData()
    }
    
    @IBAction func buttonIzinCutiClick(_ sender: Any) {
        changePage(value: 0)
        collectionPersetujuan.reloadData()
    }
}
