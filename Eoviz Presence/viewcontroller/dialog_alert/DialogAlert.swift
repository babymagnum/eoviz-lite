//
//  DialogAlert.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DialogAlert: BaseViewController {

    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonOke: CustomButton!
    @IBOutlet weak var imageX: UIImageView!
    
    var stringDescription: String?
    var image: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initView() {
        buttonOke.corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        viewContainer.layer.cornerRadius = 4
        labelDescription.text = stringDescription
        if let image = image {
            imageX.image = UIImage(named: image)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.2) {
                let descriptionHeight = self.labelDescription.text?.getHeight(withConstrainedWidth: self.screenWidth - 40, font: UIFont(name: "Poppins-Medium", size: 16)!) ?? 0
                self.viewContainerHeight.constant = self.imageX.frame.height + self.buttonOke.frame.height + 171 + descriptionHeight
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func buttonOkeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
