//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

protocol FetchMoviesProtocol {
    func fetchMovies() async throws -> ProductRoot
}

class NetworkManager: FetchMoviesProtocol {
    var baseUrl = "https://dummyjson.com/products"
    
    func fetchMovies() async throws -> [MovieData] {
        guard let url = URL(string: baseUrl) else {
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
            
            let productResponse = try JSONDecoder().decode(ProductRoot.self, from: data)
            return productResponse
        } catch {
            throw error
        }
    }
}
