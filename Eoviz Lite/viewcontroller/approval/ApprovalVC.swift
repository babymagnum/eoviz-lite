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
    @IBOutlet weak var collectionPersetujuan: UICollectionView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var collectionPersetujuanMarginBottom: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    @Inject private var approvalVM: ApprovalVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionParent()
        
        observeData()
        
        if #available(iOS 11, *) {
            //do nothing
        } else {
            collectionPersetujuanMarginBottom.constant += 40 // 49 is height of ui tabbar
        }
    }
    
    private func observeData() {
        approvalVM.isReset.subscribe(onNext: { value in
            if value {
                self.changePage(value: 0, isManually: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupCollectionParent() {
        collectionPersetujuan.register(UINib(nibName: "ParentApprovalCell", bundle: .main), forCellWithReuseIdentifier: "ParentApprovalCell")
        collectionPersetujuan.delegate = self
        collectionPersetujuan.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        changePage(value: currentPage, isManually: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension ApprovalVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParentApprovalCell", for: indexPath) as! ParentApprovalCell
        cell.navigationController = navigationController
        cell.position = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: collectionPersetujuan.frame.height)
    }

}

extension ApprovalVC {
    private func changePage(value: Int, isManually: Bool) {
        approvalVM.resetList()
        approvalVM.currentPage.accept(value)
        
        UIView.animate(withDuration: 0.2) {
            // change background color
            self.buttonIzinCuti.backgroundColor = value == 0 ? UIColor.windowsBlue : UIColor.veryLightPinkSix
            self.buttonTukarShift.backgroundColor = value == 1 ? UIColor.windowsBlue : UIColor.veryLightPinkSix

            // change text color
            self.buttonIzinCuti.setTitleColor(value == 0 ? UIColor.whiteTwo : UIColor.slateGrey, for: .normal)
            self.buttonTukarShift.setTitleColor(value == 1 ? UIColor.whiteTwo : UIColor.slateGrey, for: .normal)
            self.view.layoutIfNeeded()
        }
        
        if isManually {
            collectionPersetujuan.scrollToItem(at: IndexPath(item: value, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func buttonTukarShiftClick(_ sender: Any) {
        changePage(value: 1, isManually: true)
    }
    
    @IBAction func buttonIzinCutiClick(_ sender: Any) {
        changePage(value: 0, isManually: true)
    }
}
