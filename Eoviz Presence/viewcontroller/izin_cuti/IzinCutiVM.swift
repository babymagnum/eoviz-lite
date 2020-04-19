//
//  IzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 19/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

enum ViewPickType {
    case rentangTanggalAwal
    case rentangTanggalAkhir
    case tanggalMeninggalkanPekerjaan
    case waktuMulai
    case waktuSelesai
    case tanggalCuti
}

class IzinCutiVM: BaseViewModel {
    
    var listJatahCuti = BehaviorRelay(value: [JatahCutiItem]())
    var listTanggalCuti = BehaviorRelay(value: [TanggalCutiItem]())
    var isLoading = BehaviorRelay(value: false)
    var jenisCuti = BehaviorRelay(value: "Pilih jenis Cuti")
    var jenisCutiId = BehaviorRelay(value: "0")
    var isDateExist = BehaviorRelay(value: false)
    var viewPickType = BehaviorRelay(value: ViewPickType.rentangTanggalAkhir)
    
    func updateJenisCuti(jenisCuti: String, jenisCutiId: String) {
        self.jenisCuti.accept(jenisCuti)
        self.jenisCutiId.accept(jenisCutiId)
    }
    
    func getCutiTahunan() {
        isLoading.accept(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var array = [JatahCutiItem]()
            array.append(JatahCutiItem(periode: "21/07/2018 - 21/07/2019", jatahCuti: "10 hari", terambil: "2 hari", sisaCuti: "8 hari", kadaluarsa: "31/12/2019"))
            array.append(JatahCutiItem(periode: "21/07/2019 - 21/07/2020", jatahCuti: "10 hari", terambil: "0 hari", sisaCuti: "10 hari", kadaluarsa: "31/12/2020"))
            self.listJatahCuti.accept(array)
            self.isLoading.accept(false)
        }
    }
    
    func addTanggalCuti(date: String) {
        var array = listTanggalCuti.value
        
        if array.contains(where: {($0.date == date)}) {
            isDateExist.accept(true)
        } else {
            array.append(TanggalCutiItem(date: date, isLast: true, isFirst: true, isOnlyOne: true))
            
            for (index, item) in array.enumerated() {
                array[index] = TanggalCutiItem(date: item.date, isLast: index == array.count - 1, isFirst: index == 0, isOnlyOne: array.count == 1)
            }
            
            listTanggalCuti.accept(array)
        }
    }
    
    func deleteTanggalCuti(position: Int) {
        var array = listTanggalCuti.value
        array.remove(at: position)
        
        for (index, item) in array.enumerated() {
            array[index] = TanggalCutiItem(date: item.date, isLast: index == array.count - 1, isFirst: index == 0, isOnlyOne: array.count == 1)
        }
        
        listTanggalCuti.accept(array)
    }
}
