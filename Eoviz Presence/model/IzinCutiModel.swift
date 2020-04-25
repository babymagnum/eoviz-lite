//
//  IzinCuti.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 19/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct TanggalCutiItem {
    var date: String
    var isLast: Bool
    var isFirst: Bool
    var isOnlyOne: Bool
}

// MARK: Tipe Cuti
struct TipeCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: TipeCutiData?
}

struct TipeCutiData: Decodable {
    var list = [TipeCutiItem]()
}

struct TipeCutiItem: Decodable {
    var perstype_id: Int?
    var perstype_name: String?
    var is_range: Int?
    var is_quota_reduce: Int?
    var is_allow_backdate: Int?
    var max_date: Int?
}

// MARK: Jatah Cuti
struct JatahCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: JatahCutiData?
}

struct JatahCutiData: Decodable {
    var list = [JatahCutiItem]()
}

struct JatahCutiItem: Decodable {
    var start: String?
    var end: String?
    var expired: String?
    var quota: Int?
    var taken: Int?
    var available: Int?
}
