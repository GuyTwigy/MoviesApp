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
    
    static func isDateOlderThanOneDay(for date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        guard let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: now) else {
            return false
        }
        return date < oneDayAgo
    }
}
