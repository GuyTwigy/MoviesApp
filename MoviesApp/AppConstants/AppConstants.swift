//
//  AppConstant.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

struct AppConstant {
    
    struct UserDefualtsKey {
        static let topMoviesEmpty: String = "topMoviesEmpty"
        static let dateTopMoviesAdded: String = "dateTopMoviesAdded"
        static let nowPlayingMoviesIsEmpty: String = "nowPlayingMoviesIsEmpty"
        static let dateNowPlayingMoviesAdded: String = "dateNowPlayingMoviesAdded"
        static let popularMoviesIsEmpty: String = "popularMoviesIsEmpty"
        static let datePopularMoviesAdded: String = "datePopularMoviesAdded"
        static let trendingMoviesIsEmpty: String = "trendingMoviesIsEmpty"
        static let dateTrendingMoviesAdded: String = "dateTrendingMoviesAdded"
        static let upcomingMoviesIsEmpty: String = "upcomingMoviesIsEmpty"
        static let dateUpcomingMoviesAdded: String = "dateUpcomingMoviesAdded"
        static let suggestionsMoviesIsEmpty: String = "suggestionsMoviesIsEmpty"
        static let dateSuggestedMoviesAdded: String = "dateSuggestedMoviesAdded"
    }
    
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
