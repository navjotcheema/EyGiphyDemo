//
//  ListFlowlLayout.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-18.
//

import Foundation
import UIKit

/// This class is used to show collectionvie item in list format.
class ListFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let cellWidth = collectionView!.frame.width
        let cellSize = CGSize(width: cellWidth, height: 200)
        itemSize = cellSize
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollDirection = .vertical
    }
}
