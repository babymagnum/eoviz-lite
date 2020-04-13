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

class PresensiVC: BaseViewController {

    @IBOutlet weak var labelTime: CustomLabel!
    @IBOutlet weak var labelJamMasuk: CustomLabel!
    @IBOutlet weak var labelJamKeluar: CustomLabel!
    @IBOutlet weak var viewMasuk: UIView!
    @IBOutlet weak var viewKeluar: CustomGradientView!
    @IBOutlet weak var viewParent: CustomView!
    
    @Inject var berandaVM: BerandaVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        berandaVM.time.subscribe(onNext: { value in
            self.labelTime.text = value
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewMasuk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMasukClick)))
        viewKeluar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKeluarClick)))
    }
    
    private func setupView() {
        viewParent.corners = [.topLeft, .topRight]
    }

}

extension PresensiVC {
    @objc func viewKeluarClick() {
        
    }
    
    @objc func viewMasukClick() {
        
    }
    
    @IBAction func buttonHistoryClick(_ sender: Any) {
        
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
