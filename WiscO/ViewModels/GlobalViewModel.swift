//
//  globalViewModel.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import Foundation

class GlobalViewModel:ObservableObject {
    @Published var isLoggedIn = false
    var userData = UserData()
    init(){
        // Fetch the API key
        if let apiKey = userData.retrieveFromUserDefaults(key: "apiKey") {
            if !apiKey.isEmpty {
                self.isLoggedIn = true
            }else{
                self.isLoggedIn = false
            }
        }else{
            self.isLoggedIn = false
        }
    }
    func logout(){
        userData.saveToUserDefaults(keyValue: "apiKey", apiKey: "")
        userData.saveToUserDefaults(keyValue: "serverURL", apiKey: "")
        self.isLoggedIn = false
    }
}
