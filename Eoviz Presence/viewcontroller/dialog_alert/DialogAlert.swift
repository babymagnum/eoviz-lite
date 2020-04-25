//
//  DialogAlert.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

protocol DialogAlertProtocol {
    func nextAction(nc: UINavigationController?)
}

class DialogAlert: BaseViewController {

    @IBOutlet weak var labelDescription: CustomLabel!
    @IBOutlet weak var buttonOke: CustomButton!
    @IBOutlet weak var imageX: UIImageView!
    
    var stringDescription: String?
    var image: String?
    var delegate: DialogAlertProtocol?
    var nc: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        buttonOke.corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        labelDescription.text = stringDescription
        if let _image = image {
            imageX.image = UIImage(named: _image)
        }
    }

    @IBAction func buttonOkeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        if let _delegate = delegate {
            _delegate.nextAction(nc: nc)
        }
    }

}
