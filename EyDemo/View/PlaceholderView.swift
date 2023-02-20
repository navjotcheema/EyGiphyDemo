//
//  PlaceholderView.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-19.
//

import UIKit

class PlaceholderView: UIView {
   
    let label = UILabel()
        
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        label.text = "No Giphy found"
        label.textColor = .gray
        label.textAlignment = .center
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
