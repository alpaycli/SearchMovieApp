//
//  CategoryItemLabel.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 20.08.23.
//

import UIKit

class CategoryItemView: UIView {
    
    let containerView = CategoryContainerView(frame: .zero)
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainerView()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configureContainerView() {
        addSubview(containerView)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 80),
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        let padding: CGFloat = 6
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
}
