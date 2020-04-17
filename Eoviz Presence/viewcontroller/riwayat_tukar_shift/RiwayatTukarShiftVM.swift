//
//  RiwayatTukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class RiwayatTukarShiftVM: BaseViewModel {
    var listRiwayatTukarShift = BehaviorRelay(value: [RiwayatTukarShiftItem]())
    var isLoading = BehaviorRelay(value: false)
    var showEmpty = BehaviorRelay(value: false)
    
    private var totalRiwayatPage = 1
    private var currentRiwayatPage = 1
    
    func getRiwayatTukarShift(isFirst: Bool) {
        
        if isFirst {
            totalRiwayatPage = 1
            currentRiwayatPage = 1
            listRiwayatTukarShift.accept([RiwayatTukarShiftItem]())
        }
        
        if currentRiwayatPage <= totalRiwayatPage {
            isLoading.accept(true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                var array = self.listRiwayatTukarShift.value
                                
                array.append(RiwayatTukarShiftItem(status: "saved", nomer: "SHI.2019.05.000410", date: "14/02/2020", content: "Permintaan tukar shift kepada Neni Sukaesih.", tukarShiftDate: "18 Februari 2020 - Shift II"))
                array.append(RiwayatTukarShiftItem(status: "submitted", nomer: "SHI.2019.05.000410", date: "14/02/2020", content: "Permintaan tukar shift kepada Neni Sukaesih.", tukarShiftDate: "18 Februari 2020 - Shift II"))
                array.append(RiwayatTukarShiftItem(status: "approved", nomer: "SHI.2019.05.000410", date: "14/02/2020", content: "Permintaan tukar shift kepada Neni Sukaesih.", tukarShiftDate: "18 Februari 2020 - Shift II"))
                array.append(RiwayatTukarShiftItem(status: "canceled", nomer: "SHI.2019.05.000410", date: "14/02/2020", content: "Permintaan tukar shift kepada Neni Sukaesih.", tukarShiftDate: "18 Februari 2020 - Shift II"))
                array.append(RiwayatTukarShiftItem(status: "rejected", nomer: "SHI.2019.05.000410", date: "14/02/2020", content: "Permintaan tukar shift kepada Neni Sukaesih.", tukarShiftDate: "18 Februari 2020 - Shift II"))
                
                self.listRiwayatTukarShift.accept(array)
                
                self.currentRiwayatPage += 1
                self.totalRiwayatPage = 3
                                
                self.isLoading.accept(false)
                self.showEmpty.accept(self.listRiwayatTukarShift.value.count == 0)
            }
                        
        }
    }
}
