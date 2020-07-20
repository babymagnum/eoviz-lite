//
//  PresenceMapVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 23/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay
import DIKit

class PresenceMapVM: BaseViewModel, DialogAlertProtocol {
    
    func nextAction(nc: UINavigationController?) {
        guard let presenceMapVC = nc?.viewControllers.last(where: { $0.isKind(of: PresenceMapVC.self) }) else { return }
        let index = nc?.viewControllers.lastIndex(of: presenceMapVC) ?? 0
        
        nc?.pushViewController(DaftarPresensiVC(), animated: true)

        nc?.viewControllers.remove(at: index)
        
        self.berandaVM.getBerandaData()
    }
    
    func nextAction2(nc: UINavigationController?) { }
    
    var isLoading = BehaviorRelay(value: false)
    @Inject private var berandaVM: BerandaVM
    
    func presence(presenceId: String, presenceType: String, latitude: Double, longitude: Double, navigationController: UINavigationController?) {
        
        isLoading.accept(true)
        
        let body: [String: String] = [
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "preszone_id": presenceId,
            "presence_type": presenceType
        ]
        
        networking.presence(body: body) { (error, success, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: navigationController)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: navigationController)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.showDelegateDialogAlert(isClosable: false, image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: navigationController)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: navigationController)
            }
        }
    }
}
