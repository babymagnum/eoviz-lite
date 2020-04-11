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
    @IBInspectable var corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight] { didSet { updateView() }}
    @IBInspectable var useShadow: Bool = false { didSet { updateView() }}
    @IBInspectable var isRoundedAllCorner: Bool = false { didSet { updateView() }}
    
    func updateView() {
        if !corners.isEmpty {
            roundCorners(corners, radius: borderRadius, roundRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        } else {
            if isRoundedAllCorner {
                layer.cornerRadius = frame.size.height / 2
            } else {
                layer.cornerRadius = borderRadius
            }
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
