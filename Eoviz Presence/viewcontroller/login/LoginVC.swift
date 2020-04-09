//
//  LoginVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class LoginVC: BaseViewController {

    @IBOutlet weak var labelTest: UILabel!
    
    @Inject var splashVM: SplashVM
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        labelTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTestClick)))
        
        splashVM.test.subscribe { (event) in
            self.labelTest.text = event.element ?? ""
        }.disposed(by: disposeBag)
    }
    
    @objc func labelTestClick() {
        self.navigationController?.pushViewController(HomeVC(), animated: true)
    }
}
