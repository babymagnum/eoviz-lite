//
//  DetailIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD

class DetailIzinCutiVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDiajukanPada: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var viewStatus: CustomGradientView!
    @IBOutlet weak var imagePengaju: CustomImage!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelJenis: CustomLabel!
    @IBOutlet weak var labelAlasan: CustomLabel!
    @IBOutlet weak var labelTanggalCuti: CustomLabel!
    @IBOutlet weak var collectionInformasiStatus: UICollectionView!
    @IBOutlet weak var collectionInformasiStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var labelCatatan: CustomLabel!
    @IBOutlet weak var viewCatatan: UIView!
    @IBOutlet weak var viewCatatanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewActionParent: UIView!
    @IBOutlet weak var viewActionParentHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAction: CustomGradientView!
    @IBOutlet weak var viewInformasiStatus: CustomView!
    
    @Inject private var detailIzinCutiVM: DetailIzinCutiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
        
        detailIzinCutiVM.getInformasiStatus()
    }
    
    private func observeData() {
        detailIzinCutiVM.listInformasiStatus.subscribe(onNext: { value in
            self.collectionInformasiStatus.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionInformasiStatusHeight.constant = self.collectionInformasiStatus.contentSize.height
                    self.viewInformasiStatus.layoutIfNeeded()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        collectionInformasiStatus.register(UINib(nibName: "InformasiStatusCell", bundle: .main), forCellWithReuseIdentifier: "InformasiStatusCell")
        collectionInformasiStatus.delegate = self
        collectionInformasiStatus.dataSource = self
        
//        viewActionParent.isHidden = true
//        viewActionParentHeight.constant = 0
        
        viewCatatanHeight.constant = 0
        viewCatatan.isHidden = true
    }
    
    private func setupEvent() {
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension DetailIzinCutiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailIzinCutiVM.listInformasiStatus.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformasiStatusCell", for: indexPath) as! InformasiStatusCell
        cell.data = detailIzinCutiVM.listInformasiStatus.value[indexPath.item]
        cell.viewDot.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.isHidden = indexPath.item == detailIzinCutiVM.listInformasiStatus.value.count - 1
        cell.viewLineTop.isHidden = indexPath.item == 0
        cell.viewLineTop.backgroundColor = indexPath.item <= 1 ? UIColor.windowsBlue : UIColor.slateGrey
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let statusWidth = (screenWidth - 60 - 30) * 0.2
        let textMargin = screenWidth - 119 - statusWidth
        let item = detailIzinCutiVM.listInformasiStatus.value[indexPath.item]
        let nameHeight = item.name.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
        let typeHeight = item.type.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
        let dateTimeHeight = item.dateTime.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 10 + PublicFunction.dynamicSize()))
        return CGSize(width: screenWidth - 60 - 30, height: nameHeight + typeHeight + dateTimeHeight + 10)
    }
}

extension DetailIzinCutiVC {
    @objc func viewActionClick() {
        showCustomDialog(DialogBatalkanIzinCutiVC())
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
