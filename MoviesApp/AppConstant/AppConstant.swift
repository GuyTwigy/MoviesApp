//
//  AppConstant.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

struct AppConstant {
    
    enum EndPoints {
        case search
        case movie
        case video
        case topRated
        case popular
        case trending
        case week
        case nowPlaying
        case upcoming
        
        var description: String {
            switch self {
            case .search:
                return "/search"
            case .movie:
                return "/movie"
            case .video:
                return "/videos"
            case .topRated:
                return "/top_rated"
            case .popular:
                return "/popular"
            case .trending:
                return "/trending"
            case .week:
                return "/week"
            case .nowPlaying:
                return "/now_playing"
            case .upcoming:
                return "/upcoming"
            }
        }
    }
}
