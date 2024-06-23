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

    func test_CoreDataManager_addMovies_and_fetchMovies() async {
        //Given
        let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
        let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())
        
        //When
        let expectation = self.expectation(description: "Adding and fetching movies")
        Task {
            do {
                try await coreDataManager.addMovies([movie1, movie2], entityType: TopMovies.self)
                var fetchedLocal = try await coreDataManager.fetchMovies(entityType: TopMovies.self)
                expectation.fulfill()
                
                //Then
                XCTAssertEqual(fetchedLocal.count, 2)
                XCTAssertEqual(fetchedLocal[0].title, "Test Movie 1")
                XCTAssertEqual(fetchedLocal[1].title, "Test Movie 2")
                XCTAssertFalse(fetchedLocal.isEmpty)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0, enforceOrder: true)
    }
    
    
    func test_CoreDataManager_fetchMovies_and_clearMovies() async {
      // Given
      let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
      let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())

      let expectation = self.expectation(description: "Adding and fetching, removing and fetching movies")

      // When
      Task {
        do {
          try await coreDataManager.addMovies([movie1, movie2], entityType: TopMovies.self)
          var fetchedMovies = try await coreDataManager.fetchMovies(entityType: TopMovies.self)
          XCTAssertEqual(fetchedMovies.count, 2)
          XCTAssertFalse(fetchedMovies.isEmpty)

          // Clear movies
          try await coreDataManager.clearMovies(entityType: TopMovies.self)
          fetchedMovies = try await coreDataManager.fetchMovies(entityType: TopMovies.self)

          // Then
          XCTAssertEqual(fetchedMovies.count, 0)
          XCTAssertTrue(fetchedMovies.isEmpty)

          expectation.fulfill()
        } catch {
          XCTFail("Error: \(error)")
        }
      }

      await fulfillment(of: [expectation], timeout: 5.0, enforceOrder: true)
    }
}
