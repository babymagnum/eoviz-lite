//
//  PersetujuanTanggalCutiCell.swift
//  Eoviz Lite
//
//  Created by Arief Zainuri on 23/07/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class PersetujuanTanggalCutiCell: BaseCollectionViewCell {

    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var imageStatusWidth: NSLayoutConstraint!
    @IBOutlet weak var imageStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var labelStatusRightMargin: NSLayoutConstraint!
    
    var item: DetailIzinCutiDatesItem? {
        didSet {
            if let _item = item {
                labelDate.text = _item.date
                generateStatus(status: _item.status ?? 0)
                generateImageStatus(status: _item.status ?? 0)
            }
        }
    }
    
    private func generateStatus(status: Int) {
        labelStatusRightMargin.constant = status == 0 ? 0 : 16
        
        if status == 0 {
            labelStatus.text = "-"
            labelStatus.textColor = UIColor.dark
        } else if status == 1 {
            labelStatus.text = "rejected".localize()
            labelStatus.textColor = UIColor.coral
        } else {
            labelStatus.text = "approved".localize()
            labelStatus.textColor = UIColor.tanGreen
        }
    }
    
    private func generateImageStatus(status: Int) {
        UIView.animate(withDuration: 0.2) {
            self.imageStatusHeight.constant = status == 0 ? 0 : 16
            self.imageStatusWidth.constant = status == 0 ? 0 : 16
            
            if status == 1 {
                self.imageStatus.image = UIImage(named: "24BasicCircleX")?.tinted(with: UIColor.coral)
            } else if status == 2 {
                self.imageStatus.image = UIImage(named: "24BasicCircleGreen")?.tinted(with: UIColor.tanGreen)
            }
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
