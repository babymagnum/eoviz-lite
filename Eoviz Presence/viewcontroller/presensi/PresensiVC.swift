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

class PresensiVC: BaseViewController, DialogAlertProtocol {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        
        observeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presensiVM.preparePresence(navigationController: navigationController)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func observeData() {
        presensiVM.time.subscribe(onNext: { value in
            self.labelTime.text = value == "" ? "\(PublicFunction.getStringDate(pattern: "HH:mm:ss")) WIB" : value
        }).disposed(by: disposeBag)
        
        presensiVM.presence.subscribe(onNext: { data in
            guard let value = data.data else { return }
            self.presenceData = value
            self.labelDate.text = value.date ?? ""
            self.labelJamMasuk.text = value.presence_shift_start ?? ""
            self.labelJamKeluar.text = value.presence_shift_end ?? ""
            self.labelShift.text = value.shift_name ?? ""
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
        
        presensiVM.isCantPresence.subscribe(onNext: { value in
            if value != "" {
                let vc = DialogAlert()
                vc.delegate = self
                vc.stringDescription = value
                self.showCustomDialog(vc)
                self.presensiVM.isCantPresence.accept("")
            }
        }).disposed(by: disposeBag)
    }
    
    func nextAction(nc: UINavigationController?) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupEvent() {
        viewMasuk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMasukClick)))
        viewKeluar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKeluarClick)))
    }

}

extension PresensiVC {
    private func pushToPresenceMap() {
        let vc = PresenceMapVC()
        vc.presenceData = presenceData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewKeluarClick() {
        if !(presenceData.is_presence_in ?? false) {
            showAlertDialog(image: nil, description: presensiVM.presence.value.messages[0])
        } else {
            pushToPresenceMap()
        }
    }
    
    @objc func viewMasukClick() {
        if presenceData.is_presence_in ?? false {
            showAlertDialog(image: nil, description: presensiVM.presence.value.messages[0])
        } else {
            pushToPresenceMap()
        }
    }
    
    @IBAction func buttonHistoryClick(_ sender: Any) {
        navigationController?.pushViewController(DaftarPresensiVC(), animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
