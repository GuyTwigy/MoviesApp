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
            if let isEmpty = defaults.value(forKey: AppConstant.UserDefualtsKey.topMoviesEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.topMoviesEmpty)
            defaults.synchronize()
        }
    }
    
    var dateTopMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstant.UserDefualtsKey.dateTopMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.dateTopMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localNowPlayingMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstant.UserDefualtsKey.nowPlayingMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.nowPlayingMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateNowPlayingMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstant.UserDefualtsKey.dateNowPlayingMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.dateNowPlayingMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localPopularMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstant.UserDefualtsKey.popularMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.popularMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var datePopularMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstant.UserDefualtsKey.datePopularMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.datePopularMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localTrendingMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstant.UserDefualtsKey.trendingMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.trendingMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateTrendingMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstant.UserDefualtsKey.dateTrendingMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.dateTrendingMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localUpcomingMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstant.UserDefualtsKey.upcomingMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.upcomingMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateUpcomingMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstant.UserDefualtsKey.dateUpcomingMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.dateUpcomingMoviesAdded)
            defaults.synchronize()
        }
    }
    
    var localSuggestionsMoviesIsEmpty: Bool {
        get {
            if let isEmpty = defaults.value(forKey: AppConstant.UserDefualtsKey.suggestionsMoviesIsEmpty) as? Bool {
                return isEmpty
            }
            return true
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.suggestionsMoviesIsEmpty)
            defaults.synchronize()
        }
    }
    
    var dateSuggestedMoviesAdded: Date? {
        get {
            if let date = defaults.value(forKey: AppConstant.UserDefualtsKey.dateSuggestedMoviesAdded) as? Date {
                return date
            }
            return nil
        }
        set {
            defaults.setValue(newValue, forKey: AppConstant.UserDefualtsKey.dateSuggestedMoviesAdded)
            defaults.synchronize()
        }
    }
}
