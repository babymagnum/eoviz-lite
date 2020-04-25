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
    var listTipeCuti = BehaviorRelay(value: [TipeCutiItem]())
    var listJatahCuti = BehaviorRelay(value: [JatahCutiItem]())
    var listTanggalCuti = BehaviorRelay(value: [TanggalCutiItem]())
    var isLoading = BehaviorRelay(value: false)
    var selectedJenisCuti = BehaviorRelay(value: 0)
    var isDateExist = BehaviorRelay(value: false)
    var viewPickType = BehaviorRelay(value: ViewPickType.rentangTanggalAkhir)
    
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
    
    // MARK: Networking
    func getCutiTahunan(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.jatahCuti { (error, jatahCuti, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _jatahCuti = jatahCuti, let _data = _jatahCuti.data else { return }
            
            if _jatahCuti.status {
                self.listJatahCuti.accept(_data.list)
            } else {
                self.showAlertDialog(image: nil, message: _jatahCuti.messages[0], navigationController: nc)
            }
        }
    }
    
    func tipeCuti(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.tipeCuti { (error, tipeCuti, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _tipeCuti = tipeCuti, let _data = _tipeCuti.data else { return }
            
            if _tipeCuti.status {
                var array = [TipeCutiItem]()
                
                array.append(TipeCutiItem(perstype_id: 0, perstype_name: "pick_leave_type".localize(), is_range: 0, is_quota_reduce: 0, is_allow_backdate: 0, max_date: 0))
                
                _data.list.forEach { item in
                    array.append(item)
                }
                
                self.listTipeCuti.accept(array)
            } else {
                self.showAlertDialog(image: nil, message: _tipeCuti.messages[0], navigationController: nc)
            }
        }
    }
}
