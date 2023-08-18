//
//  ViewController.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

enum MovieType: String {
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case popular = "popular"
    case upcoming = "upcoming"
}


class MovieListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var nowShowingMovies: [Movie] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    
    var navtext = TitleLabel(textAlignment: .left, fontSize: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        getMovies(type: .popular)
        configureCollectionView()
        configureDataSource()
    }
    
    private func getMovies(type: MovieType) {
        NetworkManager.shared.fetchMovies(type: type) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.nowShowingMovies = movies.results
                print(self.nowShowingMovies.count)
            case .failure(let error):
                print(error)
            }
            
            self.updateData(self.nowShowingMovies)
        }
        
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseId)
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
        let movie = nowShowingMovies[indexPath.item]
        
        let destinationVC = MovieDetailVC()
        destinationVC.movieId = movie.id
//        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
        
    }
    
}
