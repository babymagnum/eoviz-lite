//
//  DaftarPresensiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DaftarPresensiCell: UICollectionViewCell {

    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var buttonStatus: CustomButton!
    @IBOutlet weak var labelJamMasuk: CustomLabel!
    @IBOutlet weak var labelJamMasukReal: CustomLabel!
    @IBOutlet weak var labelJamKeluar: CustomLabel!
    @IBOutlet weak var labelJamKeluarReal: CustomLabel!
    
    var data: PresensiItem? {
        didSet {
            if let _data = data {
                labelDate.text = _data.date
                buttonStatus.setTitle(_data.status, for: .normal)
                labelJamMasuk.text = _data.jamMasuk
                labelJamMasukReal.text = _data.jamMasukReal
                labelJamKeluar.text = _data.jamKeluar
                labelJamKeluarReal.text = _data.jamKeluarReal
            }
        }
    }

}
