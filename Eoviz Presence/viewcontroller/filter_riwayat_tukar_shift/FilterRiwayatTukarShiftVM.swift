//
//  FilterRiwayatTukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterRiwayatTukarShiftVM: BaseViewModel {
    var statusId = BehaviorRelay(value: 0)
    var status = BehaviorRelay(value: "")
    var tahun = BehaviorRelay(value: "")
    var applyFilter = BehaviorRelay(value: false)
    var typePicker = BehaviorRelay(value: "")
    
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
