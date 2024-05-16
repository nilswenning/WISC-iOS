//
//  UserData.swift
//  WiscO
//
//  Created by Nils Wenning on 04.05.24.
//

import Foundation

class UserData{
    
    public var serverUrl: String
    public var apiKey: String
    
    
    
    
    init() {
        self.serverUrl =  ""
        self.apiKey =  ""
    }
    
    
    func loadUserDataFromStorage(){
        self.serverUrl = self.retrieveFromUserDefaults(key: "serverURL") ?? ""
        self.apiKey = self.retrieveFromUserDefaults(key: "apiKey") ?? ""
    }
    
    func getUserInfos(completion: @escaping (UserInfo?, Error?) -> Void) {
        let parameters = ""
        let endpoint = "/v1/getUserInfo"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_user_response = try JSONDecoder().decode(ApiResponseUserModel.self, from: data)
                            completion(api_user_response.raw, nil)
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
    
    func getJobInfos(jobId: String,completion: @escaping (JobModel?, Error?) -> Void) {
        let parameters = "jobid=\(jobId)"
        let endpoint = "/v1/getJob"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_job_response = try JSONDecoder().decode(ApiResponseJobModel.self, from: data)
                            completion(api_job_response.raw, nil)
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
    
    
    func getJobsInfos(completion: @escaping ([JobModel]?, Error?) -> Void) {
        let parameters = ""
        let endpoint = "/v1/getJobs"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_jobs_response = try JSONDecoder().decode(ApiResponseJobsModel.self, from: data)
                            completion(api_jobs_response.raw, nil)
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
    
    func resummarize(jobId: String, settings: SettingsModel, completion: @escaping (ApiResponseModel?, Error?) -> Void) {
        do {
            let settingsData = try JSONEncoder().encode(settings)
            guard let settingsString = String(data: settingsData, encoding: .utf8) else {
                print("Error: Could not convert settings data to string")
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Settings conversion failed"])
                completion(nil, error)
                return
            }
            
            let parameters = "jobid=\(jobId)&settings=\(settingsString)"
            let endpoint = "/v1/resummarize"
            let apiBridge = ApiBridge()
            apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let dataString):
                        if let data = dataString.data(using: .utf8) {
                            do {
                                let api_response = try JSONDecoder().decode(ApiResponseModel.self, from: data)
                                completion(api_response, nil)
                            } catch {
                                print("JSON Decoding Error: \(error.localizedDescription)")
                                completion(nil, error)
                            }
                        } else {
                            print("Error: Could not convert string to data")
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                            completion(nil, error)
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            }
        } catch {
            print("Error encoding settings: \(error.localizedDescription)")
            completion(nil, error)
        }
    }

    
    
    
    
    
    func restartJob(jobId: String, settings: SettingsModel, completion: @escaping (ApiResponseModel?, Error?) -> Void) {
        do {
            let settingsData = try JSONEncoder().encode(settings)
            guard let settingsString = String(data: settingsData, encoding: .utf8) else {
                print("Error: Could not convert settings data to string")
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Settings conversion failed"])
                completion(nil, error)
                return
            }
            
            let parameters = "jobid=\(jobId)&settings=\(settingsString)"
            let endpoint = "/v1/restartJob"
            let apiBridge = ApiBridge()
            apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let dataString):
                        if let data = dataString.data(using: .utf8) {
                            do {
                                let api_response = try JSONDecoder().decode(ApiResponseModel.self, from: data)
                                completion(api_response, nil)
                            } catch {
                                print("JSON Decoding Error: \(error.localizedDescription)")
                                completion(nil, error)
                            }
                        } else {
                            print("Error: Could not convert string to data")
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                            completion(nil, error)
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            }
        } catch {
            print("Error encoding settings: \(error.localizedDescription)")
            completion(nil, error)
        }
    }

    
    func uploadLink(url: String, settings: SettingsModel, completion: @escaping (ApiResponseModel?, Error?) -> Void) {
        // Set data
        let settingsJson = "{ \"server\": \"\(settings.server)\", \"accuracy\":\"high\",\"sum_type\":\"\(settings.sum_type)\", \"language\":\"\(settings.language)\"}"
        let encodedSettings = settingsJson.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let parameters = "url=\(encodedUrl)&settings=\(encodedSettings)"
        
        
        let endpoint = "/v1/createDlJob"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_response = try JSONDecoder().decode(ApiResponseModel.self, from: data)
                            completion(api_response, nil)
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
    
    
    
    func getJobResult(jobId: String, completion: @escaping (JobResult?, Error?) -> Void) {
        let parameters = "jobid=\(jobId)"
        let endpoint = "/v1/getJobResult"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_jobResult_response = try JSONDecoder().decode(ApiResponseJobResultModel.self, from: data)
                            completion(api_jobResult_response.raw, nil)
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
    
    
    func getServerOptions(completion: @escaping (ServerOptions?, Error?) -> Void) {
        let parameters = ""
        let endpoint = "/v1/getServerOptions"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_jobResult_response = try JSONDecoder().decode(ApiResponseServerOptions.self, from: data)
                            completion(api_jobResult_response.raw, nil)
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
    
    
    
    func sendCommand(command: String,completion: @escaping (ApiResponseModel?, Error?) -> Void) {
        let parameters = "command=\(command)"
        let endpoint = "/v1/commands"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: self.serverUrl, endpoint: endpoint, parameters: parameters, apiKey: self.apiKey) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_result_response = try JSONDecoder().decode(ApiResponseModel.self, from: data)
                            completion(api_result_response, nil)
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    }
    
    
    
    
    
    // Helper method to fetch a value from user defaults
    func retrieveFromUserDefaults(key: String) -> String? {
        // Access user defaults for the app group
        if let userDefaults = UserDefaults(suiteName: "group.ruux.WiscO.share") {
            return userDefaults.string(forKey: key)
        }
        return nil
    }
    
    
    func saveToUserDefaults(keyValue: String, apiKey: String) {
        if let userDefaults = UserDefaults(suiteName: "group.ruux.WiscO.share") {
            userDefaults.set(apiKey, forKey: keyValue)
            userDefaults.synchronize()
            print("Saved \(keyValue) with value \(apiKey)")
        } else {
            print("Failed to access UserDefaults with suite name group.Wisco.share")
        }
    }
}
