//
//  DetailPersetujuanIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD

class DetailPersetujuanIzinCutiVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewApprovalHeight: NSLayoutConstraint!
    @IBOutlet weak var viewApproval: UIView!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDiajukanPada: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelJenisCuti: CustomLabel!
    @IBOutlet weak var labelAlasan: CustomLabel!
    @IBOutlet weak var labelTanggalCuti: CustomLabel!
    @IBOutlet weak var collectionInformasiStatus: UICollectionView!
    @IBOutlet weak var switchApproval: UISwitch!
    @IBOutlet weak var labelApproval: CustomLabel!
    @IBOutlet weak var collectionCutiTahunan: UICollectionView!
    @IBOutlet weak var viewCatatanStatus: UIView!
    @IBOutlet weak var viewCatatanStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var textviewCatatanStatus: UITextView!
    @IBOutlet weak var viewCatatan: UIView!
    @IBOutlet weak var viewCatatanHeight: NSLayoutConstraint!
    @IBOutlet weak var labelCatatan: CustomLabel!
    @IBOutlet weak var viewActionParent: UIView!
    @IBOutlet weak var viewActionParentHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAction: CustomGradientView!
    @IBOutlet weak var collectionCutiTahunanHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionCutiTahunanTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var collectionInformasiStatusHeight: NSLayoutConstraint!
    
    @Inject private var detailPersetujuanIzinCutiVM: DetailPersetujuanIzinCutiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        observeData()
        
        setupEvent()
        
        detailPersetujuanIzinCutiVM.getCutiTahunan()
        
        detailPersetujuanIzinCutiVM.getInformasiStatus()
    }
    
    private func setupEvent() {
        switchApproval.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func observeData() {
        detailPersetujuanIzinCutiVM.listCutiTahunan.subscribe(onNext: { value in
            if !self.detailPersetujuanIzinCutiVM.dontReload.value {
                self.collectionCutiTahunan.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.collectionCutiTahunanHeight.constant = self.collectionCutiTahunan.contentSize.height
                }
            }
            
            let hasNoApprove = value.contains { item -> Bool in
                return !item.isApprove
            }
            
            self.switchApproval.setOn(!hasNoApprove, animated: true)
        }).disposed(by: disposeBag)
        
        detailPersetujuanIzinCutiVM.listInformasiStatus.subscribe(onNext: { value in
            self.collectionInformasiStatus.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.collectionInformasiStatusHeight.constant = self.collectionInformasiStatus.contentSize.height
            }
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    private func setupView() {
        collectionCutiTahunan.register(UINib(nibName: "CutiTahunanCell", bundle: .main), forCellWithReuseIdentifier: "CutiTahunanCell")
        collectionCutiTahunan.delegate = self
        collectionCutiTahunan.dataSource = self
        
        collectionInformasiStatus.register(UINib(nibName: "InformasiStatusCell", bundle: .main), forCellWithReuseIdentifier: "InformasiStatusCell")
        collectionInformasiStatus.delegate = self
        collectionInformasiStatus.dataSource = self
        
        viewCatatan.isHidden = true
        viewCatatanHeight.constant = 0
        
//        viewActionParent.isHidden = true
//        viewActionParentHeight.constant = 0
//
//        viewApproval.isHidden = true
//        viewApprovalHeight.constant = 0
//
//        viewCatatanStatus.isHidden = true
//        viewCatatanStatusHeight.constant = 0
//
//        collectionCutiTahunanTopMargin.constant = 0
    }
    
}

extension DetailPersetujuanIzinCutiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionInformasiStatus {
            return detailPersetujuanIzinCutiVM.listInformasiStatus.value.count
        } else {
            return detailPersetujuanIzinCutiVM.listCutiTahunan.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionInformasiStatus {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformasiStatusCell", for: indexPath) as! InformasiStatusCell
            cell.data = detailPersetujuanIzinCutiVM.listInformasiStatus.value[indexPath.item]
            cell.viewDot.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
            cell.viewLine.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
            cell.viewLine.isHidden = indexPath.item == detailPersetujuanIzinCutiVM.listInformasiStatus.value.count - 1
            cell.viewLineTop.isHidden = indexPath.item == 0
            cell.viewLineTop.backgroundColor = indexPath.item <= 1 ? UIColor.windowsBlue : UIColor.slateGrey
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CutiTahunanCell", for: indexPath) as! CutiTahunanCell
            cell.data = detailPersetujuanIzinCutiVM.listCutiTahunan.value[indexPath.item]
            cell.switchApproval.addTarget(self, action: #selector(switchCellChanged), for: UIControl.Event.valueChanged)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionInformasiStatus {
            let statusWidth = (screenWidth - 60 - 30) * 0.2
            let textMargin = screenWidth - 119 - statusWidth
            let item = detailPersetujuanIzinCutiVM.listInformasiStatus.value[indexPath.item]
            let nameHeight = item.name.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
            let typeHeight = item.type.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize()))
            let dateTimeHeight = item.dateTime.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 10 + PublicFunction.dynamicSize()))
            return CGSize(width: screenWidth - 60 - 30, height: nameHeight + typeHeight + dateTimeHeight + 10)
        } else {
            return CGSize(width: screenWidth - 60, height: screenWidth * 0.11)
        }
    }
}

extension DetailPersetujuanIzinCutiVC: DialogPermintaanTukarShiftProtocol {
    func actionClick() {
        print("dismis from controller class")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func viewActionClick() {
        let vc = DialogPermintaanTukarShift()
        vc.delegate = self
        vc.content = switchApproval.isOn ? "accept_leave_permission".localize() : "refuse_leave_permission".localize()
        vc.isApprove = switchApproval.isOn
        showCustomDialog(vc)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchCellChanged(mySwitch: UISwitch) {
        detailPersetujuanIzinCutiVM.dontReload.accept(true)
        
        //Get the point in cell
        let center: CGPoint = mySwitch.center
        let rootViewPoint: CGPoint = mySwitch.superview?.convert(center, to: collectionCutiTahunan) ?? CGPoint(x: 0, y: 0)
        // Now get the indexPath
        let indexPath = collectionCutiTahunan.indexPathForItem(at: rootViewPoint)
        
        guard let _indexpath = indexPath else { return }
        
        detailPersetujuanIzinCutiVM.changeApproval(index: _indexpath.item)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        detailPersetujuanIzinCutiVM.dontReload.accept(false)
        
        detailPersetujuanIzinCutiVM.changeAllApproval(isOn: mySwitch.isOn)
    }
}
