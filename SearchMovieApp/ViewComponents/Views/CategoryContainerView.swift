//
//  CategoryContainerView.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 20.08.23.
//

import UIKit

class CategoryContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 16
        backgroundColor = .secondarySystemFill
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
