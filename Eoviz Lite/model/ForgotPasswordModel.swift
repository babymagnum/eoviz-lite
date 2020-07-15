//
//  ForgotPasswordModel.swift
//  Eoviz Lite
//
//  Created by Arief Zainuri on 15/07/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct ForgotPassword: Decodable {
    var status: Bool
    var messages = [String]()
    var data: ForgotPasswordData?
}

struct ForgotPasswordData: Decodable {
    var expired_token: Int
}
