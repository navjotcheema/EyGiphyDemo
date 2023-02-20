//
//  HomeModel.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import Foundation
struct GiphyImages:Codable{
    
    var imageUrl :String
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
