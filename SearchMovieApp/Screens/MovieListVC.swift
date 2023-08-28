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
    private let headerId = "headerId"
    private let categoryHeaderId = "categoryHeaderId"
    
    var hasMoreFollowers = true
    var isLoadingFollowers = false
    
    var selectedCategory: MovieType = .nowPlaying
    var page = 1
    
    var movies: [Movie] = []
    var headerMovies: [Movie] = []
    
    var categoriesStackView = UIStackView()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCategoriesStackView()
        setupViewController()
        getMovies(type: .nowPlaying)
        getHeaderMovies()
        configureCollectionView()
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
        page = 1
        movies = []
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
    
    private func getHeaderMovies() {
        NetworkManager.shared.fetchMovies(type: .nowPlaying, page: 1) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.headerMovies = movies.results
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getMovies(type: MovieType) {
        isLoadingFollowers = true
        NetworkManager.shared.fetchMovies(type: type, page: page) { [weak self] result in
            guard let self else { return }
            
            isLoadingFollowers = false
            switch result {
            case .success(let movies):
                if movies.results.count < 20 { hasMoreFollowers = false }
                DispatchQueue.main.async {
                    self.movies.append(contentsOf: movies.results)
                    self.collectionView.reloadData()
                }
                print(self.movies.count)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout() )
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseId)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: categoryHeaderId, withReuseIdentifier: headerId)
                
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.createFirstSection()
            case 1: return self.createSecondSection()
            default: return self.createFirstSection()
            }
        }
    }
    
    private func createFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 60, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(0.55))
                
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
    
    private func createSecondSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(180))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.35))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 15
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: categoryHeaderId, alignment: .top)
        ]
        
        return section
    }
    
//    private func updateData(_ data: [Movie]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(data)
//        DispatchQueue.main.async {
//            self.dataSource.apply(snapshot, animatingDifferences: true)
//        }
//    }
    
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension MovieListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if scrollY > contentHeight - screenHeight {
            guard hasMoreFollowers, !isLoadingFollowers else { return }
            getMovies(type: selectedCategory)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movie: Movie
        switch indexPath.section {
        case 0:
            movie = headerMovies[indexPath.row]
        case 1:
            movie = movies[indexPath.row]
        default:
            movie = movies[indexPath.row]
        }
        
        let destinationVC = MovieDetailVC()
        destinationVC.movie = movie
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension MovieListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        
        case 0:
            return headerMovies.count
        case 1:
            return movies.count
        default:
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseId, for: indexPath) as! MovieCell
        
        switch indexPath.section {
        case 0:
            let movie = headerMovies[indexPath.row]
            cell.set(movie: movie)
        case 1:
            let movie = movies[indexPath.row]
            cell.set(movie: movie)
        default:
            break
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        
        return header
    }
}

