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
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: 20)
    
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
            print(baseUrl + movie.posterPath)
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
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
