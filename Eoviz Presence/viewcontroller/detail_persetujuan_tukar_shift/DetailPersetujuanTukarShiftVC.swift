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
    
    private var disposeBag = DisposeBag()
    @Inject private var detailPersetujuanTukarShiftVM: DetailPersetujuanTukarShiftVM
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
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
    }
    
    private func setupView() {
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension DetailPersetujuanTukarShiftVC {
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        detailPersetujuanTukarShiftVM.isApprove.accept(mySwitch.isOn)
    }
}
