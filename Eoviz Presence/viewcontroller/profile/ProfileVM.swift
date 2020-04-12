//
//  ProfileVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 12/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ProfileVM {
    var imageData = BehaviorRelay(value: Data())
    var image = BehaviorRelay(value: UIImage())
    var hasNewImage = BehaviorRelay(value: false)
    
    func updateImage(_imageData: Data, _image: UIImage) {
        imageData.accept(_imageData)
        image.accept(_image)
        hasNewImage.accept(true)
    }
}
