//
//  ApiResponseJobResultModel.swift
//  WiscO
//
//  Created by Nils Wenning on 05.05.24.
//

import Foundation

struct ApiResponseJobResultModel: Codable {
    let status: String
    let message: String
    let raw: JobResult
}

struct JobResult: Codable {
    let transcribed_text: String
    let summary_text: String
}
