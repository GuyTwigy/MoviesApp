//
//  MainVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

protocol MainVMDelagate: AnyObject {
    func moviesFetched(moviesData: MoviesRoot?, addContent: Bool, error: Error?)
    func suggestionFetched(movies: [MovieData], error: Error?)
}

class MainVM {
    weak var delegate: MainVMDelagate?
    private var networkManager = NetworkManager()
    
    func fetchMovies(optionSelection: OptionsSelection, query: String, page: Int) async {
        do {
            let moviesData = try await networkManager.fetchMovies(optionSelected: optionSelection, query: query, page: page)
            delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, error: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
            delegate?.moviesFetched(moviesData: nil, addContent: false, error: error)
        }
    }
    
    func fetchSuggestion() async {
        do {
            let movies = try await networkManager.fetchMultipleSuggestions(ids: ["1817", "745", "769", "278", "429"])
            var suggestedLocal = CoreDataManager.shared.fetchMovies(entityType: SuggestedMovies.self)
            if suggestedLocal.isEmpty || Utils.isDataOlderThanOneDay(for: suggestedLocal.first?.date) {
                CoreDataManager.shared.clearMovies(entityType: SuggestedMovies.self)
                CoreDataManager.shared.addMovies(movies, entityType: SuggestedMovies.self)
                suggestedLocal = CoreDataManager.shared.fetchMovies(entityType: SuggestedMovies.self)
                delegate?.suggestionFetched(movies: suggestedLocal, error: nil)
            } else {
                delegate?.suggestionFetched(movies: movies, error: nil)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            delegate?.suggestionFetched(movies: [], error: error)
        }
    }
}
