//
//  FavoriteViewModel.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-17.
//

import UIKit

class FavoriteViewModel {
    var buttonAction: (() -> Void)?
    let items = ["Grid", "List"]
    var isGrid: Bool = true
    
    /// This function is used to togle collection view data to view in Grid and List
    func toggleLayout() {
        isGrid.toggle()
    }
    
    ///  This function handle the tap action of favorite button.
    func handleButtonAction() {
        buttonAction?()
    }
}
