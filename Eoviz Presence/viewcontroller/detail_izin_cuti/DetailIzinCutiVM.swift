//
//  DetailIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class DetailIzinCutiVM: BaseViewModel {
    var listInformasiStatus = BehaviorRelay(value: [InformasiStatusItem]())
    
    func getInformasiStatus() {
        var array = [InformasiStatusItem]()
        
        array.append(InformasiStatusItem(name: "Sandra Wijaya", type: "Pengaju", dateTime: "3 Februari 2020 18:00:12", status: "submitted"))
        array.append(InformasiStatusItem(name: "Riyan Trisna Wibowo", type: "-", dateTime: "3 Februari 2020 18:00:12", status: "approved"))
        array.append(InformasiStatusItem(name: "A. Toto Priyono", type: "-", dateTime: "3 Februari 2020 18:00:12", status: "approved"))
        array.append(InformasiStatusItem(name: "Febriana Putri Kusuma", type: "-", dateTime: "3 Februari 2020 18:00:12", status: "approved"))
        
        listInformasiStatus.accept(array)
    }
}
