//
//  ApiResponseJobModel.swift
//  WiscO
//
//  Created by Nils Wenning on 04.05.24.
//

import Foundation

// Get Single Job
struct ApiResponseJobModel: Codable {
    let status: String
    let message: String
    let raw: JobModel
}

// Get All Jobs
struct ApiResponseJobsModel: Codable {
    let status: String
    let message: String
    let raw: [JobModel]
}

struct JobModel: Codable, Identifiable, Hashable {
    let id: String
    let created_at: Double
    let downloaded: Bool
    let error: String
    let finished_at: Double
    let length: Int
    let newFileName: String
    let no_more_retry: Bool
    let oldFileName: String
    let retry: Int
    let service_id: String
    let settings: SettingsModel
    let status: String
    var summary_file_name: String
    let user: String
    let yt_url: URL?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        if let yt_url = yt_url?.absoluteString {
            hasher.combine(yt_url)
        }
    }

    static func == (lhs: JobModel, rhs: JobModel) -> Bool {
        lhs.id == rhs.id
    }
}


struct SettingsModel: Codable, Hashable {
    let server: String
    let language: String
    let sum_type: String
}
