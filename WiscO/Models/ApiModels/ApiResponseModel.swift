//
//  ApiResponseModel.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import Foundation

struct ApiResponseModel: Codable {
    var status: String
    var message: String
    var raw: String
}
