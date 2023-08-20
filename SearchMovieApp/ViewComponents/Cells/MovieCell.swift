//
//  MovieCell.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseId = "MovieCell"
    let imageView = AvatarImageView(frame: .zero)
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageAndTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: Movie) {
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        titleLabel.text = movie.title
        NetworkManager.shared.downloadImage(urlString: baseUrl + movie.posterPath) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func configureImageAndTitle() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        let padding: CGFloat = 8
        titleLabel.numberOfLines = 2
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
