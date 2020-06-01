//
//  SplashModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 01/06/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct CheckVersion: Decodable {
    var status: Bool
    var messages = [String]()
    var data: CheckVersionData?
}

struct CheckVersionData: Decodable {
    var must_update: Bool?
}
