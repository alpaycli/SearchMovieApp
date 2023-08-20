//
//  Genre.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 20.08.23.
//

import Foundation

struct GenreResult: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
