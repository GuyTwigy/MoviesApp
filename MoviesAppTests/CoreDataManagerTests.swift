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

    //Top movies
    func test_CoreDataManager_addMovies_and_fetchMovies_TopMovies() async {
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
                XCTAssertFalse(fetchedLocal.isEmpty)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    
    func test_CoreDataManager_fetchMovies_and_clearMovies_TopMovies() async {
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

      await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    
    //Upcoming movies
    func test_CoreDataManager_addMovies_and_fetchMovies_UpcomingMovies() async {
        //Given
        let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
        let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())
        
        //When
        let expectation = self.expectation(description: "Adding and fetching movies")
        Task {
            do {
                try await coreDataManager.addMovies([movie1, movie2], entityType: UpcomingMovies.self)
                var fetchedLocal = try await coreDataManager.fetchMovies(entityType: UpcomingMovies.self)
                expectation.fulfill()
                
                //Then
                XCTAssertEqual(fetchedLocal.count, 2)
                XCTAssertFalse(fetchedLocal.isEmpty)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    
    func test_CoreDataManager_fetchMovies_and_clearMovies_UpcomingMovies() async {
      // Given
      let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
      let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())

      let expectation = self.expectation(description: "Adding and fetching, removing and fetching movies")

      // When
      Task {
        do {
          try await coreDataManager.addMovies([movie1, movie2], entityType: UpcomingMovies.self)
          var fetchedMovies = try await coreDataManager.fetchMovies(entityType: UpcomingMovies.self)
          XCTAssertEqual(fetchedMovies.count, 2)
          XCTAssertFalse(fetchedMovies.isEmpty)

          // Clear movies
          try await coreDataManager.clearMovies(entityType: UpcomingMovies.self)
          fetchedMovies = try await coreDataManager.fetchMovies(entityType: UpcomingMovies.self)

          // Then
          XCTAssertEqual(fetchedMovies.count, 0)
          XCTAssertTrue(fetchedMovies.isEmpty)

          expectation.fulfill()
        } catch {
          XCTFail("Error: \(error)")
        }
      }

      await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    //Popular movies
    func test_CoreDataManager_addMovies_and_fetchMovies_PopularMovies() async {
        //Given
        let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
        let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())
        
        //When
        let expectation = self.expectation(description: "Adding and fetching movies")
        Task {
            do {
                try await coreDataManager.addMovies([movie1, movie2], entityType: PopularMovies.self)
                var fetchedLocal = try await coreDataManager.fetchMovies(entityType: PopularMovies.self)
                expectation.fulfill()
                
                //Then
                XCTAssertEqual(fetchedLocal.count, 2)
                XCTAssertFalse(fetchedLocal.isEmpty)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    
    func test_CoreDataManager_fetchMovies_and_clearMovies_PopularMovies() async {
      // Given
      let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
      let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())

      let expectation = self.expectation(description: "Adding and fetching, removing and fetching movies")

      // When
      Task {
        do {
          try await coreDataManager.addMovies([movie1, movie2], entityType: PopularMovies.self)
          var fetchedMovies = try await coreDataManager.fetchMovies(entityType: PopularMovies.self)
          XCTAssertEqual(fetchedMovies.count, 2)
          XCTAssertFalse(fetchedMovies.isEmpty)

          // Clear movies
          try await coreDataManager.clearMovies(entityType: PopularMovies.self)
          fetchedMovies = try await coreDataManager.fetchMovies(entityType: PopularMovies.self)

          // Then
          XCTAssertEqual(fetchedMovies.count, 0)
          XCTAssertTrue(fetchedMovies.isEmpty)

          expectation.fulfill()
        } catch {
          XCTFail("Error: \(error)")
        }
      }

      await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    //Trending movies
    func test_CoreDataManager_addMovies_and_fetchMovies_TrendingMovies() async {
        //Given
        let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
        let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())
        
        //When
        let expectation = self.expectation(description: "Adding and fetching movies")
        Task {
            do {
                try await coreDataManager.addMovies([movie1, movie2], entityType: TrendingMovies.self)
                var fetchedLocal = try await coreDataManager.fetchMovies(entityType: TrendingMovies.self)
                expectation.fulfill()
                
                //Then
                XCTAssertEqual(fetchedLocal.count, 2)
                XCTAssertFalse(fetchedLocal.isEmpty)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    
    func test_CoreDataManager_fetchMovies_and_clearMovies_TrendingMovies() async {
      // Given
      let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
      let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())

      let expectation = self.expectation(description: "Adding and fetching, removing and fetching movies")

      // When
      Task {
        do {
          try await coreDataManager.addMovies([movie1, movie2], entityType: TrendingMovies.self)
          var fetchedMovies = try await coreDataManager.fetchMovies(entityType: TrendingMovies.self)
          XCTAssertEqual(fetchedMovies.count, 2)
          XCTAssertFalse(fetchedMovies.isEmpty)

          // Clear movies
          try await coreDataManager.clearMovies(entityType: TrendingMovies.self)
          fetchedMovies = try await coreDataManager.fetchMovies(entityType: TrendingMovies.self)

          // Then
          XCTAssertEqual(fetchedMovies.count, 0)
          XCTAssertTrue(fetchedMovies.isEmpty)

          expectation.fulfill()
        } catch {
          XCTFail("Error: \(error)")
        }
      }

      await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    //NowPlaying movies
    func test_CoreDataManager_addMovies_and_fetchMovies_NowPlayingMovies() async {
        //Given
        let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
        let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())
        
        //When
        let expectation = self.expectation(description: "Adding and fetching movies")
        Task {
            do {
                try await coreDataManager.addMovies([movie1, movie2], entityType: NowPlayingMovies.self)
                var fetchedLocal = try await coreDataManager.fetchMovies(entityType: NowPlayingMovies.self)
                expectation.fulfill()
                
                //Then
                XCTAssertEqual(fetchedLocal.count, 2)
                XCTAssertFalse(fetchedLocal.isEmpty)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    
    func test_CoreDataManager_fetchMovies_and_clearMovies_NowPlayingMovies() async {
      // Given
      let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
      let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())

      let expectation = self.expectation(description: "Adding and fetching, removing and fetching movies")

      // When
      Task {
        do {
          try await coreDataManager.addMovies([movie1, movie2], entityType: NowPlayingMovies.self)
          var fetchedMovies = try await coreDataManager.fetchMovies(entityType: NowPlayingMovies.self)
          XCTAssertEqual(fetchedMovies.count, 2)
          XCTAssertFalse(fetchedMovies.isEmpty)

          // Clear movies
          try await coreDataManager.clearMovies(entityType: NowPlayingMovies.self)
          fetchedMovies = try await coreDataManager.fetchMovies(entityType: NowPlayingMovies.self)

          // Then
          XCTAssertEqual(fetchedMovies.count, 0)
          XCTAssertTrue(fetchedMovies.isEmpty)

          expectation.fulfill()
        } catch {
          XCTFail("Error: \(error)")
        }
      }

      await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    //Suggested movies
    func test_CoreDataManager_addMovies_and_fetchMovies_SuggestedMovies() async {
        //Given
        let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
        let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())
        
        //When
        let expectation = self.expectation(description: "Adding and fetching movies")
        Task {
            do {
                try await coreDataManager.addMovies([movie1, movie2], entityType: SuggestedMovies.self)
                var fetchedLocal = try await coreDataManager.fetchMovies(entityType: SuggestedMovies.self)
                expectation.fulfill()
                
                //Then
                XCTAssertEqual(fetchedLocal.count, 2)
                XCTAssertFalse(fetchedLocal.isEmpty)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    
    func test_CoreDataManager_fetchMovies_and_clearMovies_SuggestionMovies() async {
      // Given
      let movie1 = MovieData(id: 1, idString: "1", title: "Test Movie 1", posterPath: "/path1", overview: "Overview 1", releaseDate: "2022-01-01", originalLanguage: "en", voteAverage: 7.5, date: Date())
      let movie2 = MovieData(id: 2, idString: "2", title: "Test Movie 2", posterPath: "/path2", overview: "Overview 2", releaseDate: "2022-01-02", originalLanguage: "en", voteAverage: 8.0, date: Date())

      let expectation = self.expectation(description: "Adding and fetching, removing and fetching movies")

      // When
      Task {
        do {
          try await coreDataManager.addMovies([movie1, movie2], entityType: SuggestedMovies.self)
          var fetchedMovies = try await coreDataManager.fetchMovies(entityType: SuggestedMovies.self)
          XCTAssertEqual(fetchedMovies.count, 2)
          XCTAssertFalse(fetchedMovies.isEmpty)

          // Clear movies
          try await coreDataManager.clearMovies(entityType: SuggestedMovies.self)
          fetchedMovies = try await coreDataManager.fetchMovies(entityType: SuggestedMovies.self)

          // Then
          XCTAssertEqual(fetchedMovies.count, 0)
          XCTAssertTrue(fetchedMovies.isEmpty)

          expectation.fulfill()
        } catch {
          XCTFail("Error: \(error)")
        }
      }

      await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
}
