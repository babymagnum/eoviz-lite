//
//  RiwayatIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class RiwayatIzinCutiVM: BaseViewModel {
    var listRiwayatIzinCuti = BehaviorRelay(value: [RiwayatIzinCutiItem]())
    var isLoading = BehaviorRelay(value: false)
    var showEmpty = BehaviorRelay(value: false)
    
    private var totalRiwayatPage = 1
    private var currentRiwayatPage = 1
    
    func getRiwayatIzinCuti(isFirst: Bool) {
        
        if isFirst {
            totalRiwayatPage = 1
            currentRiwayatPage = 1
            listRiwayatIzinCuti.accept([RiwayatIzinCutiItem]())
        }
        
        if currentRiwayatPage <= totalRiwayatPage {
            isLoading.accept(true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                var array = self.listRiwayatIzinCuti.value
                                
                array.append(RiwayatIzinCutiItem(status: "saved", nomer: "SHI.2019.05.000410", date: "14/02/2020", type: "Sakit dengan Surat Dokter", izinCutiDate: "18 Februari 2020 - 19 Februari 2020"))
                array.append(RiwayatIzinCutiItem(status: "submitted", nomer: "SHI.2019.05.000410", date: "14/02/2020", type: "Sakit dengan Surat Dokter", izinCutiDate: "18 Februari 2020 - 19 Februari 2020"))
                array.append(RiwayatIzinCutiItem(status: "approved", nomer: "SHI.2019.05.000410", date: "14/02/2020", type: "Sakit dengan Surat Dokter", izinCutiDate: "18 Februari 2020 - 19 Februari 2020"))
                array.append(RiwayatIzinCutiItem(status: "canceled", nomer: "SHI.2019.05.000410", date: "14/02/2020", type: "Sakit dengan Surat Dokter", izinCutiDate: "18 Februari 2020 - 19 Februari 2020"))
                array.append(RiwayatIzinCutiItem(status: "rejected", nomer: "SHI.2019.05.000410", date: "14/02/2020", type: "Sakit dengan Surat Dokter", izinCutiDate: "18 Februari 2020 - 19 Februari 2020"))
                
                self.listRiwayatIzinCuti.accept(array)
                
                self.currentRiwayatPage += 1
                self.totalRiwayatPage = 3
                                
                self.isLoading.accept(false)
                self.showEmpty.accept(self.listRiwayatIzinCuti.value.count == 0)
            }
                        
        }
    }
}
