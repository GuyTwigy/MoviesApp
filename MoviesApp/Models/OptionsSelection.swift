//
//  OptionsSelection.swift
//  MoviesApp
//
//  Created by Guy Twig on 21/06/2024.
//

import Foundation

enum OptionsSelection: String {
    case top = "Top"
    case popular = "Popular"
    case trending = "Trending"
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case search
    
    var intValue: Int {
        switch self {
        case .top:
            0
        case .popular:
            1
        case .trending:
            2
        case .nowPlaying:
            3
        case .upcoming:
            4
        case .search:
            5
        }
    }
    
    init(intValue: Int) {
        switch intValue {
        case 0:
            self = .top
        case 1:
            self = .popular
        case 2:
            self = .trending
        case 3:
            self = .nowPlaying
        case 4:
            self = .upcoming
        default:
            self = .search
        }
    }
}
