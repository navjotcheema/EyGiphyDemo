//
//  GifDataModel.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-17.
//

import Foundation

struct GifDataModel {
    let data: Data
}

struct File:Equatable {
    let id: String
    let url: URL
    init(id: String, url: URL) {
        self.id = id
        self.url = url
    }
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id && lhs.url == rhs.url
    }
}
