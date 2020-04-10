//
//  CustomButton.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 12/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var fontName: String = "Poppins-Medium.ttf" { didSet { updateFonts() }}
    @IBInspectable var fontSize: CGFloat = 16 { didSet { updateFonts() }}
    
    func updateFonts() {
        titleLabel?.font = UIFont(name: fontName, size: fontSize + PublicFunction.addDynamicSize())
    }
}
