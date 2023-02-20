//
//  GifImageHelper.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-16.
//

import Foundation
import UIKit

/// This extension is used to convert Gif data into UIImage
extension UIImage {
    class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        let imagesCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []

        for imageIndex in 0..<imagesCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, imageIndex, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        if images.count == 1 {
            return images.first
        } else {
            return UIImage.animatedImage(with: images, duration: Double(imagesCount) * 0.1)
        }
    }
}
