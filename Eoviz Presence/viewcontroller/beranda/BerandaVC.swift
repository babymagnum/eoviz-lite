//
//  BerandaVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

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
    
    var listBerandaData = [
        BerandaData(image: "clock", content: "percentage_npresence".localize(), percentage: 0.71, percentageContent: "71%"),
        BerandaData(image: "koper", content: "leave_nquota".localize(), percentage: 10/16, percentageContent: "10")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
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
