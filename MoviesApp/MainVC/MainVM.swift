//
//  MainVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

protocol MainVMDelagate: AnyObject {
<<<<<<< Updated upstream
    func moviesFetched(movies: [MovieData], error: Error?)
=======
    func moviesFetched(moviesData: MoviesRoot?, addContent: Bool, error: Error?)
>>>>>>> Stashed changes
}

class MainVM {
    
    weak var delegate: MainVMDelagate?
    private var networkManager = NetworkManager()
    
<<<<<<< Updated upstream
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
=======
    func fetchMovies(query: String, page: Int) async {
        do {
            let moviesData = try await networkManager.fetchMovies(query: query, page: page)
            delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, error: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
            delegate?.moviesFetched(moviesData: nil, addContent: false, error: error)
>>>>>>> Stashed changes
        }
    }
}
