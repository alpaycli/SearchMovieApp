//
//  SearchMovieVC.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 27.08.23.
//

import UIKit

class SearchMovieVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    private func setupViewController() {
        view.backgroundColor = .systemPurple
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
