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
        
        var description: String {
            switch self {
            case .search:
                return "/search"
            case .movie:
                return "/movie"
            case .video:
                return "/videos"
            }
        }
    }
}
