//
//  ApprovalVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ApprovalVM: BaseViewModel {
    var listIzinCuti = BehaviorRelay(value: [LeaveApprovalItem]())
    var listTukarShift = BehaviorRelay(value: [ExchangeShiftApprovalItem]())
    var loadingIzinCuti = BehaviorRelay(value: false)
    var loadingTukarShift = BehaviorRelay(value: false)
    var showEmptyIzinCuti = BehaviorRelay(value: false)
    var showEmptyTukarShift = BehaviorRelay(value: false)
    var emptyIzinCuti = BehaviorRelay(value: "")
    var emptyTukarShift = BehaviorRelay(value: "")
    var currentPage = BehaviorRelay(value: 0)
    var isReset = BehaviorRelay(value: false)
    
    private var totalIzinCutiPage = 1
    private var currentIzinCutiPage = 0
    private var totalTukarShiftPage = 1
    private var currentTukarShiftPage = 0
    
    func resetVariabel() {
        listIzinCuti.accept([LeaveApprovalItem]())
        listTukarShift.accept([ExchangeShiftApprovalItem]())
        loadingIzinCuti.accept(false)
        loadingTukarShift.accept(false)
        showEmptyIzinCuti.accept(false)
        showEmptyTukarShift.accept(false)
        emptyIzinCuti.accept("")
        emptyTukarShift.accept("")
        currentPage.accept(0)
        isReset.accept(true)
        totalIzinCutiPage = 1
        currentIzinCutiPage = 0
        totalTukarShiftPage = 1
        currentTukarShiftPage = 0
    }
    
    func resetList() {
        listIzinCuti.accept([LeaveApprovalItem]())
        listTukarShift.accept([ExchangeShiftApprovalItem]())
        showEmptyIzinCuti.accept(false)
        showEmptyTukarShift.accept(false)
        totalIzinCutiPage = 1
        currentIzinCutiPage = 0
        totalTukarShiftPage = 1
        currentTukarShiftPage = 0
    }
    
    func getTukarShift(isFirst: Bool, nc: UINavigationController?) {
        
        if isFirst {
            totalTukarShiftPage = 1
            currentTukarShiftPage = 0
            listTukarShift.accept([ExchangeShiftApprovalItem]())
        }
        
        if currentTukarShiftPage < totalTukarShiftPage {
            loadingTukarShift.accept(true)
            
            networking.exchangeShiftApprovalList(page: currentTukarShiftPage) { (error, exchangeApprovalList, isExpired) in
                self.loadingTukarShift.accept(false)
                
                if let _ = isExpired {
                    self.forceLogout(navigationController: nc)
                    return
                }
                
                if let _error = error {
                    self.emptyTukarShift.accept(_error)
                    self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                    return
                }
                
                guard let _exchangeApprovalList = exchangeApprovalList, let _data = _exchangeApprovalList.data else { return }
                
                self.emptyTukarShift.accept(_exchangeApprovalList.messages[0])
                
                if _exchangeApprovalList.status {
                    self.currentTukarShiftPage += 1
                    self.totalTukarShiftPage = _data.total_page
                    
                    var array = self.listTukarShift.value
                    
                    _data.exchange_shift_approval.forEach { item in
                        array.append(item)
                    }
                    
                    self.listTukarShift.accept(array)
                    self.showEmptyTukarShift.accept(self.listTukarShift.value.count == 0)
                } else {
                    self.showAlertDialog(image: nil, message: _exchangeApprovalList.messages[0], navigationController: nc)
                }
            }
        }
    }
    
    func getIzinCuti(isFirst: Bool, nc: UINavigationController?) {
        
        if isFirst {
            totalIzinCutiPage = 1
            currentIzinCutiPage = 0
            listIzinCuti.accept([LeaveApprovalItem]())
        }
        
        if currentIzinCutiPage < totalIzinCutiPage {
            loadingIzinCuti.accept(true)
            
            networking.leaveApprovalList(page: currentIzinCutiPage) { (error, leaveApproval, isExpired) in
                self.loadingIzinCuti.accept(false)
                
                if let _ = isExpired {
                    self.forceLogout(navigationController: nc)
                    return
                }
                
                if let _error = error {
                    self.emptyIzinCuti.accept(_error)
                    self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                    return
                }
                
                guard let _leaveApproval = leaveApproval, let _data = _leaveApproval.data else { return }
                
                self.emptyIzinCuti.accept(_leaveApproval.messages[0])
                
                if _leaveApproval.status {
                    self.currentIzinCutiPage += 1
                    self.totalIzinCutiPage = _data.total_page
                    
                    var array = self.listIzinCuti.value
                    
                    _data.list.forEach { item in
                        array.append(item)
                    }
                    
                    self.listIzinCuti.accept(array)
                    self.showEmptyIzinCuti.accept(self.listIzinCuti.value.count == 0)
                } else {
                    self.showAlertDialog(image: nil, message: _leaveApproval.messages[0], navigationController: nc)
                }
            }
        }
    }
}
