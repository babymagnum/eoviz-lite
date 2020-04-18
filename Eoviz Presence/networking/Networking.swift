//
//  InformationNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking: BaseNetworking {
    func login(username: String, password: String, completion: @escaping(_ error: String?, _ login: Login?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/login"
        let body: [String: String] = [
            "username": username,
            "password": password,
            "fcm": preference.getString(key: constant.FCM_TOKEN),
            "device_id": "\(UIDevice().identifierForVendor?.description ?? "")",
            "device_brand": "iPhone",
            "device_series": UIDevice().name
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func home(completion: @escaping(_ error: String?, _ beranda: Beranda?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/home"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func preparePresence(completion: @escaping(_ error: String?, _ presensi: Presensi?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/preparePresence"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func logout(completion: @escaping(_ error: String?, _ success: SuccessData?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/logout"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
}
