//
//  API.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import Foundation
class Services {
    
private let networKManager = NetworkManager()

    /// Get Giphy data is common method ued to fetch both trending and searched data from server
    /// - Parameters:
    /// - UrlType - is where search and tredning url generate,

    func getGiphyData(urlType: String, completion: @escaping ([Gif], Error?) -> Void) {
        networKManager.performGetRequest(urlType: urlType) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion([], error)
                return
            }
            do {
                // create json object from data or use JSONDecoder to convert to Model stuct
                if try JSONSerialization.jsonObject(with: data, options: .mutableContainers) is [String: Any] {
                    let giphyData = try JSONDecoder().decode(GiphyData.self, from: data)
                    let gifs = giphyData.data
                    completion(gifs, nil)
                } else {
                    throw URLError(.badServerResponse)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion([], error)
            }
        }
    }
}
