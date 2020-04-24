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
    
    var data: InformationStatusItem? {
        didSet {
            if let _data = data {
                labelName.text = _data.emp_name
                labelType.text = _data.exchange_status
                labelDateTime.text = _data.status_datetime
                labelStatus.text = getStatusString(status: _data.status ?? 0)
                imageStatus.image = getStatusImage(status: _data.status ?? 0)
            }
        }
    }
    
    private func getStatusImage(status: Int) -> UIImage? {
        if status == 0 {
            return UIImage(named: "24BasicCircleChecked")
        } else if status == 1 {
            return UIImage(named: "alarm24Px")
        } else if status == 2 {
            return UIImage(named: "24BasicCircleX")
        } else {
            return UIImage(named: "24BasicCircleGreen")
        }
    }
    
    private func getStatusString(status: Int) -> String {
        //0=submitted,1=waiting, 2=rejected, 3=approved
        
        if status == 0 {
            return "Submitted"
        } else if status == 1 {
            return "Waiting"
        } else if status == 2 {
            return "Rejected"
        } else {
            return "Approved"
        }
    }
}
