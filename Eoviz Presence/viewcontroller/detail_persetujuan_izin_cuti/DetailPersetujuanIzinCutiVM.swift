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
    var listCutiTahunan = BehaviorRelay(value: [CutiTahunanItem]())
    var dontReload = BehaviorRelay(value: false)
    var isLoading = BehaviorRelay(value: false)
    var detailIzinCuti = BehaviorRelay(value: DetailIzinCutiData())
    var listInformasiStatus = BehaviorRelay(value: [DetailIzinCutiInformationStatusItem]())
    
    func submitLeaveApproval(isApproved: Bool, statusNote: String, permissionId: String, nc: UINavigationController) {
        isLoading.accept(true)
        
        let body: [String: Any] = [
            "permission_id": permissionId,
            "action": isApproved ? "3" : "2",
            "status_note": statusNote
        ]
        
        var arrayDates = [String]()
        var arrayActionDates = [String]()
        
        listCutiTahunan.value.forEach { item in
            arrayDates
        }
        
        //networking.submitCuti(body: <#T##[String : Any]#>, completion: <#T##(String?, Success?, Bool?) -> Void#>)
    }
    
    func detailCuti(nc: UINavigationController?, permissionId: String) {
        isLoading.accept(true)
        
        networking.detailCuti(permissionId: permissionId) { (error, detailIzinCuti, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _detailIzinCuti = detailIzinCuti, let _data = _detailIzinCuti.data else { return }
            
            if _detailIzinCuti.status {
                self.detailIzinCuti.accept(_data)
                self.listInformasiStatus.accept(_data.information_status)
                
                var array = [CutiTahunanItem]()
                
                _data.dates.forEach { item in
                    array.append(CutiTahunanItem(date: item.date ?? "", isApprove: false, isFirst: true, isLast: true, isOnlyOne: true))
                }
                
                for (index, item) in array.enumerated() {
                    array[index] = CutiTahunanItem(date: item.date, isApprove: true, isFirst: index == 0, isLast: index == array.count - 1, isOnlyOne: array.count == 1)
                }
                
                self.listCutiTahunan.accept(array)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.changeAllApproval(isOn: true)
                }
            } else {
                self.showAlertDialog(image: nil, message: _detailIzinCuti.messages[0], navigationController: nc)
            }
        }
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
