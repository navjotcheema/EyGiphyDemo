//
//  TableFooterView.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-18.
//

import UIKit

class TableFooterView: UIView {

let activityIndicator = UIActivityIndicatorView(style:.medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    /// To setup activity indicator at  bottom of Table view displaying while pagination.
    private func setupViews() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
