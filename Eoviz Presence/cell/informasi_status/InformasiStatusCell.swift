//
//  InformasiStatusCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class InformasiStatusCell: BaseCollectionViewCell {

    @IBOutlet weak var viewDot: CustomView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelType: CustomLabel!
    @IBOutlet weak var labelDateTime: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var viewLineTop: UIView!
    
    var data: InformasiStatusItem? {
        didSet {
            if let _data = data {
                labelName.text = _data.name
                labelType.text = _data.type
                labelDateTime.text = _data.dateTime
                labelStatus.text = _data.status
                if _data.status == "submitted" {
                    imageStatus.image = UIImage(named: "24BasicCircleChecked")
                } else if _data.status == "rejected" {
                    imageStatus.image = UIImage(named: "24BasicCircleX")
                } else {
                    imageStatus.image = UIImage(named: "24BasicCircleGreen")
                }
            }
        }
    }
}
