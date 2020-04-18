//
//  ProfileVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import DIKit
import RxSwift

class ProfileVC: BaseViewController {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var fieldNIP: CustomTextField!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var fieldPosition: CustomTextField!
    @IBOutlet weak var fieldUnit: CustomTextField!
    @IBOutlet weak var labelUsername: CustomLabel!
    
    @Inject var profileVM: ProfileVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        profileVM.hasNewImage.subscribe(onNext: { value in
            if value {
                self.imageUser.image = self.profileVM.image.value
            }
        }).disposed(by: disposeBag)
    }

    private func setupEvent() {
        viewImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImageClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        imageUser.loadUrl("https://ppmschool.ac.id/id/wp-content/uploads/2016/01/tutor-8.jpg")
    }
}

extension ProfileVC {
    @IBAction func buttonKeluarClick(_ sender: Any) {
        networking.logout { (error, success, isExpired) in
            self.resetData()
        }
    }
    
    @IBAction func buttonSettingClick(_ sender: Any) {
        //let settingsVC = UINavigationController.init(rootViewController: SettingsVC())
        //settingsVC.isNavigationBarHidden = true
        //self.present(settingsVC, animated: true, completion: nil)
        navigationController?.pushViewController(SettingsVC(), animated: true)
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
