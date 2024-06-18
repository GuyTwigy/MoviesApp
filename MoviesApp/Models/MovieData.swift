//
//  MovieData.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

struct MovieRoot: Codable {
    let results: [MovieData]
}

struct MovieData: Codable {
    let id: Int?
    let title: String?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}
