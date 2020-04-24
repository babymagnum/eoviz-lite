//
//  DetailPengajuanTukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 24/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class DetailPengajuanTukarShiftVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    var detailExchangeShift = BehaviorRelay(value: DetailExchangeShiftData())
    
    func statusString(status: Int) -> String {
        if status == 0 {
            return "Saved"
        } else if status == 1 {
            return "Submitted"
        } else if status == 2 {
            return "Rejected"
        } else if status == 3 {
            return "Approved"
        } else {
            return "Canceled"
        }
    }
    
    func startColor(status: Int) -> UIColor {
        if status == 0 || status == 1 {
            return UIColor.peacockBlue.withAlphaComponent(0.8)
        } else if status == 2 || status == 4 {
            return UIColor.rustRed.withAlphaComponent(0.8)
        } else {
            return UIColor.nastyGreen.withAlphaComponent(0.8)
        }
    }
    
    func endColor(status: Int) -> UIColor {
        if status == 0 || status == 1 {
            return UIColor.greyblue.withAlphaComponent(0.8)
        } else if status == 2 || status == 4 {
            return UIColor.pastelRed.withAlphaComponent(0.8)
        } else {
            return UIColor.paleOliveGreen.withAlphaComponent(0.8)
        }
    }
    
    func statusImage(status: Int) -> UIImage? {
        if status == 0 {
            return UIImage(named: "24GadgetsFloppy")?.tinted(with: UIColor.white)
        } else if status == 1 {
            return UIImage(named: "check24Px")
        } else if status == 2 {
            return UIImage(named: "whiteRejected")
        } else if status == 3 {
            return UIImage(named: "check24Px")
        } else {
            return UIImage(named: "whiteCanceled")
        }
    }
    
    func detailExchangeShift(shiftExchangeId: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.detailExchangeShift(shiftExchangeId: shiftExchangeId) { (error, detail, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _detail = detail, let _data = _detail.data else { return }
            
            if _detail.status {
                self.detailExchangeShift.accept(_data)
            } else {
                self.showAlertDialog(image: nil, message: _detail.messages[0], navigationController: nc)
            }
        }
    }
}
