//
//  NotifikasiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class NotifikasiCell: UICollectionViewCell {

    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelTitle: CustomLabel!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var viewRedDot: CustomView!
    
    var data: NotifikasiData? {
        didSet {
            if let _data = data {
                labelDate.text = _data.date
                labelTitle.text = _data.title
                labelContent.text = _data.content
                
                viewRedDot.isHidden = _data.isRead
                labelTitle.font = UIFont(name: _data.isRead ? "Poppins-Regular" : "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize())
                labelContent.font = UIFont(name: _data.isRead ? "Poppins-Regular" : "Poppins-SemiBold", size: 11 + PublicFunction.dynamicSize())
            }
        }
    }

}
