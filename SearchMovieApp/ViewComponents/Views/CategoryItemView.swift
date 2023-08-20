//
//  CategoryItemLabel.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 20.08.23.
//

import UIKit

class CategoryItemView: UIView {
    
    let containerView = CategoryContainerView(frame: .zero)
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: 12)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTitleLabel()
        configureContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContainerView() {
        addSubview(containerView)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10)
        ])
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        let padding: CGFloat = 10
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
