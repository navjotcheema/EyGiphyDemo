//
//  ActivityIdicatorView.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-16.
//

import UIKit

class ActivityIdicatorView: UIView {

    var viewModel: HomeViewModel!
        
        // Add a UIActivityIndicatorView to your view
        let loader = UIActivityIndicatorView(style: .gray)
        
        func showLoader() {
            loader.center = self.center
            self.addSubview(loader)
            loader.startAnimating()
        }
        
        func hideLoader() {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
        
        func loadData() {
           // viewModel.loadData()
            
            switch viewModel.loadingState {
            case .loading:
                showLoader()
            case .loaded:
                hideLoader()
                // Update UI with loaded data
            case .error(let errorMessage):
                hideLoader()
                // Show error message
            }
        }
}
