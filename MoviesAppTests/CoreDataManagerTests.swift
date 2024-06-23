//
//  CoreDataManagerTests.swift
//  MoviesAppTests
//
//  Created by Guy Twig on 23/06/2024.
//

import XCTest
import CoreData
@testable import MoviesApp

final class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManagerProtocol!
    
    override func setUpWithError() throws {
        coreDataManager = MockCoreDataManager.shared
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
    }

    func test_CoreDataManager_addMovies() {
        let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
        let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())
        
        coreDataManager.addMovies([movie1, movie2], entityType: TopMovies.self)
        
        let fetchedMovies = coreDataManager.fetchMovies(entityType: TopMovies.self)
        XCTAssertEqual(fetchedMovies.count, 2)
        XCTAssertEqual(fetchedMovies[0].title, "Test Movie 1")
        XCTAssertEqual(fetchedMovies[1].title, "Test Movie 2")
        XCTAssertFalse(fetchedMovies.isEmpty)
    }
}
