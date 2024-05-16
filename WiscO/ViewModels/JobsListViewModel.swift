//
//  JobsListViewModel.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import Foundation


class JobsListViewModel: ObservableObject{
    
    @Published var jobs: [JobModel]
    
    var userData = UserData()
    
    
    
    init() {
        userData.loadUserDataFromStorage()
        jobs = []
        updateList()
    }
    
    func updateList(){
        userData.getJobsInfos { jobs, error in
            if let error = error {
                print("Failed to get jobs with error: \(error)")
            } else if let jobs = jobs {
                var correctedJobs: [JobModel] = []
                for job in jobs{
                    var newjob = job
                    let summaryFileName = job.summary_file_name
                    if summaryFileName.isEmpty {
                        newjob.summary_file_name = job.oldFileName
                    }else{
                        newjob.summary_file_name = self.cleanFileName(summaryFileName)
                    }
                    correctedJobs.append(newjob)
                }
                self.jobs = correctedJobs
            }
        }
    }
    
    func cleanFileName(_ fileName: String) -> String {
        let datePrefixPattern = #"^\d{4}-\d{2}-\d{2}-"#
        let fileExtensionPattern = #"\.md$"#

        let regexDatePrefix = try! NSRegularExpression(pattern: datePrefixPattern, options: [])
        let regexFileExtension = try! NSRegularExpression(pattern: fileExtensionPattern, options: [])

        let range = NSRange(location: 0, length: fileName.utf16.count)

        var cleanedFileName = regexDatePrefix.stringByReplacingMatches(in: fileName, options: [], range: range, withTemplate: "")
        cleanedFileName = regexFileExtension.stringByReplacingMatches(in: cleanedFileName, options: [], range: NSRange(location: 0, length: cleanedFileName.utf16.count), withTemplate: "")
        cleanedFileName = cleanedFileName.replacingOccurrences(of: "_", with: " ")
        return cleanedFileName
    }
    
    
}
