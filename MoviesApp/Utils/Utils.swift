//
//  Utils.swift
//  MoviesApp
//
//  Created by Guy Twig on 19/06/2024.
//

import Foundation

class Utils {
    
    static func getImageUrl(posterPath: String, size: String = "original") -> URL? {
        let fullPath = "https://image.tmdb.org/t/p/\(size)\(posterPath)"
        return URL(string: fullPath)
    }
}

