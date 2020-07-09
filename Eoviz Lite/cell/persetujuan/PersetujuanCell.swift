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
    
    var data: ExchangeShiftApprovalItem? {
        didSet {
            if let _data = data {
                imageUser.loadUrl(_data.photo ?? "")
                labelDate.text = _data.request_date
                labelContent.text = _data.content
            }
        }
    }
    
}
