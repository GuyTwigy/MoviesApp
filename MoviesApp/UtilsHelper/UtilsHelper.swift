//
//  UtilsHelper.swift
//  MoviesApp
//
//  Created by Guy Twig on 03/07/2024.
//

import Foundation

class Utils {
    
    static func getImageUrl(posterPath: String, size: String = "original") -> URL? {
        let fullPath = "https://image.tmdb.org/t/p/\(size)\(posterPath)"
        return URL(string: fullPath)
    }
}
