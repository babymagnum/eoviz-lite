//
//  BottomSheetProfilVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

class BottomSheetProfilVC: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var viewAmbilFoto: UIView!
    @IBOutlet weak var viewPilihFoto: UIView!
    
    @Inject var profileVM: ProfileVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }

    private func setupEvent() {
        viewAmbilFoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAmbilFotoClick)))
        viewPilihFoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPilihFotoClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension BottomSheetProfilVC {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            self.showAlertDialog(description: "please_take_another_photo".localize())
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        
        profileVM.updateImage(_imageData: imageData, _image: image)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func viewAmbilFotoClick() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            showAlertDialog(description: "device_has_no_camera".localize())
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func viewPilihFotoClick() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSObject!){
        guard let _image = image else {
            self.showAlertDialog(description: "image_cant_be_picked".localize())
            return
        }
        
        guard let imageData = _image.jpegData(compressionQuality: 0.1) else { return }
        
        profileVM.updateImage(_imageData: imageData, _image: _image)
        
        dismiss(animated: true, completion: nil)
    }
}
