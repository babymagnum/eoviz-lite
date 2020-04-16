//
//  PersetujuanCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class PersetujuanCell: BaseCollectionViewCell {

    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var viewDot: CustomView!
    @IBOutlet weak var viewDotWidth: NSLayoutConstraint!
    @IBOutlet weak var viewDotLeftMargin: NSLayoutConstraint!
    
    var data: PersetujuanItem? {
        didSet {
            if let _data = data {
                imageUser.loadUrl(_data.image)
                labelDate.text = _data.date
                labelContent.text = _data.content
                viewDot.isHidden = _data.isRead
                viewDotWidth.constant = _data.isRead ? 0 : 8
                viewDotLeftMargin.constant = _data.isRead ? 0 : 10
            }
        }
    }
}
