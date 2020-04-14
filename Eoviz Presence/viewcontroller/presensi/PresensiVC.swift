//
//  PresensiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD

enum PresenceType {
    case masuk
    case keluar
}

class PresensiVC: BaseViewController {

    @IBOutlet weak var labelTime: CustomLabel!
    @IBOutlet weak var labelJamMasuk: CustomLabel!
    @IBOutlet weak var labelJamKeluar: CustomLabel!
    @IBOutlet weak var viewMasuk: UIView!
    @IBOutlet weak var viewKeluar: CustomGradientView!
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelShift: CustomLabel!
    @IBOutlet weak var viewJamMasukKeluar: CustomView!
    
    @Inject var presensiVM: PresensiVM
    private var disposeBag = DisposeBag()
    private var presenceData = PresensiData()
    private var presenceType = PresenceType.masuk
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
        
        observeData()
        
        presensiVM.preparePresence()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func observeData() {
        presensiVM.time.subscribe(onNext: { value in
            self.labelTime.text = value == "" ? "\(PublicFunction.getStringDate(pattern: "HH:mm:ss")) WIB" : value
        }).disposed(by: disposeBag)
        
        presensiVM.presence.subscribe(onNext: { value in
            self.presenceData = value
            self.labelDate.text = value.date ?? ""
            self.labelJamMasuk.text = value.presence_shift_start ?? ""
            self.labelJamKeluar.text = value.presence_shift_end ?? ""
            self.labelShift.text = value.shift_name ?? ""
            self.presenceType = value.is_presence_in ?? false ? PresenceType.masuk : PresenceType.keluar
        }).disposed(by: disposeBag)
        
        presensiVM.error.subscribe(onNext: { value in
            if value != "" {
                self.showAlertDialog(description: value)
            }
        }).disposed(by: disposeBag)
        
        presensiVM.isExpired.subscribe(onNext: { value in
            if value {
                self.forceLogout(self.navigationController!)
            }
        }).disposed(by: disposeBag)
        
        presensiVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
                self.addBlurView(view: self.view)
            } else {
                SVProgressHUD.dismiss()
                self.removeBlurView(view: self.view)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewMasuk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMasukClick)))
        viewKeluar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKeluarClick)))
    }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }

}

extension PresensiVC {
    private func pushToPresenceMap() {
        let vc = PresenceMapVC()
        vc.presenceData = presenceData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewKeluarClick() {
        if presenceType == .keluar {
            pushToPresenceMap()
        } else {
            showAlertDialog(description: "its_time_for_presence_in".localize())
        }
    }
    
    @objc func viewMasukClick() {
        if presenceType == .masuk {
            pushToPresenceMap()
        } else {
            showAlertDialog(description: "its_time_for_presence_out".localize())
        }
    }
    
    @IBAction func buttonHistoryClick(_ sender: Any) {
        
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
