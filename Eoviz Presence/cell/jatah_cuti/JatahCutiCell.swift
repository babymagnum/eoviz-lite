//
//  JatahCutiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 19/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class JatahCutiCell: BaseCollectionViewCell {
    
    @IBOutlet weak var labelPeriode: CustomLabel!
    @IBOutlet weak var labelJatahCuti: CustomLabel!
    @IBOutlet weak var labelTerambil: CustomLabel!
    @IBOutlet weak var labelSisaCuti: CustomLabel!
    @IBOutlet weak var labelKadaluarsa: CustomLabel!
    
    var data: JatahCutiItem? {
        didSet {
            if let _data = data {
                labelPeriode.text = _data.periode
                labelJatahCuti.text = _data.jatahCuti
                labelTerambil.text = _data.terambil
                labelSisaCuti.text = _data.sisaCuti
                labelKadaluarsa.text = _data.kadaluarsa
            }
        }
    }
}
