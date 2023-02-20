//
//  GridFlowLayout.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-18.
//

import Foundation
import UIKit

/// This class is used to show collectionvie item in grid format.
class GridFlowLayOut: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let collectionViewWidth = collectionView!.bounds.width
        let imageViewWidth = collectionViewWidth * 0.3
        let imageViewHeight = imageViewWidth + 50
        itemSize = CGSize(width:imageViewWidth, height: imageViewHeight)
        minimumLineSpacing = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollDirection = .vertical
    }
}
