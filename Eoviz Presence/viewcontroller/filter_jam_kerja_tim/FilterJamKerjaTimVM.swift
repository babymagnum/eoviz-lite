//
//  FilterJamKerjaTimVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 30/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterJamKerjaTimVM: BaseViewModel {
    var listKaryawan = BehaviorRelay(value: [FilterKaryawanDataItem]())
    var isLoading = BehaviorRelay(value: false)
    var emptyMessage = BehaviorRelay(value: "")
    var showEmpty = BehaviorRelay(value: false)
    
    func filterKaryawan(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.filterKaryawan { (error, filterKaryawan, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _filterKaryawan = filterKaryawan, let _data = _filterKaryawan.data else { return }
            
            if _filterKaryawan.status {
                var array = [FilterKaryawanDataItem]()
                
                _data.employee.forEach { item in
                    array.append(FilterKaryawanDataItem(emp_id: item.emp_id ?? 0, emp_name: item.emp_name ?? "", isSelected: false))
                }
                
                self.listKaryawan.accept(array)
                self.showEmpty.accept(_data.employee.count == 0)
            } else {
                self.emptyMessage.accept(_filterKaryawan.messages[0])
            }
        }
    }
    
    func changeSelected(index: Int) {
        var array = listKaryawan.value
        array[index].isSelected = !array[index].isSelected
        listKaryawan.accept(array)
    }
}
