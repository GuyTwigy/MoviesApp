//
//  MainVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation
import CoreData

protocol MainVMDelagate: AnyObject {
    func moviesFetched(moviesData: MoviesRoot?, addContent: Bool, localFetch: Bool, error: Error?)
    func suggestionFetched(movies: [MovieData], error: Error?)
}

class MainVM {
    weak var delegate: MainVMDelagate?
    private var networkManager = NetworkManager()
    
    func fetchMovies(optionSelection: OptionsSelection, query: String, page: Int) async {
        do {
            let moviesData = try await networkManager.fetchMovies(optionSelected: optionSelection, query: query, page: page)
            switch optionSelection {
            case .top:
                await moviesByOptions(moviesRoot: moviesData, page: page, type: TopMovies.self)
            case .popular:
                await moviesByOptions(moviesRoot: moviesData, page: page, type: PopularMovies.self)
            case .trending:
                await moviesByOptions(moviesRoot: moviesData, page: page, type: TrendingMovies.self)
            case .nowPlaying:
                await moviesByOptions(moviesRoot: moviesData, page: page, type: NowPlayingMovies.self)
            case .upcoming:
                await moviesByOptions(moviesRoot: moviesData, page: page, type: UpcomingMovies.self)
            case .search:
                delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, localFetch: false, error: nil)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            switch optionSelection {
            case .top:
                await checkForLocal(type: TopMovies.self, error: error)
            case .popular:
                await checkForLocal(type: PopularMovies.self, error: error)
            case .trending:
                await checkForLocal(type: TrendingMovies.self, error: error)
            case .nowPlaying:
                await checkForLocal(type: NowPlayingMovies.self, error: error)
            case .upcoming:
                await checkForLocal(type: UpcomingMovies.self, error: error)
            case .search:
                delegate?.moviesFetched(moviesData: nil, addContent: false, localFetch: false, error: error)
            }
        }
    }
    
    func fetchSuggestion() async {
        do {
            let movies = try await networkManager.fetchMultipleSuggestions(ids: ["1817", "745", "769", "278", "429"])
            var suggestedLocal = try await CoreDataManager.shared.fetchMovies(entityType: SuggestedMovies.self)
            if suggestedLocal.isEmpty || Utils.isDataOlderThanOneDay(for: suggestedLocal.first?.date) {
                try await CoreDataManager.shared.clearMovies(entityType: SuggestedMovies.self)
                try await CoreDataManager.shared.addMovies(movies, entityType: SuggestedMovies.self)
                suggestedLocal = try await CoreDataManager.shared.fetchMovies(entityType: SuggestedMovies.self)
                delegate?.suggestionFetched(movies: suggestedLocal, error: nil)
            } else {
                delegate?.suggestionFetched(movies: movies, error: nil)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            delegate?.suggestionFetched(movies: [], error: error)
        }
    }
    
    func moviesByOptions<T: NSManagedObject>(moviesRoot: MoviesRoot, page: Int, type: T.Type) async {
        do {
            var localArray = try await CoreDataManager.shared.fetchMovies(entityType: type)
            if localArray.isEmpty || Utils.isDataOlderThanOneDay(for: localArray.first?.date) {
                try await CoreDataManager.shared.clearMovies(entityType: type)
                try await CoreDataManager.shared.addMovies(moviesRoot.results ?? [], entityType: type)
                localArray =  try await CoreDataManager.shared.fetchMovies(entityType: type)
                let moviesData = MoviesRoot(results: localArray, page: nil, totalPages: nil)
                self.delegate?.moviesFetched(moviesData: moviesData, addContent: false, localFetch: false, error: nil)
            } else {
                self.delegate?.moviesFetched(moviesData: moviesRoot, addContent: page > 1, localFetch: false, error: nil)
            }
        } catch {
            self.delegate?.moviesFetched(moviesData: moviesRoot, addContent: page > 1, localFetch: false, error: error)
        }
    }
    
    func checkForLocal<T: NSManagedObject>(type: T.Type, error: Error) async {
        var localArray: [MovieData] = []
        do {
            localArray = try await CoreDataManager.shared.fetchMovies(entityType: type)
            if localArray.isEmpty || Utils.isDataOlderThanOneDay(for: localArray.first?.date) {
                try await CoreDataManager.shared.clearMovies(entityType: type)
                delegate?.moviesFetched(moviesData: nil, addContent: false, localFetch: false, error: error)
            } else {
                delegate?.moviesFetched(moviesData: MoviesRoot(results: localArray, page: nil, totalPages: nil), addContent: false, localFetch: true, error: nil)
            }
        } catch {
            delegate?.moviesFetched(moviesData: MoviesRoot(results: localArray, page: nil, totalPages: nil), addContent: false, localFetch: true, error: error)
        }
    }
}
