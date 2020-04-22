//
//  DialogAlertArrayVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 22/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DialogAlertArrayVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionError: UICollectionView!
    @IBOutlet weak var buttonAction: CustomButton!
    @IBOutlet weak var collectionErrorHeight: NSLayoutConstraint!
    
    var listException = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        buttonAction.setTitle("understand".localize(), for: .normal)
        
        collectionError.register(UINib(nibName: "ExceptionCell", bundle: .main), forCellWithReuseIdentifier: "ExceptionCell")
        collectionError.dataSource = self
        collectionError.delegate = self
        
        collectionError.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.collectionErrorHeight.constant = self.collectionError.contentSize.height
        }
    }

    @IBAction func buttonActionClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DialogAlertArrayVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listException.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExceptionCell", for: indexPath) as! ExceptionCell
        cell.labelException.text = listException[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = listException[indexPath.item]
        let contentHeight = item.getHeight(withConstrainedWidth: screenWidth - 60 - 40 - 18, font: UIFont(name: "Poppins-Medium", size: 16 + PublicFunction.dynamicSize()))
        return CGSize(width: screenWidth - 60 - 40, height: contentHeight + 20)
    }
}
