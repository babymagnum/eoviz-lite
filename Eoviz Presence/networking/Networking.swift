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
    
    func testHttp(completion: @escaping(_ error: String?, _ successData: SuccessData?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())api/checkVersion"
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let body: [String: String] = [
            "platform": "ios",
            "current_version": version ?? "1.0.0"
        ]
        alamofirePostFormData(url: url, headers: nil, body: body, completion: completion)
    }
}
