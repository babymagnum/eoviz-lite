//
//  CustomMargin.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomMargin: NSLayoutConstraint {
    @IBInspectable var multi: Double = 0.5 { didSet { updateView() }}
    
    func updateView() {
        constant = UIScreen.main.bounds.width * CGFloat(multi)
    }
}
