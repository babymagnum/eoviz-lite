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
    var statusId = BehaviorRelay(value: 0)
    var status = BehaviorRelay(value: "")
    var tahun = BehaviorRelay(value: "")
    var applyFilter = BehaviorRelay(value: false)
    var typePicker = BehaviorRelay(value: "")
    var listStatus = BehaviorRelay(value: ["Semua", "Saved", "Submitted", "Approved", "Canceled", "Rejected"])
    var listStatusId = BehaviorRelay(value: ["1", "2", "3", "4", "5", "6"])
    var listYears : BehaviorRelay<[String]> {
        var years = [String]()
        let currentYears = Int(PublicFunction.getStringDate(pattern: "yyyy")) ?? 2020
        for i in (2000..<currentYears + 1).reversed() {
            years.append("\(i)")
        }
        return BehaviorRelay(value: years)
    }
    
    func setTahun(tahun: String) { self.tahun.accept(tahun) }
    
    func setTypePicker(typePicker: String) { self.typePicker.accept(typePicker) }
    
    func setStatus(status: String, statusId: Int) {
        self.status.accept(status)
        self.statusId.accept(statusId)
    }
    
    func resetData() {
        tahun.accept(PublicFunction.getStringDate(pattern: "yyyy"))
        status.accept("Semua")
        statusId.accept(0)
    }
}
