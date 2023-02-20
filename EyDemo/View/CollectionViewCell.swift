//
//  CollectionViewCell.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-17.
//

import UIKit

protocol FavoriteGiphyCellDelegate: AnyObject {
    func favoriteCellButtonClicked(_ cell: CollectionViewCell, didTapButton button: UIButton)
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonFavorite: UIButton!
    var delegate: FavoriteGiphyCellDelegate? = nil
    
    override func awakeFromNib() {
        buttonFavorite.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // Button Tap action of Collection View
    @objc func didTapButton (_ sender: UIButton) {
        delegate?.favoriteCellButtonClicked(self, didTapButton: sender)
    }
}
