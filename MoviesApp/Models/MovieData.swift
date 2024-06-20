//
//  MovieData.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

<<<<<<< Updated upstream
struct MovieRoot: Codable {
    let results: [MovieData]
=======
struct MoviesRoot: Codable {
    let results: [MovieData]?
    let page: Int?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
    }
>>>>>>> Stashed changes
}

struct MovieData: Codable {
    let id: Int?
    let title: String?
    let posterPath: String?
<<<<<<< Updated upstream
=======
    let overview: String?
    let releaseDate: String?
    let originalLanguage: String?
    let voteAverage: Double?
    
>>>>>>> Stashed changes

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
<<<<<<< Updated upstream
=======
        case overview
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
>>>>>>> Stashed changes
    }
}
