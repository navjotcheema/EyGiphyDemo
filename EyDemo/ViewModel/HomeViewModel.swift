//
//  HomeViewModel.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import Foundation
import UIKit

enum UrlType: String {
    case Trending = "trending"
    case Search = "search"
}

final class HomeViewModel {
    private let apiKey = "qqOWsoWVm88GlXuRUrP0pzUIAHuXJ0ar"
    private let limit = 10
    private let rating = "g"
    private let baseURL = "https://api.giphy.com/v1/gifs/"
    private var TrendingOffset = 0
    private var searchOffset = 0
    private var isLoading = false
    private let myservice = Services()
    
    var cache: NSCache<NSString, NSData> = NSCache()

    var selectedCells: [IndexPath] = []
    var isSearchBarActive: Bool = false
    var page = 1
    var gifs: [Gif] = []
    var searchedGifs: [Gif] = []
    var onUpdate: () -> Void = {}
    var filesData: [File] = []
    var updateActivityIndicator: (() -> Void)?
    var showErrorMessage: (() -> Void)?
    
    var isActivityIndicatorVisible: Bool = false {
        didSet {
            // Notify the view that the value of isActivityIndicatorVisible has changed
            self.updateActivityIndicator?()
        }
    }
    
    var errorMessage: String = "" {
        didSet {
            // Notify the view that the value of errorMessage has changed
            self.showErrorMessage?()
        }
    }

    // This Method is used for fetching trending giphy files from server.
    /// - Parameters:
    /// BaseUrl  - Base url to be set
    /// Type - Trending to get trending gifs
    /// API Key - That has been generated from Giphy
    /// Rating - That has been generated from Giphy
    /// Limit - its is set to 10 to get 10 records
    /// TrendingOffset - it is used for pagination initialy it is assigned as 0
    
    func getTrendingResults(completion: @escaping() -> Void) {
        guard !isLoading else { return }
        isLoading = true
        let urlString =                           "\(baseURL)\(UrlType.Trending.rawValue)?api_key=\(apiKey)&limit=\(limit)&offset=\(TrendingOffset)&rating=\(rating)"
        myservice.getGiphyData(urlType: urlString, completion: { [self] gifData,error in
            guard error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                self.errorMessage = error?.localizedDescription ?? ""
                return
            }
            self.isLoading = false
            self.TrendingOffset += 1
            
            print(gifData[0].id)
            print(gifData[0].images.fixedHeight.url)
            self.gifs.append(contentsOf: gifData)
            completion()
        })
    }

    // This Method is used for fetching searched giphy files while type on search bar from server.
    /// - Parameters:
    /// BaseUrl  - Base url to be set
    /// Type - Trending to get trending gifs
    /// API Key - That has been generated from Giphy
    /// Rating - That has been generated from Giphy
    /// Limit - its is set to 10 to get 10 records
    /// searchOffset - it is used for pagination initialy it is assigned as 0
    func fetchSearchedGiphy(searchText: String,isOffset: Bool,completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        if !isOffset {
            searchOffset = 0
        }
        let urlString =         "\(baseURL)\(UrlType.Search.rawValue)?api_key=\(apiKey)&q=\(searchText)&limit=\(limit)&offset=\(searchOffset)&rating=\(rating)"
        
        myservice.getGiphyData(urlType: urlString, completion: { gifData, error in
            guard  error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.isLoading = false
            self.searchOffset += 1
            if self.isSearchBarActive && !isOffset {
                self.searchedGifs = gifData
            }
            else {
                self.searchedGifs.append(contentsOf: gifData)
            }
            completion()
        })
    }
    
   
    
    /// SaveGifdata is using to save file in file storage
    /// - Parameters:- Image Name and GifData Model is used to save data  in filestorage.
    func saveGifData(_ gif: GifDataModel, gifName: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileManager = FileManager.default
                guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return
                }
                let fileURL = documentsURL.appendingPathComponent(gifName)
                try gif.data.write(to: fileURL)
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
        
    /// In this method  image files is converted from url to data to save in file manager.
    func saveGifInFileManager(url: URL, name: String, completion: @escaping (Bool) -> Void) {
        self.getImageData(imageUrl: url) { [self] image, data in
            if let gifData = data {
                let gif = GifDataModel(data: gifData )
                saveGifData(gif, gifName: name){ [self] result in
                    if result {
                        self.filesData = self.fetchSavedData()
                        completion(true)
                    }
                }
            }
        }
    }

    /// The fetch saved data is used to get data  from file manager
    func fetchSavedData() -> [File] {
        let file = self.getGifFilesFromFileManager()
        return file
    }
    
    /// This function is used for convertig Giphy URL to Image and it is loaded Asynchronously
    /// Cache has been used  if the data is already cached.
    /// If Data is not ready , download it usiing URL Session
    func getImageData(imageUrl: URL, completion: @escaping (UIImage?, Data?) -> Void) {
        if let cachedData = self.cache.object(forKey: imageUrl.absoluteString as NSString) {
            let gifIMage = UIImage.gif(data: cachedData as Data)
            completion(gifIMage, cachedData as Data)
        } else {
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let data = data {
                    // Cache the downloaded data
                    self.cache.setObject(data as NSData, forKey: imageUrl.absoluteString as NSString)
                    let gifIMage = UIImage.gif(data: data)
                    // Update the UIImageView with the downloaded data
                    DispatchQueue.main.async {
                        completion(gifIMage, data)
                    }
                }
            }
            task.resume()
        }
    }
    
    /// This method is  used to fetch saved data from file storage.
    func getGifFilesFromFileManager() ->[File] {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let files = fileURLs.map { url in
                File(id: url.lastPathComponent, url: url)
            }
            return files
        } catch {
            return []
        }
    }

    /// This method is accesed when user dislike the favorite button in trending screen and favorite screen.
    func removeDataFromFileManager(filePath: URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.removeItem(at: filePath)
            } catch {
                print("Error removing file: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist")
        }
    }   
}
