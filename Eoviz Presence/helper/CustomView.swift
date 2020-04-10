//
//  CustomView.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 09/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable var borderRadius: CGFloat = 16 { didSet { updateView() }}
    
    func updateView() {
        layer.cornerRadius = borderRadius
    }
    
}
