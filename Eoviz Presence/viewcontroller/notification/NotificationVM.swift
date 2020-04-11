//
//  NotificationVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class NotificationVM {
    var listNotifikasi = BehaviorRelay(value: [NotifikasiData]())
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    private var totalNotifikasiPage = 1
    private var currentNotifikasiPage = 1
    
    func getNotifikasi(isFirst: Bool) {
        
        if isFirst {
            totalNotifikasiPage = 1
            currentNotifikasiPage = 1
            listNotifikasi.accept([NotifikasiData]())
        }
        
        if currentNotifikasiPage <= totalNotifikasiPage {
            isLoading.accept(true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                var array = self.listNotifikasi.value
                array.append(NotifikasiData(date: "14/02/2020", title: "Pengajuan Tukar Shift", content: "Pengajuan tukar shift Anda sedang diproses.", isRead: false))
                array.append(NotifikasiData(date: "15/02/2020", title: "Pengajuan Tukar Shift", content: "Pengajuan tukar shift Anda sedang diproses.", isRead: true))
                array.append(NotifikasiData(date: "16/02/2020", title: "Pengajuan Cuti", content: "Pengajuan cuti Anda sedang diproses oleh admin yang ganteng nya minta ampun karena dia adalah siapa???.", isRead: false))
                array.append(NotifikasiData(date: "16/02/2020", title: "Pengajuan Cuti", content: "Pengajuan cuti Anda sedang diproses oleh admin yang ganteng nya minta ampun karena dia adalah siapa???.", isRead: true))
                array.append(NotifikasiData(date: "16/02/2020", title: "Pengajuan Cuti", content: "Pengajuan cuti Anda sedang diproses oleh admin yang ganteng nya minta ampun karena dia adalah siapa???.", isRead: true))
                self.listNotifikasi.accept(array)
                
                self.currentNotifikasiPage += 1
                self.totalNotifikasiPage += 1
                
                self.isLoading.accept(false)
            }
        }
    }
}
