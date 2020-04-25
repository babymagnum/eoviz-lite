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
    
    func logout(completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/logout"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func profile(completion: @escaping(_ error: String?, _ profile: Profile?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/profile"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func updateProfile(data: Data, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/updateProfile"
        alamofirePostImage(imageData: data, fileName: "profile_photo", fileType: ".png", url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func presence(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/presence"
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func presenceList(date: String, completion: @escaping(_ error: String?, _ daftarPresensi: DaftarPresensi?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/presenceList?date=\(date)"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func changeLanguage(completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/changeLanguage"
        let body: [String: String] = [
            "emp_lang": preference.getString(key: constant.LANGUAGE)
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func changePassword(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/changePassword"
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getEmpShiftList(body: [String: String], completion: @escaping(_ error: String?, _ shiftList: ShiftList?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/getEmpShiftList"
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func sendExchange(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/sendExchange"
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getExchangeShiftHistory(page: String, year: String, status: String, completion: @escaping(_ error: String?, _ riwayatTukarShift: RiwayatTukarShift?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/exchangeShiftHistory?year=\(year)&page=\(page)&exchange_status=\(status)"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func getExchangeShift(shiftExchangeId: String, completion: @escaping(_ error: String?, _ exchangeShift: ExchangeShift?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/exchange?shift_exchange_id=\(shiftExchangeId)"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func detailExchangeShift(shiftExchangeId: String, completion: @escaping(_ error: String?, _ detailExchangeShift: DetailExchangeShift?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/detailExchangeShift?shift_exchange_id=\(shiftExchangeId)"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func cancelExchangeShift(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/cancelExchangeShift"
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func leaveApprovalList(page: Int, completion: @escaping(_ error: String?, _ leaveApproval: LeaveApproval?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/leaveApprovalList"
        let body: [String: String] = [
            "page": "\(page)"
        ]
        
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func exchangeShiftApprovalList(page: Int, completion: @escaping(_ error: String?, _ exchangeShiftApproval: ExchangeShiftApproval?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/exchangeShiftApprovalList"
        let body: [String: String] = [
            "page": "\(page)"
        ]
        
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func notificationList(page: Int, completion: @escaping(_ error: String?, _ notification: Notification?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/notificationList"
        let body: [String: String] = [
            "page": "\(page)"
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func updateNotificationRead(notificationId: String, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/updateNotificationRead"
        let body: [String: String] = [
            "notification_id": notificationId
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func detailExchangeShiftApproval(shiftExchangeId: String, completion: @escaping(_ error: String?, _ detailExchangeShiftApproval: DetailExchangeShiftApproval?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/detailExchangeShift?shift_exchange_id=\(shiftExchangeId)"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func submitExchangeShiftApproval(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/submitExchangeShiftApproval"
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
}
