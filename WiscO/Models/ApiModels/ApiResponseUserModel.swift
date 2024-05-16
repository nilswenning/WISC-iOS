//
//  ApiResponseUserModel.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import Foundation

struct ApiResponseUserModel: Codable{
    let message: String
    let raw: UserInfo
    let status: String
}

// Define the user info data structure
struct UserInfo: Codable {
    let name: String
    let role: String
    let email: String
    let password: String
    let api_key: String
    let quota: Int
    let created_at: Double
    let used_minutes: Int

}
