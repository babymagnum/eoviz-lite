//
//  ProfileVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets

class ProfileVC: BaseViewController {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var fieldNIP: CustomTextField!
    @IBOutlet weak var imageSettings: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var fieldPosition: CustomTextField!
    @IBOutlet weak var fieldUnit: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
    }

    private func setupEvent() {
        viewImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImageClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.corners = [.topLeft, .topRight]
    }
    
    private func setupView() {
        imageUser.loadUrl("https://ppmschool.ac.id/id/wp-content/uploads/2016/01/tutor-8.jpg")
    }
    
    @IBAction func buttonKeluarClick(_ sender: Any) {
        resetData()
    }
    
    @objc func viewImageClick() {
        let sheetController = SheetViewController(controller: BottomSheetProfilVC(), sizes: [.fixed(screenWidth * 0.55)])
        sheetController.handleColor = UIColor.clear
        sheetController.didDismiss = { _ in
            // do something when bottom sheet is collapsed
        }
        
        self.present(sheetController, animated: false, completion: nil)
    }
}
