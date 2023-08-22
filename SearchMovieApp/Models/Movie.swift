//
//  Movie.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let originalLanguage: String //
    let originalTitle: String
    let title: String
    let overview: String
    let releaseDate: String //
    let voteAverage: Double //
    let backdropPath: String
    let posterPath: String
    
    let genreIds: [Int]
}
