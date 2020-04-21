//
//  RiwayatIzinCutiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class RiwayatIzinCutiCell: UICollectionViewCell {

    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelType: CustomLabel!
    @IBOutlet weak var labelCutiDate: CustomLabel!

    var data: RiwayatIzinCutiItem? {
        didSet {
            if let _data = data {
                imageStatus.image = UIImage(named: getImage(status: _data.status))
                labelStatus.text = _data.status.capitalizingFirstLetter()
                labelNomer.text = _data.nomer
                labelDate.text = _data.date
                labelType.text = _data.type
                labelCutiDate.text = _data.izinCutiDate
            }
        }
    }
    
    private func getImage(status: String) -> String {
        if status == "saved" {
            return "24GadgetsFloppy"
        } else if status == "submitted" {
            return "24BasicCircleChecked"
        } else if status == "approved" {
            return "24BasicCircleGreen"
        } else if status == "canceled" {
            return "24BasicCanceled"
        } else {
            return "24BasicCircleX"
        }
    }

}
