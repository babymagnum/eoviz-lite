//
//  BulanTahunModel.swift
//  Eoviz Lite
//
//  Created by Arief Zainuri on 09/07/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct BulanTahun: Decodable {
    var status: Bool
    var messages = [String]()
    var data: BulanTahunData?
}

struct BulanTahunData: Decodable {
    var month = [BulanItem]()
    var year = [Int]()
}

struct BulanItem: Decodable {
    var number: Int?
    var name: String?
}
