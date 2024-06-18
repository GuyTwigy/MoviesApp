//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

protocol FetchMoviesProtocol {
    func fetchMovies(query: String, region: String?, year: Int?, primaryReleaseYear: Int?) async throws -> [MovieData]
}

class NetworkManager: FetchMoviesProtocol {
    
    var baseUrl = "https://api.themoviedb.org/3"
    let apiKey = "ab0f464004f9fe46240dab71b2b89a08"
    
    func fetchMovies(query: String, region: String? = nil, year: Int? = nil, primaryReleaseYear: Int? = nil) async throws -> [MovieData] {
        var components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.search.description)\(AppConstant.EndPoints.movie.description)")
        
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: query)
        ]
        
        if let region {
            components?.queryItems?.append(URLQueryItem(name: "region", value: region))
        }
        if let year {
            components?.queryItems?.append(URLQueryItem(name: "year", value: String(year)))
        }
        if let primaryReleaseYear {
            components?.queryItems?.append(URLQueryItem(name: "primary_release_year", value: String(primaryReleaseYear)))
        }
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let movieResponse = try JSONDecoder().decode(MovieRoot.self, from: data)
            return movieResponse.results
        } catch {
            throw error
        }
    }
    
    func getImageUrl(posterPath: String, size: String = "w500") -> URL? {
        let fullPath = "https://image.tmdb.org/t/p/\(size)\(posterPath)"
        return URL(string: fullPath)
    }
}
