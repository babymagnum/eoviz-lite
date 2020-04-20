//
//  DetailPersetujuanIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class DetailPersetujuanIzinCutiVM: BaseViewModel {
    var listInformasiStatus = BehaviorRelay(value: [InformasiStatusItem]())
    var listCutiTahunan = BehaviorRelay(value: [CutiTahunanItem]())
    var dontReload = BehaviorRelay(value: false)
    
    func getCutiTahunan() {
        var array = [CutiTahunanItem]()
        
        array.append(CutiTahunanItem(date: "18/02/2020", isApprove: false, isFirst: true, isLast: true, isOnlyOne: true))
        array.append(CutiTahunanItem(date: "19/02/2020", isApprove: false, isFirst: true, isLast: true, isOnlyOne: true))
        array.append(CutiTahunanItem(date: "20/02/2020", isApprove: false, isFirst: true, isLast: true, isOnlyOne: true))
        
        for (index, item) in array.enumerated() {
            array[index] = CutiTahunanItem(date: item.date, isApprove: true, isFirst: index == 0, isLast: index == array.count - 1, isOnlyOne: array.count == 1)
        }
        
        listCutiTahunan.accept(array)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.changeAllApproval(isOn: true)
        }
    }
    
    func getInformasiStatus() {
        var array = [InformasiStatusItem]()
        
        array.append(InformasiStatusItem(name: "Sandra Wijaya", type: "Pengaju", dateTime: "3 Februari 2020 18:00:12", status: "submitted"))
        array.append(InformasiStatusItem(name: "Riyan Trisna Wibowo", type: "-", dateTime: "3 Februari 2020 18:00:12", status: "approved"))
        array.append(InformasiStatusItem(name: "A. Toto Priyono", type: "-", dateTime: "3 Februari 2020 18:00:12", status: "approved"))
        array.append(InformasiStatusItem(name: "Febriana Putri Kusuma", type: "-", dateTime: "3 Februari 2020 18:00:12", status: "approved"))
        
        listInformasiStatus.accept(array)
    }
    
    func changeAllApproval(isOn: Bool) {
        var array = listCutiTahunan.value
        
        for (index, item) in array.enumerated() {
            var newItem = item
            newItem.isApprove = isOn
            
            array[index] = newItem
        }
        
        listCutiTahunan.accept(array)
    }
    
    func changeApproval(index: Int) {
        var array = self.listCutiTahunan.value
        var newItem = array[index]
        newItem.isApprove = !newItem.isApprove
        array[index] = newItem
        self.listCutiTahunan.accept(array)
    }
}
