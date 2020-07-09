//
//  FilterDaftarPresensiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterDaftarPresensiVM: BaseViewModel {
    var fullBulan = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "MMMM"))
    var bulan = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "MM"))
    var tahun = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "yyyy"))
    var loading = BehaviorRelay(value: false)
    var listTahun = BehaviorRelay(value: [String]())
    var listBulan = BehaviorRelay(value: [BulanItem]())
    
    func getBulanTahun(nc: UINavigationController?) {
        loading.accept(true)
        
        networking.bulanTahun { (error, bulanTahun, isExpired) in
            self.loading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
                      
            guard let _bulanTahun = bulanTahun, let _data = _bulanTahun.data else { return }
            
            var _listTahun = [String]()
            
            if _bulanTahun.status {
                
                _data.year.forEach { item in
                    _listTahun.append("\(item)")
                }
                
                self.listBulan.accept(_data.month)
                self.listTahun.accept(_listTahun)
            } else {
                self.showAlertDialog(image: nil, message: _bulanTahun.messages[0], navigationController: nc)
            }
        }
    }
    
    func resetFilterDaftarPresensi() {
        self.bulan.accept(PublicFunction.getStringDate(pattern: "MM"))
        self.tahun.accept(PublicFunction.getStringDate(pattern: "yyyy"))
    }
}
