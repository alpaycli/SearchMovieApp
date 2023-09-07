//
//  CategoryHeaderView.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 26.08.23.
//

import UIKit

class CategoryHeaderView: UICollectionReusableView {
    
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text =  "Categories"
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
