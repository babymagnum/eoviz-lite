//
//  FilterRiwayatIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterRiwayatIzinCutiVM: BaseViewModel {
    var statusId = BehaviorRelay(value: "")
    var status = BehaviorRelay(value: "")
    var tahun = BehaviorRelay(value: "")
    var typePicker = BehaviorRelay(value: "")
    var listStatus = BehaviorRelay(value: ["All", "Saved", "Submitted", "Approved", "Canceled", "Rejected"])
    var listStatusId = BehaviorRelay(value: ["", "0", "1", "2", "3", "4"])
    var listYears : BehaviorRelay<[String]> {
        var years = [String]()
        let currentYears = Int(PublicFunction.getStringDate(pattern: "yyyy")) ?? 2020
        for i in (2000..<currentYears + 2).reversed() {
            years.append("\(i)")
        }
        return BehaviorRelay(value: years)
    }
    
    func setTahun(tahun: String) { self.tahun.accept(tahun) }
    
    func setTypePicker(typePicker: String) { self.typePicker.accept(typePicker) }
    
    func setStatus(status: String, statusId: String) {
        self.status.accept(status)
        self.statusId.accept(statusId)
    }
    
    func resetVariabel() {
        tahun.accept(PublicFunction.getStringDate(pattern: "yyyy"))
        status.accept("All")
        statusId.accept("")
    }
}
