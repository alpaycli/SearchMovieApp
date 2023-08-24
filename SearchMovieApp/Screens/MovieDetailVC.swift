//
//  MovieDetailVC.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    var movie: Movie!
    
    private var posterImageView = AvatarImageView(frame: .zero)
    private var movieTitle = TitleLabel(textAlignment: .center, fontSize: 24)
    
    private var genresStackView = UIStackView()
    
    
    private var overviewText = TitleLabel(textAlignment: .left, fontSize: 24)
    private let bioLabel = BodyLabel(textAlignment: .left)
        
    private var displayableGenres: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchGenres()
        configureViews()
        setImage()
        setElements()
        configureUI()
    }
    
    private func configureViews() {
        view.addSubviews(posterImageView, movieTitle, genresStackView, overviewText, bioLabel)
    }
    
    private func configureGenresStackView() {
        genresStackView.axis = .horizontal
        genresStackView.distribution = .fillEqually
        for genre in displayableGenres {
            let element = TitleLabel(textAlignment: .center, fontSize: 16)
            element.text = genre
            genresStackView.addArrangedSubview(element)
        }
        print(genresStackView.subviews.count)
    }
    
    private func setImage() {
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        NetworkManager.shared.downloadImage(urlString: baseUrl + movie.backdropPath) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }
    }
    
    private func setElements() {
        movieTitle.text = movie.title
        overviewText.text = "Overview"
        bioLabel.text = movie.overview
        bioLabel.numberOfLines = 10
    }
    
    private func configureUI() {
        genresStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -60),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 220),
            
            movieTitle.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 40),
            movieTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            movieTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            movieTitle.heightAnchor.constraint(equalToConstant: 40),
            
            genresStackView.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 20),
            genresStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genresStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genresStackView.heightAnchor.constraint(equalToConstant: 80),
            
            overviewText.topAnchor.constraint(equalTo: genresStackView.bottomAnchor, constant: 20),
            overviewText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overviewText.heightAnchor.constraint(equalToConstant: 40),
            
            bioLabel.topAnchor.constraint(equalTo: overviewText.bottomAnchor, constant: 6),
            bioLabel.leadingAnchor.constraint(equalTo: overviewText.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bioLabel.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func fetchGenres() {
        let headers = [
            "Authorization": Const.auth,
            "accept": Const.accept
        ]
        
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en") else { return }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        
        APIService.shared.fetch(GenreResult.self, url: urlRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let result):
                var items = [String]()
                for i in movie.genreIds {
                    let item = result.genres.filter { $0.id == i }.map { $0.name }
                    items.append(item.joined())
                }
                DispatchQueue.main.async {
                    self.displayableGenres = items
                    self.configureGenresStackView()
                }
                    
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
