//
//  MainVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

protocol MainVMDelagate: AnyObject {
    func moviesFetched(movies: [MovieData], error: Error?)
}

class MainVM {
    
    weak var delegate: MainVMDelagate?
    private var networkManager = NetworkManager()
    
    func fetchMovies(query: String) async {
        do {
            let movies = try await networkManager.fetchMovies(query: query)
            for movie in movies {
                print("Title: \(movie.title ?? "no title")")
            }
            delegate?.moviesFetched(movies: movies, error: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
            delegate?.moviesFetched(movies: [], error: error)
        }
    }
}
