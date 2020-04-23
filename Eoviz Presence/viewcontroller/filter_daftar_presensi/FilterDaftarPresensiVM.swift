//
//  FilterDaftarPresensiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterDaftarPresensiVM {
    var fullDate = BehaviorRelay(value: "")
    var bulan = BehaviorRelay(value: "")
    var tahun = BehaviorRelay(value: "")
    var applyFilter = BehaviorRelay(value: false)
    
    func updateBulanTahun(fullDate: String) {
        let date = PublicFunction.dateStringTo(date: fullDate, fromPattern: "dd-MM-yyyy", toPattern: "dd-MMMM-yyyy")
        self.fullDate.accept(date)
        let arrayDate = fullDate.components(separatedBy: "-")
        self.bulan.accept(arrayDate[1])
        self.tahun.accept(arrayDate[2])
    }
    
    func resetBulanTahun() {
        self.fullDate.accept(PublicFunction.getStringDate(pattern: "dd-MMMM-yyyy"))
        self.bulan.accept(PublicFunction.getStringDate(pattern: "MM"))
        self.tahun.accept(PublicFunction.getStringDate(pattern: "yyyy"))
    }
}
