//
//  IzinCutiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class IzinCutiCell: BaseCollectionViewCell {

    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelType: CustomLabel!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var viewDot: CustomView!
    @IBOutlet weak var labelCutiDate: CustomLabel!
    
    var data: IzinCutiItem? {
        didSet {
            if let _data = data {
                imageUser.loadUrl(_data.image)
                labelDate.text = _data.date
                labelCutiDate.text = _data.cutiDate
                labelName.text = _data.nama
                labelType.text = _data.type
                viewDot.isHidden = _data.isRead
                
                labelType.font = _data.isRead ? UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize()) : UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize())
                
                labelCutiDate.font = _data.isRead ? UIFont(name: "Poppins-Regular", size: 11 + PublicFunction.dynamicSize()) : UIFont(name: "Poppins-SemiBold", size: 11 + PublicFunction.dynamicSize())
            }
        }
    }
}
