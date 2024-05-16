//
//  Extentions.swift
//  WiscO
//
//  Created by Nils Wenning on 03.05.24.
//

import Foundation
import SwiftUI
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import MarkdownUI


extension URL {
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTType(filenameExtension: pathExtension)?.identifier {
            return UTType(uti)?.preferredMIMEType ?? "application/octet-stream"
        }
        return "application/octet-stream" // Default MIME type
    }
}


extension JobModel {
 
    static var preview: JobModel {
        let trip = JobModel(
            id: "wisco:job:ykmewzpaemjidnq", // Assuming a unique identifier here
            created_at: 1714823581,
            downloaded: false,
            error: "",
            finished_at: 1714823620,
            length: 2,
            newFileName: "ykmewzpaemjidnq.mp3",
            no_more_retry: false,
            oldFileName: "news.mp3",
            retry: 0,
            service_id: "1",  // Assuming 'id' is meant to be 'service_id'
            settings: SettingsModel(server: "OpenAI", language: "german",  sum_type: "call"),
            status: "summary-saved",
            summary_file_name: "Preview",
            user: "admin",
            yt_url: nil  // Set to nil if the URL is empty or not applicable
        )
        return trip
    }
}

extension JobResultViewModel {
    static var preview: JobResultViewModel {
        let model = JobResultViewModel(jobInfo: .preview)
        // Set mock data for job result
        model.jobResult = JobResult(transcribed_text: "This is a sample transcription.", summary_text: "This is a sample summary.")
        model.transcription = MarkdownContent("This is a sample transcription.")
        model.shortSummary = MarkdownContent("This is a sample summary.")
        return model
    }
}


extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}
