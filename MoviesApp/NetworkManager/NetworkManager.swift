//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation


class NetworkManager {

    let baseUrl = "https://api.themoviedb.org/3"
    let apiKey = "ab0f464004f9fe46240dab71b2b89a08"
    
}

protocol FetchMoviesProtocol {
    func fetchMovies(optionSelected: OptionsSelection, query: String, page: Int) async throws -> MoviesRoot
    func fetchMultipleSuggestions(ids: [String]) async throws -> [MovieData]
}

extension NetworkManager: FetchMoviesProtocol {
    func fetchMovies(optionSelected: OptionsSelection, query: String = "", page: Int = 1) async throws -> MoviesRoot {
        var components = URLComponents()
        switch optionSelected {
        case .top:
            components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.movie.description)\(AppConstant.EndPoints.topRated.description)") ?? URLComponents()
            
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: String(page)),
            ]
        case .popular:
            components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.movie.description)\(AppConstant.EndPoints.popular.description)") ?? URLComponents()
            
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: String(page)),
            ]
        case .trending:
            components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.trending.description)\(AppConstant.EndPoints.movie.description)\(AppConstant.EndPoints.week.description)") ?? URLComponents()
            
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: String(page)),
            ]
        case .nowPlaying:
            components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.movie.description)\(AppConstant.EndPoints.nowPlaying.description)") ?? URLComponents()
            
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: String(page)),
            ]
        case .upcoming:
            components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.movie.description)\(AppConstant.EndPoints.upcoming.description)") ?? URLComponents()
            
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: String(page)),
            ]
        case .search:
            components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.search.description)\(AppConstant.EndPoints.movie.description)") ?? URLComponents()
            
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
            ]
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("max-age=86400", forHTTPHeaderField: "Cache-Control")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let movieResponse = try JSONDecoder().decode(MoviesRoot.self, from: data)
            return movieResponse
        } catch {
            throw error
        }
    }
    
    func fetchSingleSuggestion(id: String) async throws -> MovieData {
        let url = URL(string: "\(baseUrl)\(AppConstant.EndPoints.movie.description)/\(id)?api_key=\(apiKey)")
        guard let url else {
            throw URLError(.badURL)
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("max-age=86400", forHTTPHeaderField: "Cache-Control")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let movie = try JSONDecoder().decode(MovieData.self, from: data)
            return movie
        } catch {
            throw error
        }
    }
    
    func fetchMultipleSuggestions(ids: [String]) async throws -> [MovieData] {
        try await withThrowingTaskGroup(of: MovieData.self) { group in
            var movies: [MovieData] = []
            
            for id in ids {
                group.addTask { [weak self] in
                    guard let self else {
                        throw URLError(.badServerResponse)
                    }
                    
                    return try await self.fetchSingleSuggestion(id: id)
                }
            }
            
            for try await movie in group {
                movies.append(movie)
            }
            
            return movies
        }
    }
}

protocol GetTrailerProtocol {
    func getTrailer(id: String) async throws -> [VideoData]
}

extension NetworkManager: GetTrailerProtocol {
    
    func getTrailer(id: String) async throws -> [VideoData] {
        var components = URLComponents(string: "\(baseUrl)\(AppConstant.EndPoints.movie.description)/\(id)\(AppConstant.EndPoints.video.description)")
        
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("max-age=86400", forHTTPHeaderField: "Cache-Control")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let videoResponse = try JSONDecoder().decode(VideosResponse.self, from: data)
            return videoResponse.results
        } catch {
            throw error
        }
    }
}
