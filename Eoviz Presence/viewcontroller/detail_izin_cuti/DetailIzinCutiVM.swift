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
    var listInformasiStatus = BehaviorRelay(value: [InformationStatusItem]())
    
    func getInformasiStatus() {
        var array = [InformationStatusItem]()
        
        array.append(InformationStatusItem(emp_name: "supri", exchange_status: "-", status: 0, status_datetime: "3 Februari 2020 18:00:12"))
        array.append(InformationStatusItem(emp_name: "supri 1", exchange_status: "-", status: 1, status_datetime: "3 Februari 2020 18:00:12"))
        array.append(InformationStatusItem(emp_name: "supri 2", exchange_status: "-", status: 1, status_datetime: "3 Februari 2020 18:00:12"))
        array.append(InformationStatusItem(emp_name: "supri 3", exchange_status: "-", status: 1, status_datetime: "3 Februari 2020 18:00:12"))
        
        listInformasiStatus.accept(array)
    }
}
