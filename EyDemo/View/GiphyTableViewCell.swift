//
//  GiphyTableViewCell.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import UIKit

// Add a protocol to define the delegate method for the button tap
protocol MyGiphyCellDelegate: AnyObject {
    func cell(_ cell: GiphyTableViewCell, didTapButton button: UIButton)
}

class GiphyTableViewCell: UITableViewCell {
    var homeViewModel: HomeViewModel = HomeViewModel()
    weak var delegate: MyGiphyCellDelegate?
    var indexPath: IndexPath?
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var gifImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        buttonFavorite.isHighlighted = false
        buttonFavorite.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // Buttn Tap action
    @objc func didTapButton (_ sender: UIButton) {
        delegate?.cell(self, didTapButton: sender)
    }
}

