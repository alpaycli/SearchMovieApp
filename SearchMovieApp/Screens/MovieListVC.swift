//
//  ViewController.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

enum MovieType: String, CaseIterable {
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case popular = "popular"
    case upcoming = "upcoming"
}


class MovieListVC: UIViewController {
    
    private enum Section { case main }
    
    private var selectedCategory: MovieType = .nowPlaying
    
    private var movies: [Movie] = []
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private var scrollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        scrollView.addSubview(scrollStackView)
        scrollStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            scrollStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        NetworkManager.shared.fetchMovies(type: .nowPlaying) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    for item in movies.results {
                        let posterImage = AvatarImageView(frame: .zero)
                        let baseUrl = "https://image.tmdb.org/t/p/w500/"
                        NetworkManager.shared.downloadImage(urlString: baseUrl + item.posterPath) { image in
                            DispatchQueue.main.async {
                                posterImage.image = image
                            }
                        }
                        
                        let itemWidth = (ScreenSize.width / 2) - 50
                        let itemHeight = itemWidth * 1.5
                        
                        posterImage.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
                        posterImage.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
                        
                        self.scrollStackView.addArrangedSubview(posterImage)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private var categoriesStackView = UIStackView()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureCategoriesStackView()
        setupViewController()
        getMovies(type: selectedCategory)
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureCategoriesStackView() {
        categoriesStackView.axis = .horizontal
        categoriesStackView.distribution = .fillEqually
        view.addSubview(categoriesStackView)
        
        for i in MovieType.allCases {
            let button = GFButton(backgroundColor: .systemGray, title: i.rawValue.capitalized)
            button.category = i
            button.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
            categoriesStackView.addArrangedSubview(button)
        }
    }
    
    @objc func buttonAction(_ sender: GFButton) {
        switch sender.category {
        case .nowPlaying:
            getMovies(type: .nowPlaying)
        case .topRated:
            getMovies(type: .topRated)
        case .popular:
            getMovies(type: .popular)
        case .upcoming:
            getMovies(type: .upcoming)
        }
        
        selectedCategory = sender.category
    }
    
    private func getMovies(type: MovieType) {
        NetworkManager.shared.fetchMovies(type: type) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.movies = movies.results
                print(self.movies.count)
            case .failure(let error):
                print(error)
            }
            
            self.updateData(self.movies)
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseId)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesStackView.topAnchor.constraint(equalTo: scrollStackView.bottomAnchor, constant: 10),
            categoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesStackView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: categoriesStackView.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseId, for: indexPath) as! MovieCell
            cell.set(movie: movie)
            return cell
        })
    }
    
    private func updateData(_ data: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension MovieListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let currentFollowers = isSearching ? filteredFollowers : followers
        let movie = movies[indexPath.item]
        let destinationVC = MovieDetailVC()
        destinationVC.movie = movie
//        destinationVC.delegate = self
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
}
