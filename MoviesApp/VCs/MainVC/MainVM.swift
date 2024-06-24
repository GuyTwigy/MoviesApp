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
    var dataService: FetchMoviesProtocol
    private var movies: [MovieData] = []
    
    init(dataService: FetchMoviesProtocol) {
        self.dataService = dataService
    }
    
    func fetchSuggestion() async {
        do {
            let movies = try await dataService.fetchMultipleSuggestions(ids: ["1817", "745", "769", "278", "429"])
            if MovieAppManager.sharedInstance.localSuggestionsMoviesIsEmpty || Utils.isDataOlderThanOneDay(for: MovieAppManager.sharedInstance.dateSuggestedMoviesAdded) {
                try await CoreDataManager.shared.addMovies(movies, entityType: SuggestedMovies.self)
                let suggestedLocal = try await CoreDataManager.shared.fetchMovies(entityType: SuggestedMovies.self)
                MovieAppManager.sharedInstance.localSuggestionsMoviesIsEmpty = false
                MovieAppManager.sharedInstance.dateSuggestedMoviesAdded = suggestedLocal.first?.date
                delegate?.suggestionFetched(movies: suggestedLocal, error: nil)
            } else {
                delegate?.suggestionFetched(movies: movies, error: nil)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            await checkForLocalSuggestion(error: error)
        }
    }
    
    func checkForLocalSuggestion(error: Error) async {
        var localArray: [MovieData] = []
        do {
            localArray = try await CoreDataManager.shared.fetchMovies(entityType: SuggestedMovies.self)
            if localArray.isEmpty || Utils.isDataOlderThanOneDay(for: localArray.first?.date) {
                try await CoreDataManager.shared.clearMovies(entityType: SuggestedMovies.self)
                MovieAppManager.sharedInstance.localSuggestionsMoviesIsEmpty = true
                MovieAppManager.sharedInstance.dateSuggestedMoviesAdded = nil
                delegate?.suggestionFetched(movies: [], error: nil)
            } else {
                delegate?.suggestionFetched(movies: localArray, error: nil)
            }
        } catch {
            delegate?.suggestionFetched(movies: [], error: error)
        }
    }
    
    func fetchMovies(optionSelection: OptionsSelection, query: String, page: Int) async {
        do {
            let moviesData = try await dataService.fetchMovies(optionSelected: optionSelection, query: query, page: page)
            switch optionSelection {
            case .top:
                if MovieAppManager.sharedInstance.localTopMoviesIsEmpty || Utils.isDataOlderThanOneDay(for: MovieAppManager.sharedInstance.dateTopMoviesAdded) {
                    await moviesByOptions(optionSelection: optionSelection, moviesRoot: moviesData, page: page, type: TopMovies.self)
                } else {
                    delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, localFetch: false, error: nil)
                }
            case .popular:
                if MovieAppManager.sharedInstance.localPopularMoviesIsEmpty || Utils.isDataOlderThanOneDay(for: MovieAppManager.sharedInstance.datePopularMoviesAdded) {
                    await moviesByOptions(optionSelection: optionSelection, moviesRoot: moviesData, page: page, type: PopularMovies.self)
                } else {
                    delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, localFetch: false, error: nil)
                }
            case .trending:
                if MovieAppManager.sharedInstance.localTrendingMoviesIsEmpty || Utils.isDataOlderThanOneDay(for: MovieAppManager.sharedInstance.dateTrendingMoviesAdded) {
                    await moviesByOptions(optionSelection: optionSelection, moviesRoot: moviesData, page: page, type: TrendingMovies.self)
                } else {
                    delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, localFetch: false, error: nil)
                }
            case .nowPlaying:
                if MovieAppManager.sharedInstance.localNowPlayingMoviesIsEmpty || Utils.isDataOlderThanOneDay(for: MovieAppManager.sharedInstance.dateNowPlayingMoviesAdded) {
                    await moviesByOptions(optionSelection: optionSelection, moviesRoot: moviesData, page: page, type: NowPlayingMovies.self)
                } else {
                    delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, localFetch: false, error: nil)
                }
            case .upcoming:
                if MovieAppManager.sharedInstance.localUpcomingMoviesIsEmpty || Utils.isDataOlderThanOneDay(for: MovieAppManager.sharedInstance.dateUpcomingMoviesAdded) {
                    await moviesByOptions(optionSelection: optionSelection, moviesRoot: moviesData, page: page, type: UpcomingMovies.self)
                } else {
                    delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, localFetch: false, error: nil)
                }
            case .search:
                delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, localFetch: false, error: nil)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            switch optionSelection {
            case .top:
                await checkForLocal(optionSelection: optionSelection, type: TopMovies.self, error: error)
            case .popular:
                await checkForLocal(optionSelection: optionSelection, type: PopularMovies.self, error: error)
            case .trending:
                await checkForLocal(optionSelection: optionSelection, type: TrendingMovies.self, error: error)
            case .nowPlaying:
                await checkForLocal(optionSelection: optionSelection, type: NowPlayingMovies.self, error: error)
            case .upcoming:
                await checkForLocal(optionSelection: optionSelection, type: UpcomingMovies.self, error: error)
            case .search:
                delegate?.moviesFetched(moviesData: nil, addContent: false, localFetch: false, error: error)
            }
        }
    }
    
    func moviesByOptions<T: NSManagedObject>(optionSelection: OptionsSelection, moviesRoot: MoviesRoot, page: Int, type: T.Type) async {
        do {
            try await CoreDataManager.shared.addMovies(moviesRoot.results ?? [], entityType: type)
            let localArray =  try await CoreDataManager.shared.fetchMovies(entityType: type)
            switch optionSelection {
            case .top:
                MovieAppManager.sharedInstance.localTopMoviesIsEmpty = false
                MovieAppManager.sharedInstance.dateTopMoviesAdded = localArray.first?.date
            case .popular:
                MovieAppManager.sharedInstance.localPopularMoviesIsEmpty = false
                MovieAppManager.sharedInstance.datePopularMoviesAdded = localArray.first?.date
            case .trending:
                MovieAppManager.sharedInstance.localTrendingMoviesIsEmpty = false
                MovieAppManager.sharedInstance.dateTrendingMoviesAdded = localArray.first?.date
            case .nowPlaying:
                MovieAppManager.sharedInstance.localNowPlayingMoviesIsEmpty = false
                MovieAppManager.sharedInstance.dateNowPlayingMoviesAdded = localArray.first?.date
            case .upcoming:
                MovieAppManager.sharedInstance.localUpcomingMoviesIsEmpty = false
                MovieAppManager.sharedInstance.dateUpcomingMoviesAdded = localArray.first?.date
            case .search:
                break
            }
            delegate?.moviesFetched(moviesData: moviesRoot, addContent: page > 1, localFetch: false, error: nil)
        } catch {
            delegate?.moviesFetched(moviesData: moviesRoot, addContent: page > 1, localFetch: false, error: error)
        }
    }
    
    func checkForLocal<T: NSManagedObject>(optionSelection: OptionsSelection, type: T.Type, error: Error) async {
        var localArray: [MovieData] = []
        do {
            localArray = try await CoreDataManager.shared.fetchMovies(entityType: type)
            if localArray.isEmpty || Utils.isDataOlderThanOneDay(for: localArray.first?.date) {
                try await CoreDataManager.shared.clearMovies(entityType: type)
                switch optionSelection {
                case .top:
                    MovieAppManager.sharedInstance.localTopMoviesIsEmpty = true
                    MovieAppManager.sharedInstance.dateTopMoviesAdded = nil
                case .popular:
                    MovieAppManager.sharedInstance.localPopularMoviesIsEmpty = true
                    MovieAppManager.sharedInstance.datePopularMoviesAdded = nil
                case .trending:
                    MovieAppManager.sharedInstance.localTrendingMoviesIsEmpty = true
                    MovieAppManager.sharedInstance.dateTrendingMoviesAdded = nil
                case .nowPlaying:
                    MovieAppManager.sharedInstance.localNowPlayingMoviesIsEmpty = true
                    MovieAppManager.sharedInstance.dateNowPlayingMoviesAdded = nil
                case .upcoming:
                    MovieAppManager.sharedInstance.localUpcomingMoviesIsEmpty = true
                    MovieAppManager.sharedInstance.dateUpcomingMoviesAdded = nil
                case .search:
                    break
                }
                delegate?.moviesFetched(moviesData: nil, addContent: false, localFetch: false, error: error)
            } else {
                delegate?.moviesFetched(moviesData: MoviesRoot(results: localArray, page: nil, totalPages: nil), addContent: false, localFetch: true, error: nil)
            }
        } catch {
            delegate?.moviesFetched(moviesData: MoviesRoot(results: localArray, page: nil, totalPages: nil), addContent: false, localFetch: true, error: error)
        }
    }
}
