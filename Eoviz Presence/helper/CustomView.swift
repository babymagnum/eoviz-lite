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
    @IBInspectable var corners: UIRectCorner = [] { didSet { updateView() }}
    @IBInspectable var useShadow: Bool = false { didSet { updateView() }}
    
    func updateView() {
        if !corners.isEmpty {
            roundCorners(corners, radius: borderRadius)
        } else {
            layer.cornerRadius = borderRadius
        }
        
        if useShadow {
            addShadow(CGSize(width: 1, height: 4), UIColor.init(hexString: "000000").withAlphaComponent(0.1), 3, 1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
}
