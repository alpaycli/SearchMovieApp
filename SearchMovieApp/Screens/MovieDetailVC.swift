//
//  MovieDetailVC.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    var movie: Movie!
    
    var titleLabel = TitleLabel(textAlignment: .center, fontSize: 26)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    func configure() {
        view.addSubview(titleLabel)
        titleLabel.text = movie.title
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
