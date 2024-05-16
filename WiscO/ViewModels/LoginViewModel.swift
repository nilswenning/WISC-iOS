//
//  LoginViewModel.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//
import Foundation

class LoginViewModel: ObservableObject{

    
    @Published var serverUrl = ""
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var loading = false

    init() {
    }
    
    
    
    
    func login(completion: @escaping (Bool) -> Void) {
        let parameters = "username=\(username)&password=\(password)"
        let endpoint = "/v1/getApiKey"
        let apiBridge = ApiBridge()
        apiBridge.sendPostRequest(url: serverUrl, endpoint: endpoint, parameters: parameters, apiKey: "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    if let data = dataString.data(using: .utf8) {
                        do {
                            let api_response = try JSONDecoder().decode(ApiResponseModel.self, from: data)
                            if api_response.status == "success"{
                                self.saveToUserDefaults(keyValue: "apiKey", apiKey: api_response.raw)
                                self.saveToUserDefaults(keyValue: "serverURL", apiKey:self.serverUrl)
                                print(self.retrieveFromUserDefaults(keyValue: "apiKey") ?? "No API KEY")
                                completion(true)
                            }
                            else{
                                self.errorMessage = api_response.message
                            }
                        } catch {
                            print("JSON Decoding Error: \(error.localizedDescription)")
                            completion(false)
                        }
                    } else {
                        print("Error: Could not convert string to data")
                        completion(false)
                    }
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
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
    
    func retrieveFromUserDefaults(keyValue: String) -> String? {
        if let userDefaults = UserDefaults(suiteName: "group.ruux.WiscO.share") {
            let value = userDefaults.string(forKey: keyValue)
            print("Retrieved \(keyValue) with value \(String(describing: value))")
            return value
        } else {
            print("Failed to access UserDefaults with suite name group.Wisco.share")
            return nil
        }
    }
}
