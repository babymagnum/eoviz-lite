//
//  DetailPersetujuanTukarShift.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class DetailPersetujuanTukarShiftVC: BaseViewController {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var labelSwitch: CustomLabel!
    @IBOutlet weak var viewProses: CustomGradientView!
    
    private var disposeBag = DisposeBag()
    @Inject private var detailPersetujuanTukarShiftVM: DetailPersetujuanTukarShiftVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        detailPersetujuanTukarShiftVM.isApprove.subscribe(onNext: { value in
            self.labelSwitch.text = value ? "approve".localize() : "reject".localize()
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        switchStatus.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        viewProses.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewProsesClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension DetailPersetujuanTukarShiftVC: DialogPermintaanTukarShiftProtocol {
    func actionClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewProsesClick() {
        let vc = DialogPermintaanTukarShift()
        vc.delegate = self
        vc.content = detailPersetujuanTukarShiftVM.isApprove.value ? "approve_change_shift".localize() : "reject_change_shift".localize()
        vc.isApprove = detailPersetujuanTukarShiftVM.isApprove.value
        showCustomDialog(vc)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        detailPersetujuanTukarShiftVM.isApprove.accept(mySwitch.isOn)
    }
}
