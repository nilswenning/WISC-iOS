//
//  ProfileView.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var userInfo: UserInfo? = nil
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var alertType: AlertType = .confirmation

    enum AlertType {
        case confirmation, success, error
    }

    var userData = UserData()
    
    init() {
        userData.loadUserDataFromStorage()
        updateUserData()
    }
    
    func updateUserData() {
        userData.getUserInfos { userInfo, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "Error loading user info: \(error.localizedDescription)"
                    self.alertType = .error
                    self.showingAlert = true
                } else if let userInfo = userInfo {
                    self.userInfo = userInfo
                }
            }
        }
    }

    func resetServer() {
        userData.sendCommand(command: "FLUSHALL") { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "Error resetting server: \(error.localizedDescription)"
                    self.alertType = .error
                } else if let response = response, response.status == "success" {
                    self.alertMessage = "Server successfully reset."
                    self.alertType = .success
                } else {
                    self.alertMessage = "Server reset failed."
                    self.alertType = .error
                }
                self.showingAlert = true
            }
        }
    }

    func confirmReset() {
        self.alertMessage = "Are you sure you want to reset the server?"
        self.alertType = .confirmation
        self.showingAlert = true
    }
}
