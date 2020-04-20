//
//  ApprovalVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ApprovalVM: BaseViewModel {
    var listIzinCuti = BehaviorRelay(value: [IzinCutiItem]())
    var listTukarShift = BehaviorRelay(value: [PersetujuanItem]())
    var isLoading = BehaviorRelay(value: false)
    var showEmptyIzinCuti = BehaviorRelay(value: false)
    var showEmptyTukarShift = BehaviorRelay(value: false)
    var izinCutiLastSeenIndex = BehaviorRelay(value: 0)
    var tukarShiftLastSeenIndex = BehaviorRelay(value: 0)
    
    private var totalIzinCutiPage = 1
    private var currentIzinCutiPage = 1
    private var totalTukarShiftPage = 1
    private var currentTukarShiftPage = 1
    
    func getTukarShift(isFirst: Bool) {
        
        if isFirst {
            totalTukarShiftPage = 1
            currentTukarShiftPage = 1
            listTukarShift.accept([PersetujuanItem]())
        }
        
        if currentTukarShiftPage <= totalTukarShiftPage {
            isLoading.accept(true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                var array = self.listTukarShift.value
                
                array.append(PersetujuanItem(date: "14/02/2020", content: "Permintaan tukar shift dari Sandra Wijaya.", isRead: false, image: "https://themes.themewaves.com/nuzi/wp-content/uploads/sites/4/2013/05/Team-Member-3.jpg"))
                array.append(PersetujuanItem(date: "14/02/2020", content: "Permintaan tukar shift dari Sandra Wijaya.", isRead: false, image: "https://themes.themewaves.com/nuzi/wp-content/uploads/sites/4/2013/05/Team-Member-3.jpg"))
                array.append(PersetujuanItem(date: "14/02/2020", content: "Permintaan tukar shift dari Sandra Wijaya.", isRead: true, image: "https://themes.themewaves.com/nuzi/wp-content/uploads/sites/4/2013/05/Team-Member-3.jpg"))
                
                self.listTukarShift.accept(array)
                
                self.currentTukarShiftPage += 1
                self.totalTukarShiftPage = 5
                
                self.isLoading.accept(false)
                self.showEmptyTukarShift.accept(self.listTukarShift.value.count == 0)
            }
        }
    }
    
    func getIzinCuti(isFirst: Bool) {
        
        if isFirst {
            totalIzinCutiPage = 1
            currentIzinCutiPage = 1
            listIzinCuti.accept([IzinCutiItem]())
        }
        
        if currentIzinCutiPage <= totalIzinCutiPage {
            isLoading.accept(true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                var array = self.listIzinCuti.value
                if Bool.random() {
                    array.append(IzinCutiItem(date: "14/02/2020", nama: "Sandra Wijaya", isRead: false, type: "Sakit dengan Surat Dokter", cutiDate: "18 Februari 2020 - 19 Februari 2020", image: "https://ppmschool.ac.id/id/wp-content/uploads/2016/01/tutor-8.jpg"))
                    array.append(IzinCutiItem(date: "14/02/2020", nama: "Neni Sukaesih", isRead: true, type: "Cuti Tahunan", cutiDate: "19 Februari 2020", image: "https://ppmschool.ac.id/id/wp-content/uploads/2016/01/tutor-8.jpg"))
                    array.append(IzinCutiItem(date: "14/02/2020", nama: "Hendra Samudra", isRead: false, type: "Izin meninggalkan pekerjaan sementara", cutiDate: "18 Februari 2020 - 18 Februari 2020", image: "https://ppmschool.ac.id/id/wp-content/uploads/2016/01/tutor-8.jpg"))
                }
                self.listIzinCuti.accept(array)
                
                self.currentIzinCutiPage += 1
                self.totalIzinCutiPage = 1
                
                self.isLoading.accept(false)
                self.showEmptyIzinCuti.accept(self.listIzinCuti.value.count == 0)
            }
        }
    }
}
