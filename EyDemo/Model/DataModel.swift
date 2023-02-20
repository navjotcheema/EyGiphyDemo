//
//  DataModel.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import Foundation

struct GiphyData: Codable {
    let data: [Gif]
}
struct Gif: Codable {
    let id: String
    let url: URL
    let title: String
    let images: Images
}

// MARK: - Images
struct Images: Codable {
    let original: FixedHeight
    let fixedHeight: FixedHeight
    init(original: FixedHeight, fixedHeight: FixedHeight) {
        self.original = original
        self.fixedHeight = fixedHeight
    }
}

extension Images {
    enum CodingKeys: String, CodingKey {
        case original
        case fixedHeight = "fixed_height"
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let height, width, size: String
    let url: URL
}

extension FixedHeight {
    enum CodingKeys: String, CodingKey {
        case height, width, size, url
    }
}
