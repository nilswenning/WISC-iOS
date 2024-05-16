//
//  ApiBridge.swift
//  WiscO
//
//  Created by Nils Wenning on 04.05.24.
//

import Foundation


class ApiBridge{
    typealias CompletionHandler = (Result<String, Error>) -> Void
    
    func sendPostRequest(url: String, endpoint:String ,parameters: String,apiKey: String ,completion: @escaping CompletionHandler) {
         // Create the URL object
         guard let url = URL(string: "\(url)\(endpoint)") else {
             completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
             return
         }

         // Prepare the URLRequest object
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         request.addValue("\(apiKey)", forHTTPHeaderField: "Authorization")
         request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         
         // URL Encoded data
         request.httpBody = parameters.data(using: .utf8)

         // Create the URLSessionDataTask
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             // Handle error
             if let error = error {
                 completion(.failure(error))
                 return
             }

             // Check the response code
             guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                 completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "HTTP error"])))
                 return
             }

             // Process the response data
             if let data = data, let dataString = String(data: data, encoding: .utf8) {
                 completion(.success(dataString))
             } else {
                 completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
             }
         }

         // Start the task
         task.resume()
     }
}
