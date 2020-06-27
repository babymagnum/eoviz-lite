//
//  TukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class TukarShiftVM: BaseViewModel {
    var parentLoading = BehaviorRelay(value: false)
    var isLoading = BehaviorRelay(value: false)
    var listShift = BehaviorRelay(value: [ShiftItem]())
    var isEmpty = BehaviorRelay(value: false)
    var typeTanggal = BehaviorRelay(value: "")
    var typeShift = BehaviorRelay(value: "")
    var tanggalShiftAwal = BehaviorRelay(value: "")
    var tanggalTukarShift = BehaviorRelay(value: "")
    var errorMessages = BehaviorRelay(value: "")
    var exchangeShift = BehaviorRelay(value: ExchangeShiftData())
    var shiftByDate = BehaviorRelay(value: ShiftByDateData())
    var isGetExchangeShift = BehaviorRelay(value: false)
    
    private var _shiftByDate = ShiftByDateData()
    private var requestorShiftId = 0
    private var selectedShift: ShiftItem?
    
    func resetVariable() {
        isLoading.accept(false)
        listShift.accept([ShiftItem]())
        isEmpty.accept(false)
        typeTanggal.accept("")
        typeShift.accept("")
        tanggalShiftAwal.accept("")
        tanggalTukarShift.accept("")
        errorMessages.accept("")
        shiftByDate.accept(ShiftByDateData())
        exchangeShift.accept(ExchangeShiftData())
    }
    
    func getExchangeShift(shiftExchangeId: String, nc: UINavigationController?) {
        isGetExchangeShift.accept(true)
        parentLoading.accept(true)
        
        networking.getExchangeShift(shiftExchangeId: shiftExchangeId) { (error, exchangeShift, isExpired) in
            self.parentLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _exchangeShift = exchangeShift, let _data = _exchangeShift.data else { return }
            
            if _exchangeShift.status {
                self.exchangeShift.accept(_data)
                self.typeTanggal.accept("\(_data.exchange_type ?? 0)")
                self.tanggalShiftAwal.accept(PublicFunction.dateStringTo(date: _data.shift_date ?? "", fromPattern: "yyyy-MM-dd", toPattern: "dd/MM/yyyy"))
                self.tanggalTukarShift.accept(PublicFunction.dateStringTo(date: _data.exchange_shift_date ?? "", fromPattern: "yyyy-MM-dd", toPattern: "dd/MM/yyyy"))
                self.requestorShiftId = _data.shift_id ?? 0
                
                self.getShiftByDate(isFromGetExchangeShift: true, nc: nc) {
                    var array = [ShiftItem]()
                    let _pref = self.preference
                    let _cons = self.constant
                    
                    if self.typeTanggal.value == "1" {
                        array.append(ShiftItem(emp_id: Int(_pref.getString(key: _cons.USER_ID)) ?? 0, emp_name: _pref.getString(key: _cons.NAME), shift_id: self._shiftByDate.shift_id ?? 0, shift_name: (self._shiftByDate.shift_name ?? "").capitalizingFirstLetter(), shift_start: self._shiftByDate.shift_start ?? "", shift_end: self._shiftByDate.shift_end ?? "", isSelected: false, isSelf: true))
                    }
                    
                    _data.list.forEach({ item in
                        array.append(ShiftItem(emp_id: item.emp_id ?? 0, emp_name: item.emp_name ?? "", shift_id: item.shift_id ?? 0, shift_name: item.shift_name ?? "", shift_start: item.shift_start ?? "", shift_end: item.shift_end ?? "", isSelected: false, isSelf: false))
                    })
                    
                    self.listShift.accept(array)
                    self.isEmpty.accept(array.count == 0)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let selectedIndex = array.firstIndex(where: {$0.emp_id == _data.exchange_emp_id ?? 0}) ?? 0
                        print("selected shift \(selectedIndex)")
                        self.updateItem(selectedIndex: selectedIndex)
                        self.isGetExchangeShift.accept(false)
                    }
                }
            } else {
                self.showAlertDialog(image: nil, message: _exchangeShift.messages[0], navigationController: nc)
            }
        }
    }
    
    func getShiftByDate(isFromGetExchangeShift: Bool, nc: UINavigationController?, completion: @escaping() -> Void) {
        parentLoading.accept(true)
        
        let date = PublicFunction.dateStringTo(date: typeTanggal.value == "1" ? tanggalTukarShift.value : tanggalShiftAwal.value, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd")
        
        networking.getShiftByDate(date: date) { (error, shiftByDate, isExpired) in
            self.parentLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                if _error == self.constant.CONNECTION_ERROR {
                    self.getShiftByDate(isFromGetExchangeShift: isFromGetExchangeShift, nc: nc) {}
                }
                return
            }
            
            guard let _shiftByDate = shiftByDate, let _data = _shiftByDate.data else { return }
            
            if _shiftByDate.status {
                if self.typeTanggal.value == "1" {
                    self._shiftByDate = _data
                    
                    if !isFromGetExchangeShift {
                        self.getListShift(nc: nc)
                    }
                } else {
                    self.shiftByDate.accept(_data)
                }
                
                completion()
            }
        }
    }
    
    func sendExchange(shiftExchangeId: String, reason: String, sendType: String, nc: UINavigationController?) {
        parentLoading.accept(true)
        
        let shiftAwal = PublicFunction.dateStringTo(date: tanggalShiftAwal.value, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd")
        let tukarShift = PublicFunction.dateStringTo(date: tanggalTukarShift.value, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd")
        
        let body: [String: String] = [
            "shift_id": "\(requestorShiftId)",
            "exchange_type": typeTanggal.value,
            "reason": reason,
            "shift_date": shiftAwal,
            "exchange_shift_date": tukarShift,
            "exchange_shift_id": "\(selectedShift?.shift_id ?? 0)",
            "exchange_emp_id": "\(selectedShift?.emp_id ?? 0)",
            "send_type": sendType,
            "shift_exchange_id": shiftExchangeId
        ]
        
        networking.sendExchange(body: body) { (error, success, isExpired) in
            self.parentLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                guard let tukarShiftVC = nc?.viewControllers.last(where: { $0.isKind(of: TukarShiftVC.self) }) else { return }
                let removedIndex = nc?.viewControllers.lastIndex(of: tukarShiftVC) ?? 0
                
                nc?.pushViewController(RiwayatTukarShiftVC(), animated: true)
                
                nc?.viewControllers.remove(at: removedIndex)
            } else {
                let vc = DialogAlertArrayVC()
                vc.listException = _success.messages
                self.showCustomDialog(destinationVC: vc, navigationController: nc)
            }
        }
    }
    
    func getListShift(nc: UINavigationController?) {
        isLoading.accept(true)
        
        let shiftAwal = PublicFunction.dateStringTo(date: tanggalShiftAwal.value, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd")
        let tukarShift = PublicFunction.dateStringTo(date: tanggalTukarShift.value, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd")
        
        let body: [String: String] = [
            "exchange_type": typeTanggal.value,
            "shift_date": shiftAwal,
            "exchange_date": tukarShift
        ]
        
        networking.getEmpShiftList(body: body) { (error, shiftList, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.isEmpty.accept(true)
                self.errorMessages.accept(_error)
                self.listShift.accept([ShiftItem]())
                return
            }
            
            guard let _shiftList = shiftList else { return }
            
            if _shiftList.status {
                self.requestorShiftId = _shiftList.data?.shift_id_requestor ?? 0
                self.errorMessages.accept(_shiftList.messages[0])
                
                var array = [ShiftItem]()
                let _pref = self.preference
                let _cons = self.constant
                
                if self.typeTanggal.value == "1" {
                    array.append(ShiftItem(emp_id: Int(_pref.getString(key: _cons.USER_ID)) ?? 0, emp_name: _pref.getString(key: _cons.NAME), shift_id: self._shiftByDate.shift_id ?? 0, shift_name: (self._shiftByDate.shift_name ?? "").capitalizingFirstLetter(), shift_start: self._shiftByDate.shift_start ?? "", shift_end: self._shiftByDate.shift_end ?? "", isSelected: false, isSelf: true))
                }
                
                _shiftList.data?.list.forEach({ item in
                    array.append(ShiftItem(emp_id: item.emp_id ?? 0, emp_name: item.emp_name ?? "", shift_id: item.shift_id ?? 0, shift_name: item.shift_name ?? "", shift_start: item.shift_start ?? "", shift_end: item.shift_end ?? "", isSelected: false, isSelf: false))
                })
                
                self.listShift.accept(array)
                self.isEmpty.accept(array.count == 0)
            } else {
                self.listShift.accept([ShiftItem]())
                self.isEmpty.accept(true)
            }
        }
    }
    
    func updateItem(selectedIndex: Int) {
        var array = listShift.value
        
        for (index, _) in array.enumerated() {
            if index == selectedIndex {
                array[index].isSelected = true
            } else {
                array[index].isSelected = false
            }
        }
        
        selectedShift = array[selectedIndex]
        
        listShift.accept(array)
    }
}
