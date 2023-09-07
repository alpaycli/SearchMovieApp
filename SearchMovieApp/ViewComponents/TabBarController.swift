//
//  TabBarVC.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createMovieListVC()]
    }
    
    
    func createMovieListVC() -> UINavigationController {
        let movieListVC = MovieListVC()
        movieListVC.title = "Movies"
        movieListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
        return UINavigationController(rootViewController: movieListVC)
    }
    
    private func createSearchMovieVC() -> UINavigationController {
        let searchMovieVC = SearchMovieVC()
        searchMovieVC.title = "Search"
        searchMovieVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        return UINavigationController(rootViewController: searchMovieVC)
    }
    
}
