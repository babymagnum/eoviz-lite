//
//  BaseViewModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

class BaseViewModel {
    
    lazy var networking: Networking = {
        return Networking()
    }()
    
    lazy var preference: Preference = {
        return Preference()
    }()
    
    lazy var constant: Constant = {
        return Constant()
    }()
}
