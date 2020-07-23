//
//  DialogBatalkanIzinCuti.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import Toast_Swift

protocol DialogBatalkanCutiProtocol {
    func actionClick(cancelNotes: String)
}

class DialogBatalkanIzinCutiVC: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var textviewAlasan: CustomTextView!
    @IBOutlet weak var viewKembali: CustomGradientView!
    @IBOutlet weak var viewBatalkan: CustomGradientView!
    
    var delegate: DialogBatalkanCutiProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
    }
    
    private func setupView() {
        viewBatalkan.startColor = UIColor.lightGray
        viewBatalkan.endColor = UIColor.lightGray
        textviewAlasan.text = "cancelation_reason".localize()
        textviewAlasan.textColor = UIColor.lightGray
        textviewAlasan.delegate = self
    }

    private func setupEvent() {
        viewKembali.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKembaliClick)))
        viewBatalkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBatalkanClick)))
    }

}

extension DialogBatalkanIzinCutiVC {
    func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2) {
            self.viewBatalkan.isUserInteractionEnabled = !textView.text.isEmpty
            
            if textView.text.isEmpty {
                self.viewBatalkan.startColor = UIColor.lightGray
                self.viewBatalkan.endColor = UIColor.lightGray
            } else {
                self.viewBatalkan.startColor = UIColor.rustRed.withAlphaComponent(0.8)
                self.viewBatalkan.endColor = UIColor.pastelRed.withAlphaComponent(0.8)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "cancelation_reason".localize()
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func viewKembaliClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func viewBatalkanClick() {
        dismiss(animated: true, completion: nil)
        delegate?.actionClick(cancelNotes: textviewAlasan.text.trim())
    }
}
