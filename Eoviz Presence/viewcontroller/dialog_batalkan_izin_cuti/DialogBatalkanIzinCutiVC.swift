//
//  DialogBatalkanIzinCuti.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DialogBatalkanIzinCutiVC: BaseViewController {

    @IBOutlet weak var textviewAlasan: CustomTextView!
    @IBOutlet weak var viewKembali: CustomGradientView!
    @IBOutlet weak var viewBatalkan: CustomGradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEvent()
    }

    private func setupEvent() {
        viewKembali.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKembaliClick)))
        viewBatalkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBatalkanClick)))
    }

}

extension DialogBatalkanIzinCutiVC {
    @objc func viewKembaliClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func viewBatalkanClick() {
        dismiss(animated: true, completion: nil)
    }
}
