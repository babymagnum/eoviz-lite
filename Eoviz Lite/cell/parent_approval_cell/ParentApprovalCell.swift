//
//  ParentApprovalCell.swift
//  Eoviz Lite
//
//  Created by Arief Zainuri on 10/07/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift

class ParentApprovalCell: BaseCollectionViewCell, UICollectionViewDelegate {

    @IBOutlet weak var collectionApproval: UICollectionView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var viewEmptyHeight: NSLayoutConstraint!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    var navigationController: UINavigationController?
    var position: Int? {
        didSet {
            if let _position = position {
                observeData(position: _position)
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    @Inject private var approvalVM: ApprovalVM
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.windowsBlue
        return refreshControl
    }()
    
    private func observeData(position: Int) {
        approvalVM.currentPage.subscribe(onNext: { value in
            self.getData(isFirst: true, position: value)
        }).disposed(by: disposeBag)
        
        if position == 0 {
            approvalVM.loadingIzinCuti.subscribe(onNext: { value in
                if value {
                    self.hideViewEmpty(animate: true)
                }
                self.collectionApproval.collectionViewLayout.invalidateLayout()
            }).disposed(by: disposeBag)
            
            approvalVM.listIzinCuti.subscribe(onNext: { _ in
                self.collectionApproval.reloadData()
            }).disposed(by: disposeBag)
            
            approvalVM.emptyIzinCuti.subscribe(onNext: { value in
                self.labelEmpty.text = value
            }).disposed(by: disposeBag)
            
            approvalVM.showEmptyIzinCuti.subscribe(onNext: { value in
                UIView.animate(withDuration: 0.2) {
                    self.viewEmpty.isHidden = !value
                    self.viewEmptyHeight.constant = value ? 10000 : 0
                    self.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
        } else {
            approvalVM.loadingTukarShift.subscribe(onNext: { value in
                if value {
                    self.hideViewEmpty(animate: true)
                }
                self.collectionApproval.collectionViewLayout.invalidateLayout()
            }).disposed(by: disposeBag)
            
            approvalVM.listTukarShift.subscribe(onNext: { _ in
                self.collectionApproval.reloadData()
            }).disposed(by: disposeBag)
            
            approvalVM.emptyTukarShift.subscribe(onNext: { value in
                self.labelEmpty.text = value
            }).disposed(by: disposeBag)
            
            approvalVM.showEmptyTukarShift.subscribe(onNext: { value in
                UIView.animate(withDuration: 0.2) {
                    self.viewEmpty.isHidden = !value
                    self.viewEmptyHeight.constant = value ? 10000 : 0
                    self.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
        }
    }
    
    private func setupCollection() {
        collectionApproval.register(UINib(nibName: "PersetujuanCell", bundle: .main), forCellWithReuseIdentifier: "PersetujuanCell")
        collectionApproval.register(UINib(nibName: "LoadingCell", bundle: .main), forCellWithReuseIdentifier: "LoadingCell")
        collectionApproval.register(UINib(nibName: "IzinCutiCell", bundle: .main), forCellWithReuseIdentifier: "IzinCutiCell")
        collectionApproval.delegate = self
        collectionApproval.dataSource = self
        collectionApproval.addSubview(refreshControl)
    }
    
    private func hideViewEmpty(animate: Bool) {
        UIView.animate(withDuration: animate ? 0.2 : 0) {
            self.viewEmpty.isHidden = true
            self.viewEmptyHeight.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hideViewEmpty(animate: false)
        
        setupCollection()
    }
    
    private func getData(isFirst: Bool, position: Int) {
        if position == 0 {
            approvalVM.getIzinCuti(isFirst: isFirst, nc: navigationController)
        } else {
            approvalVM.getTukarShift(isFirst: isFirst, nc: navigationController)
        }
    }
}

extension ParentApprovalCell {
    @objc private func handleRefresh(_ rc: UIRefreshControl) {
        rc.endRefreshing()
        getData(isFirst: true, position: position ?? 0)
    }
    
    @objc func cellClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionApproval.indexPathForItem(at: sender.location(in: collectionApproval)) else { return }
        
        if position ?? 0 == 0 {
            let item = approvalVM.listIzinCuti.value[indexpath.item]
            let vc = DetailPersetujuanIzinCutiVC()
            vc.leaveId = item.leave_id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let item = approvalVM.listTukarShift.value[indexpath.item]
            let vc = DetailPersetujuanTukarShiftVC()
            vc.shiftExchangeId = item.shift_exchange_id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ParentApprovalCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if position ?? 0 == 0 {
            if indexPath.item == approvalVM.listIzinCuti.value.count - 1 {
                approvalVM.getIzinCuti(isFirst: false, nc: navigationController)
            }
        } else {
            if indexPath.item == approvalVM.listTukarShift.value.count - 1 {
                approvalVM.getTukarShift(isFirst: false, nc: navigationController)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if position ?? 0 == 0 {
            return approvalVM.listIzinCuti.value.count + 1
        } else {
            return approvalVM.listTukarShift.value.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if position ?? 0 == 0 {
            if indexPath.item == approvalVM.listIzinCuti.value.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
                cell.activityIndicator.isHidden = !approvalVM.loadingIzinCuti.value
                cell.activityIndicator.startAnimating()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IzinCutiCell", for: indexPath) as! IzinCutiCell
                cell.data = approvalVM.listIzinCuti.value[indexPath.item]
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellClick(sender:))))
                return cell
            }
        } else {
            if indexPath.item == approvalVM.listTukarShift.value.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
                cell.activityIndicator.isHidden = !approvalVM.loadingTukarShift.value
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
        let textMargin = screenWidth - 60 - 30 - imageSize - 15
        
        if position ?? 0 == 0 {
            if indexPath.item == approvalVM.listIzinCuti.value.count {
                return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
            } else {
                let item = approvalVM.listIzinCuti.value[indexPath.item]
                let dateHeight = item.request_date?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Roboto-Medium", size: 11 + PublicFunction.dynamicSize())) ?? 0
                let nameHeight = item.emp_name?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize())) ?? 0
                let typeHeight = item.leave_type?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
                let dateCutiHeight = item.leave_date?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Roboto-Medium", size: 11 + PublicFunction.dynamicSize())) ?? 0
                return CGSize(width: screenWidth - 60, height: dateHeight + nameHeight + typeHeight + dateCutiHeight + 43)
            }
        } else {
            if indexPath.item == approvalVM.listTukarShift.value.count {
                return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
            } else {
                let item = approvalVM.listTukarShift.value[indexPath.item]
                let dateHeight = item.request_date?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Roboto-Medium", size: 11 + PublicFunction.dynamicSize())) ?? 0
                let contentHeight = item.content?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
                return CGSize(width: screenWidth - 60, height: dateHeight + contentHeight + 37)
            }
        }
    }
}
