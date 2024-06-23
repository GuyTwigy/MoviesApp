//
//  MainVCTests.swift
//  MoviesAppTests
//
//  Created by Guy Twig on 23/06/2024.
//

import XCTest
@testable import MoviesApp

final class MainVCTests: XCTestCase {
    
    var vm: MainVM?
    var dataService: FetchMoviesProtocol?
    
    override func setUpWithError() throws {
        dataService = NetworkManager()
        if let dataService {
            vm = MainVM(dataService: dataService)
        }
    }
    
    override func tearDownWithError() throws {
        vm = nil
        dataService = nil
    }
    
    func test_MainVM_FetchTopMoviesSuccess() async {
        // Given
        let optionSelection: OptionsSelection = .top
        let query = ""
        let page = 1
        
        // When
        let expectation = self.expectation(description: "Fetch top movies")
        Task {
            do {
                let moviesData = try await dataService?.fetchMovies(optionSelected: optionSelection, query: query, page: page)
                expectation.fulfill()
                
                //Then
                XCTAssertGreaterThan(moviesData?.results?.count ?? 2, 2)
                XCTAssertNotNil(moviesData)
                XCTAssertEqual(moviesData?.results?.count, 20)
                XCTAssertEqual(moviesData?.page, 1)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    func test_MainVM_FetchPopularMoviesSuccess() async {
        // Given
        let optionSelection: OptionsSelection = .popular
        let query = ""
        let page = 1
        
        // When
        let expectation = self.expectation(description: "Fetch top movies")
        Task {
            do {
                let moviesData = try await dataService?.fetchMovies(optionSelected: optionSelection, query: query, page: page)
                expectation.fulfill()
                
                //Then
                XCTAssertGreaterThan(moviesData?.results?.count ?? 2, 2)
                XCTAssertNotNil(moviesData)
                XCTAssertEqual(moviesData?.results?.count, 20)
                XCTAssertEqual(moviesData?.page, 1)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    func test_MainVM_FetchUpcomingMoviesSuccess() async {
        // Given
        let optionSelection: OptionsSelection = .upcoming
        let query = ""
        let page = 1
        
        // When
        let expectation = self.expectation(description: "Fetch top movies")
        Task {
            do {
                let moviesData = try await dataService?.fetchMovies(optionSelected: optionSelection, query: query, page: page)
                expectation.fulfill()
                
                //Then
                XCTAssertGreaterThan(moviesData?.results?.count ?? 2, 2)
                XCTAssertNotNil(moviesData)
                XCTAssertEqual(moviesData?.results?.count, 20)
                XCTAssertEqual(moviesData?.page, 1)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    func test_MainVM_FetchTrendingMoviesSuccess() async {
        // Given
        let optionSelection: OptionsSelection = .trending
        let query = ""
        let page = 1
        
        // When
        let expectation = self.expectation(description: "Fetch top movies")
        Task {
            do {
                let moviesData = try await dataService?.fetchMovies(optionSelected: optionSelection, query: query, page: page)
                expectation.fulfill()
                
                //Then
                XCTAssertGreaterThan(moviesData?.results?.count ?? 2, 2)
                XCTAssertNotNil(moviesData)
                XCTAssertEqual(moviesData?.results?.count, 20)
                XCTAssertEqual(moviesData?.page, 1)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    func test_MainVM_FetchNowPlayingMoviesSuccess() async {
        // Given
        let optionSelection: OptionsSelection = .nowPlaying
        let query = ""
        let page = 1
        
        // When
        let expectation = self.expectation(description: "Fetch top movies")
        Task {
            do {
                let moviesData = try await dataService?.fetchMovies(optionSelected: optionSelection, query: query, page: page)
                expectation.fulfill()
                
                //Then
                XCTAssertGreaterThan(moviesData?.results?.count ?? 2, 2)
                XCTAssertNotNil(moviesData)
                XCTAssertEqual(moviesData?.results?.count, 20)
                XCTAssertEqual(moviesData?.page, 1)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
    
    func test_MainVM_FetchSuggestionsSuccess() async {
        //when
        let expectation = self.expectation(description: "Fetch suggestions")
        Task {
            do {
                let movies = try await dataService?.fetchMultipleSuggestions(ids: ["1817", "745", "769", "278", "429"])
                expectation.fulfill()
                
                //Then
                XCTAssertGreaterThan(movies?.count ?? 2, 2)
                XCTAssertNotNil(movies)
                XCTAssertEqual(movies?.count, 5)
            } catch {
                XCTFail()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0, enforceOrder: true)
    }
}
