//
//  JobResultViewModel.swift
//  WiscO
//
//  Created by Nils Wenning on 05.05.24.
//

import Foundation
import MarkdownUI

class JobResultViewModel: ObservableObject{
    
    var jobInfo: JobModel
    var userData = UserData()
    @Published var tabSelectedValue = 0
    
    @Published var jobResult: JobResult? = nil
    
    var transcription = MarkdownContent("Not Transcribed yet")
    var shortSummary = MarkdownContent("Not summarized yet")
    
    @Published var serverOptions: ServerOptions?
    
    @Published var selectedServerIndex: Int? = 0
    @Published var selectedLanguageIndex: Int? = 0
    @Published var selectedSummaryIndex: Int? = 0
    
    @Published var alertShown = false
    @Published var alertText = ""
    
    init(jobInfo: JobModel) {
        userData.loadUserDataFromStorage()
        self.jobInfo = jobInfo
        updateJobResult()
    }
    
    func updateData(){
        updateJobResult()
        updateJobInfo()
    }
    
    
    func restartJob(){
        updateJobInfo()
        
        // Get Options from Settings
        
        selectedServerIndex = selectedServerIndex ?? 0 >= (serverOptions?.server.count)! ? 0 : selectedServerIndex
        selectedLanguageIndex = selectedLanguageIndex ?? 0 >= (serverOptions?.languages.count)! ? 0 : selectedLanguageIndex
        selectedSummaryIndex = selectedSummaryIndex ?? 0 >= (serverOptions?.summary_prompts.count)! ? 0 : selectedSummaryIndex
        
        let selectedServer: String = serverOptions?.server[selectedServerIndex ?? 0] ?? "OpenAI"
        let selectedLanguage: String = serverOptions?.languages[selectedLanguageIndex ?? 0] ?? "english"
        let selectedPrompt: String = serverOptions?.summary_prompts[selectedSummaryIndex ?? 0] ?? "call"
        
        let settings = SettingsModel(server: selectedServer, language: selectedLanguage, sum_type: selectedPrompt)
        userData.restartJob(jobId: jobInfo.id, settings: settings) { response, error in
            if let error = error {
                print("error getting User Data Error: \(error)")
            } else if let response = response {
                if response.status == "success"{
                    self.alertText = "The audio file has been resetted"
                }else{
                    self.alertText = "An error happend while resetting"
                    print(error as Any)
                }
                self.alertShown = true
                self.updateData()
            }
        }
    }
    
    func resummarize(){
        updateJobInfo()
        
        // Get Options from Settings
        let selectedServer: String = serverOptions?.server[selectedServerIndex ?? 0] ?? "OpenAI"
        let selectedLanguage: String = serverOptions?.languages[selectedLanguageIndex ?? 0] ?? "english"
        let selectedPrompt: String = serverOptions?.summary_prompts[selectedSummaryIndex ?? 0] ?? "call"
        
        let settings = SettingsModel(server: selectedServer, language: selectedLanguage, sum_type: selectedPrompt)
        userData.resummarize(jobId: jobInfo.id, settings: settings) { response, error in
            if let error = error {
                print("error getting User Data Error: \(error)")
            } else if let response = response {
                if response.status == "success"{
                    self.alertText = "The text is beeing ressumarized again with your new Settings"
                }else{
                    self.alertText = "An error happend while ressumarizing"
                    print(error as Any)
                }
                self.alertShown = true
                self.updateData()
            }
        }
    }
    
    func updateServerOptions() {
        updateJobInfo()
        userData.getServerOptions { serverOptions, error in
            if let error = error {
                print("error getting User Data Error: \(error)")
            } else if let serverOptions = serverOptions {
                self.serverOptions = serverOptions
                // Preselecting
                self.selectedServerIndex =  self.getIndex(from: self.serverOptions!.server, target: self.jobInfo.settings.server)
                self.selectedLanguageIndex =  self.getIndex(from: self.serverOptions!.languages, target: self.jobInfo.settings.language)
                self.selectedSummaryIndex =  self.getIndex(from: self.serverOptions!.summary_prompts, target: self.jobInfo.settings.sum_type)
                
            }
        }
    }
    

    // Function to find the index of a target in an array
    func getIndex(from array: [String], target: String) -> Int {
        for (index, value) in array.enumerated() {
            if value == target {
                return index
            }
        }
        return -1 // Return -1 if the target is not found
    }

    


    
    func getIndex<T: Equatable>(of item: T, in array: [T]) -> Int? {
        for (index, element) in array.enumerated() {
            if element == item {
                return index
            }
        }
        return nil
    }

    
    func updateJobResult(){
        userData.getJobResult(jobId: self.jobInfo.id){ jobResult, error in
            if let error = error {
                print("error getting Job Result Error: \(error)")
            } else if let jobResult = jobResult{
                self.jobResult = jobResult
                if !jobResult.transcribed_text.isEmpty{
                    self.transcription = MarkdownContent("\(self.jobResult?.transcribed_text.fromBase64() ?? "Error")")
                }
                if !jobResult.summary_text.isEmpty{
                    self.shortSummary = MarkdownContent("\(self.jobResult?.summary_text.fromBase64() ?? "Error")")
                }
            }
        }
    }
    
    func updateJobInfo(){
        userData.getJobInfos(jobId:  self.jobInfo.id){ jobInfo, error in
            if let error = error {
                print("error getting Job Info Error: \(error)")
            } else if let jobInfo = jobInfo{
                self.jobInfo = jobInfo
            }
        }
    }
}
