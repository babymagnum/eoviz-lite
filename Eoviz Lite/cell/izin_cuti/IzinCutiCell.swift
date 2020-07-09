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
    @IBOutlet weak var labelCutiDate: CustomLabel!
    
    var data: LeaveApprovalItem? {
        didSet {
            if let _data = data {
                imageUser.loadUrl(_data.photo ?? "")
                labelDate.text = _data.request_date
                labelCutiDate.text = _data.leave_date
                labelName.text = _data.emp_name
                labelType.text = _data.leave_type
            }
        }
    }
}
