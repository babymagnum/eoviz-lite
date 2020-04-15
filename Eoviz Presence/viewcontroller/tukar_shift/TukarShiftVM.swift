//
//  TukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class TukarShiftVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    var listShift = BehaviorRelay(value: [ShiftItem]())
    var isEmpty = BehaviorRelay(value: false)
    var typeTanggal = BehaviorRelay(value: "")
    var typeShift = BehaviorRelay(value: "")
    var tanggalShiftAwal = BehaviorRelay(value: "")
    var tanggalTukarShift = BehaviorRelay(value: "")
    
    func getListShift() {
        isLoading.accept(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var array = [ShiftItem]()
            array.append(ShiftItem(name: "Neni Sukaesih", shift: "Perawat (Shift II)", dateMasuk: "- 18/02/2020 14:00:00", dateKeluar: "- 18/02/2020 22:00:00", isSelected: false))
            array.append(ShiftItem(name: "Neni Sukaesih 2", shift: "Perawat (Shift II)", dateMasuk: "- 18/02/2020 14:00:00", dateKeluar: "- 18/02/2020 22:00:00", isSelected: false))
            array.append(ShiftItem(name: "Neni Sukaesih 3", shift: "Perawat (Shift II)", dateMasuk: "- 18/02/2020 14:00:00", dateKeluar: "- 18/02/2020 22:00:00", isSelected: false))
            
            if Bool.random() {
                self.listShift.accept(array)
            } else {
                self.listShift.accept([ShiftItem]())
            }
            
            self.isLoading.accept(false)
            self.isEmpty.accept(self.listShift.value.count == 0)
        }
    }
    
    func updateItem(item: ShiftItem, index: Int) {
        var array = listShift.value
        array.remove(at: index)
        array.insert(item, at: index)
        listShift.accept(array)
    }
}
