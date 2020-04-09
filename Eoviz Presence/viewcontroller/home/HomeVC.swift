//
//  HomeVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift

class HomeVC: BaseViewController {

    @IBOutlet weak var labelTest: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTestClick)))
    }

    @objc func labelTestClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
