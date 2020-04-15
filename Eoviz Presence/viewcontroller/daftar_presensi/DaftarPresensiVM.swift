//
//  DaftarPresensiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class DaftarPresensiVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    var listPresensi = BehaviorRelay(value: [PresensiItem]())
    
    func getListPresensi() {
        isLoading.accept(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var listPresensi = [PresensiItem]()
            listPresensi.append(PresensiItem(date: "Senin, 10 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 11 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 12 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 13 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 14 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 15 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 16 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 17 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            listPresensi.append(PresensiItem(date: "Senin, 18 Februari 2020", status: "On Time", jamMasuk: "06:00:00", jamMasukReal: "05:45:00", jamKeluar: "14:00:00", jamKeluarReal: "14:20:00"))
            self.listPresensi.accept(listPresensi)
            self.isLoading.accept(false)
        }
    }
}
