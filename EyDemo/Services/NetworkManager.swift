//
//  NetworkManager.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-16.
//

import Foundation

class NetworkManager {
    
    /// This  method is commonly used for all tyoe of GET api request.
    func performGetRequest(urlType: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string:urlType) else { return }
        // create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // create the session
        let session = URLSession.shared
        // create the task
        let task = session.dataTask(with: request, completionHandler: completion)
        // start the task
        task.resume()
    }
}
