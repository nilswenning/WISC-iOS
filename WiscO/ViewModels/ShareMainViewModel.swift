//
//  ShareMainViewModel.swift
//  WiscO
//
//  Created by Nils Wenning on 03.05.24.
//

import Foundation
import UIKit

class ShareMainViewModel: ObservableObject {
    // Published properties to notify observers of changes
    @Published var serverUrl = "TODO"
    @Published var apiKey = "TODO"
    @Published var isLoading = false
    @Published var serverSuccess = false
    @Published var serverResponse: String? = ""
    @Published var item: Any?
    @Published var error: Error?
    @Published var serverOptions: ServerOptions?
    
    @Published var selectedServerIndex: Int? = 0  
    @Published var selectedLanguageIndex: Int? = 0
    @Published var selectedSummaryIndex: Int? = 0
    
    var userData = UserData()

    // Closure to handle closing
    var onClose: (() -> Void)?
    
    // Initializer
    init() {
        // Fetch server data from user defaults
        userData.loadUserDataFromStorage()
        updateServerOptions()
        self.serverUrl = userData.serverUrl
        
        self.apiKey = userData.apiKey
        // Initialize with default values
        self.item = nil
        self.error = nil
    }
    
    
    func updateServerOptions(){
        userData.getServerOptions{ serverOptions, error in
            if let error = error {
                print("error getting User Data Error: \(error)")
            } else if let serverOptions = serverOptions{
                self.serverOptions = serverOptions
            }
        }
    }

    func uploadFile() {
        self.isLoading = true
        // Handle any existing error and exit
        if let error = self.error {
            print("Error loading item: \(error)")
            close()
            return
        }

        // Guard against nil item
        guard let item = self.item else {
            print("Error: item is nil")
            close()
            return
        }

        // Check the type of the item and proceed accordingly
        if let url = item as? URL {
            uploadAudioFile(url) { success, message in
                self.handleUploadCompletion(success: success, message: message)
            }
        } else if let data = item as? Data {
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString)
            do {
                try data.write(to: fileURL)
                uploadAudioFile(fileURL) { success, message in
                    self.handleUploadCompletion(success: success, message: message)
                }
            } catch {
                print("Failed to write data to temp file: \(error)")
                close()
            }
        } else {
            print("Unsupported item type: \(type(of: item))")
            close()
        }
    }

    func handleUploadCompletion(success: Bool, message: String?) {
        isLoading = false
        // Handle the success or failure of the upload
        if success {
            self.serverSuccess = true
            self.serverResponse = message ?? "Upload successful"
        } else {
            self.serverSuccess = false
            self.serverResponse = message ?? "Upload failed"
        }
        closeWithDelay(delay: 1.5)
    }


    // Method to upload an audio file to the server
    func uploadAudioFile(_ fileURL: URL, completion: @escaping (Bool, String?) -> Void) {
        
        // Get Options from Settings
        let selectedServer: String = serverOptions?.server[selectedServerIndex ?? 0] ?? "OpenAI"
        let selectedLanguage: String = serverOptions?.languages[selectedLanguageIndex ?? 0] ?? "english"
        let selectedPrompt: String = serverOptions?.summary_prompts[selectedSummaryIndex ?? 0] ?? "call"
        
        let apiURL = URL(string: "\(self.serverUrl)/v1/createJob")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"

        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(self.apiKey, forHTTPHeaderField: "Authorization")

        // Create the multipart/form-data boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create the body
        var body = Data()

        // Add the file to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(fileURL.mimeType())\r\n\r\n".data(using: .utf8)!)
        if let fileData = try? Data(contentsOf: fileURL) {
            body.append(fileData)
        }
        body.append("\r\n".data(using: .utf8)!)

        // Add the settings to the body
        let settingsJson = " { \"server\": \"\(selectedServer)\", \"accuracy\":\"high\",\"sum_type\":\"\(selectedPrompt)\", \"language\":\"\(selectedLanguage)\"}" // TODO Remove accuracy
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"settings\"\r\n\r\n".data(using: .utf8)!)
        body.append(settingsJson.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)

        // Close the body with the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Create a data task for the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error uploading file: \(error)")
                    completion(false, nil)
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let apiResponse = try JSONDecoder().decode(ApiResponseModel.self, from: data)
                            if apiResponse.status == "success" {
                                completion(true, nil)
                            } else {
                                completion(false, apiResponse.message)
                            }
                        } catch {
                            completion(false, "Decoding failed")
                        }
                    } else {
                        completion(false, "No data received")
                    }
                } else {
                    print("Unexpected response status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }
    func closeWithDelay(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.close()
        }
    }

    func close() {
        // Call the closure to perform the closing action
        onClose?()
    }
}
