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
    
    enum Section {
        case main
    }
    
    var categoriesStackView = UIStackView()
    
    var selectedCategory: MovieType = .nowPlaying
    
    var movies: [Movie] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let button1 = GFButton(backgroundColor: .gray, title: "nowplaying")
        button1.addTarget(self, action: #selector(getNowPlaying), for: .touchUpInside)
        let button2 = GFButton(backgroundColor: .gray, title: "popular")
        button2.addTarget(self, action: #selector(getPopularMovies), for: .touchUpInside)
        let button3 = GFButton(backgroundColor: .gray, title: "toprated")
        button3.addTarget(self, action: #selector(getTopRatedMovies), for: .touchUpInside)
        let button4 = GFButton(backgroundColor: .gray, title: "upcoming")
        button4.addTarget(self, action: #selector(getUpcomingMovies), for: .touchUpInside)
        
        categoriesStackView.addArrangedSubview(button1)
        categoriesStackView.addArrangedSubview(button2)
        categoriesStackView.addArrangedSubview(button3)
        categoriesStackView.addArrangedSubview(button4)
        
        print("categoriesStackView.subviews.count", categoriesStackView.subviews.count)
        
    }
    
    @objc func getNowPlaying() {
        getMovies(type: .nowPlaying)
    }
    @objc func getPopularMovies() {
        getMovies(type: .popular)
    }
    @objc func getTopRatedMovies() {
        getMovies(type: .topRated)
    }
    @objc func getUpcomingMovies() {
        getMovies(type: .upcoming)
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
            categoriesStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            categoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesStackView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: categoriesStackView.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // This might need to be adjusted based on your layout requirements
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
