//
//  ChangeLanguageVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class ChangeLanguageVC: BaseViewController {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var viewBahasaIndonesia: CustomView!
    @IBOutlet weak var viewEnglish: CustomView!
    @IBOutlet weak var buttonIndonesia: UIButton!
    @IBOutlet weak var buttonEnglish: UIButton!
    
    private var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
    }
    
    private func setupEvent() {
        viewBahasaIndonesia.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBahasaIndonesiaClick)))
        viewEnglish.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewEnglishClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
        language = preference.getString(key: constant.LANGUAGE)
        
        if language == "" || language == constant.INDONESIA {
            buttonEnglish.isHidden = true
        } else {
            buttonIndonesia.isHidden = true
        }
    }
}

extension ChangeLanguageVC {
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewEnglishClick() {
        if language != constant.ENGLISH {
            PublicFunction.showUnderstandDialog(self, "change_language?".localize(), "Apakah anda yakin mau mengganti bahasa menjadi English?", "Ya", "Tidak") {
                self.preference.saveString(value: self.constant.ENGLISH, key: self.constant.LANGUAGE)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func viewBahasaIndonesiaClick() {
        if language != constant.INDONESIA {
            PublicFunction.showUnderstandDialog(self, "change_language?".localize(), "Are you sure want to change the language to Bahasa Indonesia?", "Yes", "No") {
                self.preference.saveString(value: self.constant.INDONESIA, key: self.constant.LANGUAGE)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
