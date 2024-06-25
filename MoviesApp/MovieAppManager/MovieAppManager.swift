//
//  MovieAppManager.swift
//  MoviesApp
//
//  Created by Guy Twig on 24/06/2024.
//

import Foundation

class MovieAppManager {
    
    static let sharedInstance: MovieAppManager = MovieAppManager()
    let defaults = UserDefaults.standard
    
    var localTopMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstants.UserDefualtsKey.topMoviesEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.topMoviesEmpty)
            defaults.synchronize()
        }
    }
    
    var dateTopMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstants.UserDefualtsKey.dateTopMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.dateTopMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localNowPlayingMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstants.UserDefualtsKey.nowPlayingMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.nowPlayingMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateNowPlayingMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstants.UserDefualtsKey.dateNowPlayingMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.dateNowPlayingMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localPopularMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstants.UserDefualtsKey.popularMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.popularMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var datePopularMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstants.UserDefualtsKey.datePopularMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.datePopularMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localTrendingMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstants.UserDefualtsKey.trendingMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.trendingMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateTrendingMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstants.UserDefualtsKey.dateTrendingMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.dateTrendingMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localUpcomingMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstants.UserDefualtsKey.upcomingMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.upcomingMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateUpcomingMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstants.UserDefualtsKey.dateUpcomingMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.dateUpcomingMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localSuggestionsMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstants.UserDefualtsKey.suggestionsMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.suggestionsMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateSuggestedMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstants.UserDefualtsKey.dateSuggestedMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstants.UserDefualtsKey.dateSuggestedMoviesAdded)
            defaults.synchronize()
        }
    }
}
