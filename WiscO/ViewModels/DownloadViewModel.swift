//
//  DownloadViewModel.swift
//  WiscO
//
//  Created by Nils Wenning on 07.05.24.
//

import Foundation


class DownloadViewModel:ObservableObject{
    
    @Published var isLoading = false
    @Published var serverSuccess = false
    @Published var serverResponse: String? = ""
    @Published var error: Error?
    @Published var serverOptions: ServerOptions?
    
    @Published var selectedServerIndex: Int? = 0
    @Published var selectedLanguageIndex: Int? = 0
    @Published var selectedSummaryIndex: Int? = 0
    @Published var link = ""
    @Published var errorText = ""
    
    var userData = UserData()
    
    
    // Initializer
    init() {
        // Fetch server data from user defaults
        userData.loadUserDataFromStorage()
        updateServerOptions()
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
    
    func addLink() {
        self.isLoading = true

        // Define the regex pattern for YouTube URLs with optional additional parameters
        let pattern = "^(https?://)?(www\\.)?(youtube\\.([a-zA-Z0-9-]{2,63})/watch\\?v=|youtu\\.be/)[\\w-]+(\\?.*)?$";

        // Use guard to check if the link matches the YouTube URL regex, otherwise set the error text and return
        guard let regex = try? NSRegularExpression(pattern: pattern),
              regex.firstMatch(in: link, options: [], range: NSRange(location: 0, length: link.utf16.count)) != nil else {
            self.errorText = "Please provide a valid YouTube link."
            self.isLoading = false
            return
        }
        self.errorText = ""
        // Link matches the YouTube pattern, proceed with uploading
        let selectedServer: String = serverOptions?.server[selectedServerIndex ?? 0] ?? "OpenAI"
        let selectedLanguage: String = serverOptions?.languages[selectedLanguageIndex ?? 0] ?? "English"
        let selectedPrompt: String = serverOptions?.summary_prompts[selectedSummaryIndex ?? 0] ?? "Call"
        
        let settings = SettingsModel(server: selectedServer, language: selectedLanguage, sum_type: selectedPrompt)
        userData.uploadLink(url: self.link, settings: settings) { response, error in
            self.isLoading = false
            if let error = error {
                print("Error getting User Data: \(error)")
            } else if let response = response {
                if response.status == "success" {
                    self.serverSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.serverSuccess = false
                    }
                }
            }
        }
    }

}
