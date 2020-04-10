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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        
        viewCornerParent.roundCorners([.topLeft, .topRight], radius: 50)
        imageUser.loadUrl("https://ppmschool.ac.id/id/wp-content/uploads/2016/01/tutor-8.jpg")
        collectionData.delegate = self
        //collectionData.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

//extension BerandaVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
