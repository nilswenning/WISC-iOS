//
//  ApiResponseServerOptions.swift
//  WiscO
//
//  Created by Nils Wenning on 06.05.24.
//

import Foundation

struct ApiResponseServerOptions: Codable {
    let status: String
    let message: String
    let raw: ServerOptions
}

struct ServerOptions: Codable {
    let server: [String]
    let languages: [String]
    let summary_prompts: [String]
}
